import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/shared_widgets/app_card/app_card.dart';
import 'package:odo24_mobile/core/shared_widgets/dialogs/confirmation_dialog.dart';
import 'package:odo24_mobile/core/shared_widgets/dialogs/error_dialog.dart';
import 'package:odo24_mobile/core/shared_widgets/dialogs/fullscreen_dialog.dart';
import 'package:odo24_mobile/core/shared_widgets/scaffold/app_scaffold.dart';
import 'package:odo24_mobile/core/theme/color_scheme.dart';
import 'package:odo24_mobile/features/cars/cars_dependencies_scope.dart';
import 'package:odo24_mobile/features/dependencies_scope.dart';
import 'package:odo24_mobile/features/groups/bloc/groups_cubit.dart';
import 'package:odo24_mobile/features/groups/widgets/first_group_create_widget.dart';
import 'package:odo24_mobile/features/groups/widgets/group_create_widget.dart';
import 'package:odo24_mobile/features/groups/widgets/group_update_dialog.dart';

class GroupsScreenScope extends StatelessWidget {
  final Widget child;

  const GroupsScreenScope({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final groupsRepository = DependenciesScope.of(context).groupsRepository;
    return BlocProvider(
      create: (context) => GroupsCubit(groupsRepository: groupsRepository),
      child: child,
    );
  }
}

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GroupsCubit>().getAllGroups();
  }

  @override
  Widget build(BuildContext context) {
    final selectedCar = CarsDependenciesScope.of(context).selectedCar;
    return BlocConsumer<GroupsCubit, GroupsState>(
      listenWhen: (previous, current) => !current.needBuild,
      listener: (context, state) async {
        switch (state) {
          case GroupsOnSelectState():
            print(state.group);
          /* Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CarsDependenciesScope(
                    selectedCar: state.car,
                    child: const GroupsScreenScope(child: GroupsScreen()),
                  ),
                ),
              ); */
          case GroupsActionShowCreateDialogState():
            showFullScreenDialog(
              context,
              title: 'Добавить группу',
              body: BlocProvider.value(value: context.read<GroupsCubit>(), child: GroupCreateWidget()),
            );
          case GroupsActionShowUpdateDialogState():
            showFullScreenDialog(
              context,
              title: 'Изменить группу',
              body: BlocProvider.value(value: context.read<GroupsCubit>(), child: GroupUpdateWidget(state.group)),
            );
          case GroupsDeleteShowConfirmDialogState():
            final confirm = await showConfirmationDialog(
              context,
              title: 'Удаление группы',
              message: 'Вы действительно хотите удалить группу ${state.group.name} и все записи в ней?',
            );
            if (confirm == true && context.mounted) {
              context.read<GroupsCubit>().delete(state.group);
            }
          case GroupsErrorState():
            showErrorDialog(context, title: 'Ошибка', message: state.message);
          default:
        }
      },
      buildWhen: (previous, current) => current.needBuild,
      builder: (context, state) {
        if (state is GroupsWaitingState) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is GroupsLoadedState && state.groups.isNotEmpty) {
          return AppScaffold(
            title: selectedCar.name,
            floatingActionButton: FloatingActionButton(
              onPressed: context.read<GroupsCubit>().openFormCreateGroup,
              child: const Icon(Icons.add),
            ),
            body: ColoredBox(
              color: Colors.white,
              child: ReorderableListView(
                header: const Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  margin: EdgeInsets.only(bottom: 20),
                  color: ODO24Colors.actions,
                  child: Padding(
                    padding: EdgeInsetsGeometry.all(10),
                    child: Row(
                      spacing: 20,
                      children: [
                        Icon(Icons.info, color: ODO24Colors.inverseTextColor, size: 36),
                        Expanded(
                          child: Text(
                            'Удерживайте группу полсекунды и далее переместите ее в нужную позицию',
                            style: TextStyle(color: ODO24Colors.inverseTextColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                onReorder: (int oldIndex, int newIndex) {
                  setState(() {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }

                    final item = state.groups.removeAt(oldIndex);
                    state.groups.insert(newIndex, item);

                    context.read<GroupsCubit>().updateSortGroups(state.groups);
                  });
                },
                footer: const SizedBox(height: 40),
                children: state.groups
                    .map(
                      (item) => ListTile(
                        key: ValueKey(item.groupID.toString()),
                        title: Text(item.name, overflow: TextOverflow.fade),
                        contentPadding: const EdgeInsets.only(top: 6, right: 4, bottom: 6, left: 20),
                        onTap: () {
                          context.read<GroupsCubit>().onSelectGroup(item);
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
                                    context.read<GroupsCubit>().showUpdateDialog(item);
                                  },
                                ),
                                PopupMenuItem(
                                  child: const ListTile(
                                    leading: Icon(Icons.delete, color: Colors.red),
                                    title: Text('Удалить', style: TextStyle(color: Colors.red)),
                                  ),
                                  onTap: () {
                                    context.read<GroupsCubit>().showDeleteConfirmDialog(item);
                                  },
                                ),
                              ],
                            ),
                            const Icon(Icons.chevron_right_outlined, color: Colors.grey),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          );
        }

        return AppScaffold(
          title: selectedCar.name,
          body: SingleChildScrollView(
            child: Column(
              children: [
                AppCard(
                  title: const AppCardTitle(title: 'Добавить группу'),
                  child: FirstGroupCreateWidget(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
