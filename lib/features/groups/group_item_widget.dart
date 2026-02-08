import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/features/groups/bloc/groups_cubit.dart';
import 'package:odo24_mobile/features/groups/data/models/group_model.dart';

class GroupItemWidget extends StatelessWidget {
  final GroupModel group;
  const GroupItemWidget({required this.group, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(group.name, overflow: TextOverflow.fade),
      contentPadding: const EdgeInsets.only(top: 6, right: 4, bottom: 6, left: 20),
      onTap: () {
        context.read<GroupsCubit>().onSelectGroup(group);
      },
      trailing: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (ctx) => [
              PopupMenuItem(
                child: const ListTile(leading: Icon(Icons.edit), title: Text('Изменить')),
                onTap: () {
                  context.read<GroupsCubit>().showUpdateDialog(group);
                },
              ),
              PopupMenuItem(
                child: const ListTile(
                  leading: Icon(Icons.delete, color: Colors.red),
                  title: Text('Удалить', style: TextStyle(color: Colors.red)),
                ),
                onTap: () {
                  context.read<GroupsCubit>().showDeleteConfirmDialog(group);
                },
              ),
            ],
          ),
          const Icon(Icons.chevron_right_outlined, color: Colors.grey),
        ],
      ),
    );
  }
}
