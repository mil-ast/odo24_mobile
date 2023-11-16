import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/presentatin/car_screen/groups_cubit.dart';
import 'package:odo24_mobile/presentatin/car_screen/groups/dialogs/group_create_dialog.dart';
import 'package:odo24_mobile/presentatin/car_screen/groups/dialogs/group_update_dialog.dart';
import 'package:odo24_mobile/presentatin/car_screen/groups/dialogs/groups_settings/groups_settings_cubit.dart';
import 'package:odo24_mobile/domain/services/groups/models/group.model.dart';
import 'package:odo24_mobile/shared_widgets/dialogs/confirmation_dialog.dart';

class GroupsSettingsDialog extends StatefulWidget {
  final List<GroupModel> groups;
  final GroupsCubit groupsCubit;

  const GroupsSettingsDialog(this.groupsCubit, this.groups, {super.key});

  @override
  GroupsSettingsDialogState createState() {
    return GroupsSettingsDialogState();
  }
}

class GroupsSettingsDialogState extends State<GroupsSettingsDialog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройка сервисных групп'),
      ),
      body: PrimaryScrollController(
        controller: ScrollController(),
        child: BlocProvider(
          create: (context) => GroupsSettingsCubit(widget.groupsCubit),
          child: BlocConsumer<GroupsSettingsCubit, AppState>(
            listenWhen: (previous, current) => current is GroupsSettingsListenState,
            listener: (context, state) {
              if (state is GroupsSettingsShowEditGroupState) {
                showDialog<bool>(
                  context: context,
                  builder: (BuildContext ctx) => SimpleDialog(
                    title: const Text('Редактирование группы'),
                    contentPadding: const EdgeInsets.all(26),
                    children: [
                      GroupUpdateWidget(
                        state.group,
                        widget.groupsCubit,
                      ),
                    ],
                  ),
                ).then((value) {
                  setState(() {});
                });
              } else if (state is GroupsSettingsShowCreateGroupState) {
                showDialog<GroupModel?>(
                  context: context,
                  builder: (BuildContext ctx) => SimpleDialog(
                    title: const Text('Добавление новой группы'),
                    contentPadding: const EdgeInsets.all(26),
                    children: [
                      GroupCreateWidget(widget.groupsCubit),
                    ],
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
              }
            },
            buildWhen: (previous, current) => current is GroupsSettingsBuildState,
            builder: (context, state) {
              return ReorderableListView(
                header: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: const [
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
                    FilledButton(
                      onPressed: () {
                        context.read<GroupsSettingsCubit>().onClickCreateGroup();
                      },
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 10,
                        children: const [Icon(Icons.create), Text('Добавить группу')],
                      ),
                    ),
                  ],
                ),
                children: widget.groups
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
                                  context.read<GroupsSettingsCubit>().onClickEditGroup(item);
                                },
                                child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: 10,
                                  children: const [
                                    Icon(Icons.edit),
                                    Text('Изменить'),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                onTap: () {
                                  context.read<GroupsSettingsCubit>().onClickDeleteGroup(item);
                                },
                                child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: 10,
                                  children: const [
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
                    final startItem = widget.groups[start];
                    int i = 0;
                    int local = start;
                    do {
                      widget.groups[local] = widget.groups[++local];
                      i++;
                    } while (i < end - start);
                    widget.groups[end] = startItem;
                  } else if (start > current) {
                    final startItem = widget.groups[start];
                    for (int i = start; i > current; i--) {
                      widget.groups[i] = widget.groups[i - 1];
                    }
                    widget.groups[current] = startItem;
                  }

                  context.read<GroupsSettingsCubit>().updateSortGroups(widget.groups, start);

                  setState(() {});
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
