import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/extensions/number_format_extension.dart';
import 'package:odo24_mobile/core/shared_widgets/dialogs/confirmation_dialog.dart';
import 'package:odo24_mobile/features/cars/data/models/car_model.dart';
import 'package:odo24_mobile/features/dependencies_scope.dart';
import 'package:odo24_mobile/features/services/bloc/services_cubit.dart';
import 'package:odo24_mobile/features/services/bloc/services_states.dart';
import 'package:odo24_mobile/features/services/widgets/groups/bloc/groups_cubit.dart';
import 'package:odo24_mobile/features/services/widgets/groups/bloc/groups_states.dart';
import 'package:odo24_mobile/features/services/widgets/groups/groups_selector_widget.dart';
import 'package:odo24_mobile/features/services/widgets/groups/widgets/first_group_create/first_group_create_widget.dart';
import 'package:odo24_mobile/features/services/widgets/groups/widgets/settings/groups_settings_screen.dart';
import 'package:odo24_mobile/features/services/widgets/groups/widgets/settings/widgets/group_create_dialog.dart';
import 'package:odo24_mobile/features/services/widgets/groups/widgets/settings/widgets/group_update_dialog.dart';
import 'package:odo24_mobile/features/services/widgets/service/service_item_widget.dart';
import 'package:odo24_mobile/features/services/widgets/service/widgets/create/service_create_dialog.dart';
import 'package:odo24_mobile/features/services/widgets/service/widgets/update/service_update_dialog.dart';

class ServicesScreen extends StatelessWidget {
  final CarModel selectedCar;
  final _currentCarODO = ValueNotifier<int>(0);

  ServicesScreen({
    required this.selectedCar,
    super.key,
  }) {
    _currentCarODO.value = selectedCar.odo;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => GroupsCubit(
            groupsRepository: DependenciesScope.of(context).groupsRepository,
          )..getAllGroups(),
        ),
        BlocProvider(
          create: (_) {
            final dependencies = DependenciesScope.of(context);
            return ServicesCubit(
              selectedCar: selectedCar,
              servicesRepository: dependencies.servicesRepository,
              carsRepository: dependencies.carsRepository,
            );
          },
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<GroupsCubit, GroupsState>(
            listener: (context, state) async {
              if (state is GroupsMessageState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                  ),
                );
              } else if (state is OnChangeSelectedGroupState) {
                // при изменении групп обновляем записи
                context.read<ServicesCubit>().onChangeSelectedGroup(state.selected!);
              } else if (state is GroupsActionState) {
                switch (state.action) {
                  case GroupAction.openSettings:
                    final cb = context.read<GroupsCubit>().refresh;
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: context.read<GroupsCubit>(),
                          child: const GroupsSettingsScreen(),
                        ),
                        fullscreenDialog: false,
                      ),
                    );
                    cb.call();
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
                    final cb = context.read<GroupsCubit>().delete;
                    final isOk = await showConfirmationDialog(
                      context,
                      title: 'Удаление группы',
                      message: 'Вы действительно хотите удалить группу "${state.group?.name}" и все записи из неё?',
                    );
                    if (isOk == true) {
                      cb.call(state.group!);
                    }
                }
              }
            },
          ),
          BlocListener<ServicesCubit, ServicesState>(
            listener: (context, state) async {
              if (state is ServiceMessageState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                  ),
                );
              } else if (state is ServiceErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ),
                );
              } else if (state is ServiceActionState) {
                switch (state.action) {
                  case ServiceAction.create:
                    final selectedGroup = context.read<GroupsCubit>().getSelected();
                    if (selectedGroup == null) {
                      return;
                    }
                    showDialog(
                      context: context,
                      builder: (_) => Dialog.fullscreen(
                        child: BlocProvider.value(
                          value: context.read<ServicesCubit>(),
                          child: ServiceRecCreateWidget(
                            car: selectedCar,
                            selectedGroup: selectedGroup,
                          ),
                        ),
                      ),
                    );
                  case ServiceAction.update:
                    showDialog(
                      context: context,
                      builder: (_) => Dialog.fullscreen(
                        child: BlocProvider.value(
                          value: context.read<ServicesCubit>(),
                          child: ServiceUpdateDialog(
                            service: state.service!,
                          ),
                        ),
                      ),
                    );
                  case ServiceAction.delete:
                    final isOk = await showConfirmationDialog(
                      context,
                      title: 'Удаление группы',
                      message: 'Вы действительно хотите удалить запись?',
                    );
                    if ((isOk ?? false) && context.mounted) {
                      context.read<ServicesCubit>().delete(state.service!);
                    }
                }
              } else if (state is ServiceCarODOAutoUpdateState) {
                // если автоматически обновили пробег авто
                _currentCarODO.value = state.newODO;
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
                const SizedBox(height: 2),
                ValueListenableBuilder(
                  valueListenable: _currentCarODO,
                  builder: (context, value, child) =>
                      Text('${value.format()} км', style: const TextStyle(color: Colors.white60)),
                ),
              ],
            ),
          ),
          floatingActionButton: BlocBuilder<ServicesCubit, ServicesState>(
            buildWhen: (previous, current) => current.needBuild,
            builder: (context, state) {
              return FloatingActionButton(
                onPressed: context.read<ServicesCubit>().openFormCreateService,
                child: const Icon(Icons.add),
              );
            },
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
              Expanded(
                child: BlocBuilder<ServicesCubit, ServicesState>(
                  buildWhen: (previous, current) => current.needBuild,
                  builder: (context, state) {
                    if (state is ServicesLoadingState) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is ServicesShowListState) {
                      if (state.services.isEmpty) {
                        return SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                              child: Column(
                                children: [
                                  const Text('Записей ещё нет'),
                                  const SizedBox(height: 20),
                                  TextButton.icon(
                                    onPressed: context.read<ServicesCubit>().openFormCreateService,
                                    icon: const Icon(Icons.add),
                                    label: const Text('Добавить первую запись'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                      if (state.inform != null) {
                        return ListView.builder(
                          itemCount: state.services.length + 1,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              final factor = state.inform!.factor;
                              return ListTile(
                                tileColor: state.inform!.colorLevel.color,
                                title: Row(
                                  children: [
                                    Text('Осталось ${state.inform!.leftDistance.format()} км'),
                                    const Spacer(),
                                    Text('${(factor * 100).round()}%'),
                                  ],
                                ),
                                subtitle: const Text('До следующей замены'),
                              );
                            }
                            return ServiceItemWidget(state.services[index - 1]);
                          },
                        );
                      }
                      return ListView.builder(
                        itemCount: state.services.length,
                        itemBuilder: (context, index) {
                          return ServiceItemWidget(state.services[index]);
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
