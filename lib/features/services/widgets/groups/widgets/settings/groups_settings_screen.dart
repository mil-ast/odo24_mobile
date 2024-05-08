import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/features/services/widgets/groups/bloc/groups_cubit.dart';
import 'package:odo24_mobile/features/services/widgets/groups/bloc/groups_states.dart';

class GroupsSettingsScreen extends StatefulWidget {
  const GroupsSettingsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _GroupsSettingsState();
}

class _GroupsSettingsState extends State<GroupsSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройка сервисных групп'),
      ),
      floatingActionButton: Builder(builder: (context) {
        return FloatingActionButton(
          onPressed: context.read<GroupsCubit>().onClickCreateGroup,
          child: const Icon(Icons.add),
        );
      }),
      body: PrimaryScrollController(
        controller: ScrollController(),
        child: BlocBuilder<GroupsCubit, GroupsState>(
          buildWhen: (previous, current) => current.needBuild,
          builder: (context, state) {
            final groups = context.read<GroupsCubit>().groups;

            return ReorderableListView(
              header: const Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info,
                          color: Color(0xffffc006),
                          size: 36,
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Text(
                            'Удерживайте группу полсекунды и далее переместите ее в нужную позицию',
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              children: groups
                  .map(
                    (item) => ListTile(
                      key: ValueKey(item.groupID.toString()),
                      title: Text(item.name),
                      trailing: PopupMenuButton(
                        onSelected: (value) {},
                        child: const Icon(Icons.menu),
                        itemBuilder: (ctx) {
                          return [
                            PopupMenuItem(
                              onTap: () {
                                context.read<GroupsCubit>().onClickUpdateGroup(item);
                              },
                              child: const Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 10,
                                children: [
                                  Icon(Icons.edit),
                                  Text('Изменить'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              onTap: () {
                                context.read<GroupsCubit>().onClickDeleteGroup(item);
                              },
                              child: const Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 10,
                                children: [
                                  Icon(Icons.delete),
                                  Text('Удалить'),
                                ],
                              ),
                            ),
                          ];
                        },
                      ),
                    ),
                  )
                  .toList(),
              onReorder: (int start, int current) {
                if (start < current) {
                  final end = current - 1;
                  final startItem = groups[start];
                  int i = 0;
                  int local = start;
                  do {
                    groups[local] = groups[++local];
                    i++;
                  } while (i < end - start);
                  groups[end] = startItem;
                } else if (start > current) {
                  final startItem = groups[start];
                  for (int i = start; i > current; i--) {
                    groups[i] = groups[i - 1];
                  }
                  groups[current] = startItem;
                }

                setState(() {});
                context.read<GroupsCubit>().updateSortGroups(groups, start);
              },
            );
          },
        ),
      ),
    );
  }
}
