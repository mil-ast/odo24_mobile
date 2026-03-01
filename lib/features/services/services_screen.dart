import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/shared_widgets/dialogs/confirmation_dialog.dart';
import 'package:odo24_mobile/core/shared_widgets/dialogs/error_dialog.dart';
import 'package:odo24_mobile/core/shared_widgets/dialogs/fullscreen_dialog.dart';
import 'package:odo24_mobile/core/shared_widgets/scaffold/app_scaffold.dart';
import 'package:odo24_mobile/features/cars/data/models/car_model.dart';
import 'package:odo24_mobile/features/dependencies_scope.dart';
import 'package:odo24_mobile/features/groups/data/models/group_model.dart';
import 'package:odo24_mobile/features/services/bloc/services_cubit.dart';
import 'package:odo24_mobile/features/services/data/models/service_model.dart';
import 'package:odo24_mobile/features/services/service_item_widget.dart';
import 'package:odo24_mobile/features/services/services_dependencies.dart';
import 'package:odo24_mobile/features/services/widgets/service_create_dialog.dart';
import 'package:odo24_mobile/features/services/widgets/service_update_dialog.dart';

class ServicesScreenScope extends StatelessWidget {
  final Widget child;
  final CarModel selectedCar;
  final GroupModel selectedGroup;

  const ServicesScreenScope({required this.selectedCar, required this.selectedGroup, required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final dependencies = DependenciesScope.of(context);
    return BlocProvider(
      create: (context) => ServicesCubit(
        carsRepository: dependencies.carsRepository,
        servicesRepository: dependencies.servicesRepository,
        selectedCar: selectedCar,
        selectedGroup: selectedGroup,
      ),
      child: child,
    );
  }
}

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  static Future<void> open(BuildContext context, {required CarModel selectedCar, required GroupModel selectedGroup}) =>
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ServicesDependenciesScope(
            dependencies: ServicesDependencies(selectedCar: selectedCar, selectedGroup: selectedGroup),
            child: ServicesScreenScope(
              selectedCar: selectedCar,
              selectedGroup: selectedGroup,
              child: const ServicesScreen(),
            ),
          ),
        ),
      );

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<ServicesCubit>().getAllServices();
  }

  @override
  Widget build(BuildContext context) {
    final servicesDependencies = ServicesDependenciesScope.of(context);
    final selectedCar = servicesDependencies.selectedCar;
    final selectedGroup = servicesDependencies.selectedGroup;

    return AppScaffold(
      title: selectedCar.name,
      subTitle: selectedGroup.name,
      floatingActionButton: FloatingActionButton(
        onPressed: context.read<ServicesCubit>().openFormCreateService,
        child: const Icon(Icons.add),
      ),
      body: BlocConsumer<ServicesCubit, ServicesState>(
        listenWhen: (previous, current) => !current.needBuild,
        listener: (context, state) {
          switch (state) {
            case ServicesCreateSuccessState():
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Запись успешно добавлена!')));
            case ServicesUpdateSuccessState():
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Изменения успешно сохранены!')));
            case ServicesUpdateDeleteState():
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Запись успешно удалена!')));
            case ServicesFailureState():
              showErrorDialog(context, title: 'Ошибка', message: state.message);
            case ServicesActionShowCreateDialogState():
              showFullScreenDialog(
                context,
                title: 'Новая запись',
                body: BlocProvider.value(
                  value: context.read<ServicesCubit>(),
                  child: ServiceCreateWidget(selectedCar: selectedCar, selectedGroup: selectedGroup),
                ),
              );
            case ServicesActionShowUpdateDialogState():
              showFullScreenDialog(
                context,
                title: 'Изменить запись',
                body: BlocProvider.value(
                  value: context.read<ServicesCubit>(),
                  child: ServiceUpdateDialog(service: state.service, selectedGroup: selectedGroup),
                ),
              );
            case ServicesActionShowDeleteConfirmationDialogState():
              showConfirmationDialog(
                context,
                title: 'Удаление группы',
                message: 'Вы действительно хотите удалить запись?',
              ).then((isOk) {
                if ((isOk ?? false) && context.mounted) {
                  context.read<ServicesCubit>().delete(state.service);
                }
              });
            default:
          }
        },
        buildWhen: (previous, current) => current.needBuild,
        builder: (context, state) => switch (state) {
          ServicesLoadingState() => const Center(child: CircularProgressIndicator()),
          ServicesShowListState() => _ListServicesWidget(
            services: state.services,
            selectedGroupname: selectedGroup.name,
          ),
          _ => const SizedBox.shrink(),
        },
      ),
    );
  }
}

class _ListServicesWidget extends StatelessWidget {
  final List<ServiceModel> services;
  final String selectedGroupname;
  const _ListServicesWidget({required this.services, required this.selectedGroupname});

  @override
  Widget build(BuildContext context) {
    if (services.isNotEmpty) {
      return ListView.separated(
        itemCount: services.length,
        itemBuilder: (context, index) => ServiceItemWidget(services[index]),
        separatorBuilder: (BuildContext context, int index) =>
            ServiceItemSeparatorWidget(leftDistance: services[index].leftDistance),
      );
    }

    return Center(
      child: Column(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.comment, color: Colors.white),
          Text('Записей в группе нет :(', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white)),
          FilledButton(onPressed: context.read<ServicesCubit>().openFormCreateService, child: const Text('Добавить')),
        ],
      ),
    );
  }
}
