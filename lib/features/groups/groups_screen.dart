import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/shared_widgets/app_card/app_card.dart';
import 'package:odo24_mobile/core/shared_widgets/dialogs/confirmation_dialog.dart';
import 'package:odo24_mobile/core/shared_widgets/dialogs/error_dialog.dart';
import 'package:odo24_mobile/core/shared_widgets/dialogs/fullscreen_dialog.dart';
import 'package:odo24_mobile/core/shared_widgets/scaffold/app_scaffold.dart';
import 'package:odo24_mobile/features/cars/data/models/car_model.dart';
import 'package:odo24_mobile/features/dependencies_scope.dart';
import 'package:odo24_mobile/features/groups/bloc/groups_cubit.dart';
import 'package:odo24_mobile/features/groups/data/models/group_model.dart';
import 'package:odo24_mobile/features/groups/group_item_widget.dart';
import 'package:odo24_mobile/features/groups/groups_dependencies.dart';
import 'package:odo24_mobile/features/groups/widgets/first_group_create_widget.dart';
import 'package:odo24_mobile/features/groups/widgets/group_create_widget.dart';
import 'package:odo24_mobile/features/groups/widgets/group_update_dialog.dart';
import 'package:odo24_mobile/features/groups/widgets/hint_for_sorting_groups.dart';
import 'package:odo24_mobile/features/services/services_screen.dart';

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

  static Future<void> open(BuildContext context, {required CarModel selectedCar}) => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => GroupsDependenciesScope(
        dependencies: GroupsDependencies(selectedCar: selectedCar),
        child: const GroupsScreenScope(child: GroupsScreen()),
      ),
    ),
  );

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<GroupsCubit>().getAllGroups();
  }

  @override
  Widget build(BuildContext context) {
    final selectedCar = GroupsDependenciesScope.of(context).selectedCar;
    return BlocConsumer<GroupsCubit, GroupsState>(
      listenWhen: (previous, current) => !current.needBuild,
      listener: (context, state) async {
        switch (state) {
          case GroupsOnSelectState():
            final selectedCar = GroupsDependenciesScope.of(context).selectedCar;
            ServicesScreen.open(context, selectedCar: selectedCar, selectedGroup: state.group);
          case GroupsActionShowCreateDialogState():
            showFullScreenDialog(
              context,
              title: 'Добавить группу',
              body: BlocProvider.value(value: context.read<GroupsCubit>(), child: const GroupCreateWidget()),
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
          case GroupsCreateSuccessState():
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Группа успешно добавлена!')));
          case GroupsUpdateSuccessState():
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Группа успешно изменена!')));
          case GroupsDeleteSuccessState():
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Группа успешно удалена!')));
          case GroupsFailureState():
            showErrorDialog(context, title: 'Ошибка', message: state.message);
          default:
        }
      },
      buildWhen: (previous, current) => current.needBuild,
      builder: (context, state) => switch (state) {
        GroupsWaitingState() => const Center(child: CircularProgressIndicator()),
        GroupsLoadedState() => ListGroupsWidget(selectedCar: selectedCar, groups: state.groups),
        _ => CreateFirstGroupWidget(selectedCar: selectedCar),
      },
    );
  }
}

class ListGroupsWidget extends StatefulWidget {
  final CarModel selectedCar;
  final List<GroupModel> groups;
  const ListGroupsWidget({required this.selectedCar, required this.groups, super.key});

  @override
  State<ListGroupsWidget> createState() => _ListGroupsWidgetState();
}

class _ListGroupsWidgetState extends State<ListGroupsWidget> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: widget.selectedCar.name,
      subTitle: 'Группы',
      floatingActionButton: FloatingActionButton(
        onPressed: context.read<GroupsCubit>().openFormCreateGroup,
        child: const Icon(Icons.add),
      ),
      body: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white),
        child: ReorderableListView(
          header: null,
          onReorder: (int oldIndex, int newIndex) {
            setState(() {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }

              final item = widget.groups.removeAt(oldIndex);
              widget.groups.insert(newIndex, item);

              context.read<GroupsCubit>().updateSortGroups(widget.groups);
            });
          },
          footer: const Column(children: [HintForSortingGroups(), SizedBox(height: 40)]),
          children: widget.groups
              .map((group) => GroupItemWidget(key: ValueKey<int>(group.groupID), group: group))
              .toList(),
        ),
      ),
    );
  }
}

class CreateFirstGroupWidget extends StatelessWidget {
  final CarModel selectedCar;
  const CreateFirstGroupWidget({required this.selectedCar, super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: selectedCar.name,
      body: const SingleChildScrollView(
        child: Column(
          children: [
            AppCard(
              title: AppCardTitle(title: 'Добавить группу'),
              child: FirstGroupCreateWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
