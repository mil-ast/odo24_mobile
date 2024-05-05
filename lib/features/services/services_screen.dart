import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/shared_widgets/dialogs/confirmation_dialog.dart';
import 'package:odo24_mobile/features/cars/data/models/car_model.dart';
import 'package:odo24_mobile/features/dependencies_scope.dart';
import 'package:odo24_mobile/features/services/widgets/groups/bloc/groups_cubit.dart';
import 'package:odo24_mobile/features/services/widgets/groups/bloc/groups_states.dart';
import 'package:odo24_mobile/features/services/widgets/groups/groups_selector_widget.dart';
import 'package:odo24_mobile/features/services/widgets/groups/widgets/first_group_create/first_group_create_widget.dart';
import 'package:odo24_mobile/features/services/widgets/groups/widgets/settings/groups_settings_screen.dart';
import 'package:odo24_mobile/features/services/widgets/groups/widgets/settings/widgets/group_create_dialog.dart';
import 'package:odo24_mobile/features/services/widgets/groups/widgets/settings/widgets/group_update_dialog.dart';

class ServicesScreen extends StatelessWidget {
  final CarModel selectedCar;
  const ServicesScreen({
    required this.selectedCar,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final groupsRepository = DependenciesScope.of(context).groupsRepository;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GroupsCubit(
            groupsRepository: groupsRepository,
          )..getAllGroups(),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<GroupsCubit, GroupsState>(
            listener: (context, state) {
              // при изменении групп обновляем записи
              if (state is GroupsMessageState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                  ),
                );
              } else if (state is ShowGroupsState) {
                if (state.groups.isNotEmpty && state.selected != null) {
                  // services.update(group_id: state.selected.groupID);
                }
              } else if (state is GroupsActionState) {
                switch (state.action) {
                  case GroupAction.openSettings:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: context.read<GroupsCubit>(),
                          child: const GroupsSettingsScreen(),
                        ),
                        fullscreenDialog: false,
                      ),
                    ).then((_) {
                      context.read<GroupsCubit>().refresh();
                    });
                  case GroupAction.create:
                    showDialog(
                      context: context,
                      builder: (_) => Dialog.fullscreen(
                        child: BlocProvider.value(
                          value: context.read<GroupsCubit>(),
                          child: GroupCreateWidget(),
                        ),
                      ),
                    );
                  case GroupAction.update:
                    showDialog(
                      context: context,
                      builder: (_) => Dialog.fullscreen(
                        child: BlocProvider.value(
                          value: context.read<GroupsCubit>(),
                          child: GroupUpdateWidget(state.group!),
                        ),
                      ),
                    );
                  case GroupAction.delete:
                    showConfirmationDialog(
                      context,
                      title: 'Удаление группы',
                      message: 'Вы действительно хотите удалить группу "${state.group?.name}" и все записи из неё?',
                    ).then((bool? isOk) {
                      if (isOk == true) {
                        context.read<GroupsCubit>().delete(state.group!);
                      }
                    });
                }
              }
            },
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  selectedCar.name,
                  style: const TextStyle(fontSize: 22),
                ),
                const SizedBox(height: 10),
                Text('${selectedCar.odo} км', style: const TextStyle(color: Colors.white60)),
              ],
            ),
          ),
          body: Column(
            children: [
              BlocBuilder<GroupsCubit, GroupsState>(
                buildWhen: (previous, current) => current.needBuild,
                builder: (context, state) {
                  if (state is LoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is ShowGroupsState) {
                    if (state.groups.isEmpty) {
                      return FirstGroupCreateWidget();
                    }
                    return GroupsSelectorWidget(state.groups, state.selected);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
