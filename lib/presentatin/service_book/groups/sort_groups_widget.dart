import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/presentatin/service_book/groups/groups_cubit.dart';
import 'package:odo24_mobile/presentatin/service_book/services/services_widget.dart';

class SortGroupsWidget extends StatefulWidget {
  final List<QueryDocumentSnapshot> groups;
  final QueryDocumentSnapshot carDoc;
  const SortGroupsWidget(this.groups, this.carDoc, {super.key});

  @override
  State<SortGroupsWidget> createState() => _SortGroupsWidgetState();
}

class _SortGroupsWidgetState extends State<SortGroupsWidget> {
  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      children: <Widget>[
        for (int index = 0; index < widget.groups.length; index += 1) _buildGroup(context, widget.groups[index], index)
      ],
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final item = widget.groups.removeAt(oldIndex);
          widget.groups.insert(newIndex, item);

          context.read<GroupsCubit>().saveOrder(widget.groups);
        });
      },
    );
  }

  Widget _buildGroup(BuildContext context, QueryDocumentSnapshot group, int index) {
    return Card(
      key: Key(index.toString()),
      elevation: 6,
      shadowColor: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Expanded(
              child: ReorderableDragStartListener(
                index: index,
                child: ListTile(
                  leading: const Icon(Icons.folder_open),
                  title: Text(group.get('name')),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                      return ServicesWidget(widget.carDoc, group);
                    }));
                  },
                ),
              ),
            ),
            Icon(
              Icons.drag_handle,
              color: Colors.black26,
            ),
            PopupMenuButton(
              elevation: 10,
              shape: OutlineInputBorder(borderSide: BorderSide(color: Colors.black12, width: 1)),
              icon: Icon(Icons.more_horiz),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Wrap(
                    spacing: 10,
                    children: [
                      Icon(Icons.edit),
                      Text('Изменить'),
                    ],
                  ),
                  onTap: () {
                    context.read<GroupsCubit>().onClickUpdateGroup(group);
                  },
                ),
                PopupMenuItem(
                  child: Wrap(
                    spacing: 10,
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      Text(
                        'Удалить',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                  onTap: () {
                    context.read<GroupsCubit>().onClickDeleteGroup(group);
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
