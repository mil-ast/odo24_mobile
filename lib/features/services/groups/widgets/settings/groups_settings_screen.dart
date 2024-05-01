import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/features/services/groups/bloc/groups_cubit.dart';
import 'package:odo24_mobile/features/services/groups/bloc/groups_states.dart';

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
        child: BlocConsumer<GroupsCubit, GroupsState>(
          listener: (context, state) {
            /* if (state is GroupsSettingsShowEditGroupState) {
              showDialog<bool>(
                context: context,
                builder: (_) => BlocProvider.value(
                  value: context.read<GroupsCubit>(),
                  child: SimpleDialog(
                    title: const Text('Редактирование группы'),
                    contentPadding: const EdgeInsets.all(26),
                    children: [
                      GroupUpdateWidget(
                        state.group,
                      ),
                    ],
                  ),
                ),
              ).then((value) {
                setState(() {});
              });
            } else if (state is GroupsSettingsShowCreateGroupState) {
              showDialog<GroupModel?>(
                context: context,
                builder: (_) => BlocProvider.value(
                  value: context.read<GroupsCubit>(),
                  child: SimpleDialog(
                    title: const Text('Добавление новой группы'),
                    contentPadding: const EdgeInsets.all(26),
                    children: [
                      GroupCreateWidget(),
                    ],
                  ),
                ),
              ).then((group) {
                if (group != null) {
                  setState(() {});
                }
              });
            } else if (state is GroupsSettingsDeleteGroupConfirmationState) {
              showConfirmationDialog(
                context,
                title: 'Удаление группы',
                message: 'Удалить группу "${state.group.name}"?',
                btnOkText: 'Удалить',
                btnNoText: 'Отмена',
              ).then((isOk) {
                if (isOk == true) {
                  context.read<GroupsSettingsCubit>().delete(state.group);
                }
              });
            } else if (state is GroupsDeleteSuccessState) {
              widget.groups.remove(state.group);
              setState(() {});
            } else if (state is GroupsSettingsSuccessState) {
              context.read<GroupsCubit>().updateSortGroups(state.groups, state.start);
            } */
          },
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
                                //context.read<GroupsSettingsCubit>().onClickEditGroup(item);
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
