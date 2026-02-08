import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/shared_widgets/scaffold/app_scaffold.dart';
import 'package:odo24_mobile/features/cars/data/models/car_model.dart';
import 'package:odo24_mobile/features/dependencies_scope.dart';
import 'package:odo24_mobile/features/groups/data/models/group_model.dart';
import 'package:odo24_mobile/features/services/bloc/services_cubit.dart';
import 'package:odo24_mobile/features/services/service_item_widget.dart';
import 'package:odo24_mobile/features/services/services_dependencies.dart';

class ServicesScreenScope extends StatelessWidget {
  final Widget child;

  const ServicesScreenScope({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final dependencies = DependenciesScope.of(context);
    return BlocProvider(
      create: (context) => ServicesCubit(
        carsRepository: dependencies.carsRepository,
        servicesRepository: dependencies.servicesRepository,
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
            child: const ServicesScreenScope(child: ServicesScreen()),
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

    final servicesDependencies = ServicesDependenciesScope.of(context);
    context.read<ServicesCubit>().getAllServices(
      selectedCar: servicesDependencies.selectedCar,
      selectedGroup: servicesDependencies.selectedGroup,
    );
  }

  @override
  Widget build(BuildContext context) {
    final servicesDependencies = ServicesDependenciesScope.of(context);
    final selectedCar = servicesDependencies.selectedCar;
    final selectedGroup = servicesDependencies.selectedGroup;

    return AppScaffold(
      title: selectedCar.name,
      subTitle: selectedGroup.name,
      body: BlocConsumer<ServicesCubit, ServicesState>(
        listener: (context, state) {},
        buildWhen: (previous, current) => current.needBuild,
        builder: (context, state) {
          return switch (state) {
            ServicesLoadingState() => const Center(child: CircularProgressIndicator()),
            ServicesShowListState() => ListView.separated(
              itemCount: state.services.length,
              itemBuilder: (context, index) => ServiceItemWidget(state.services[index]),
              separatorBuilder: (BuildContext context, int index) =>
                  ServiceItemSeparatorWidget(leftDistance: state.services[index].leftDistance),
            ),
            _ => const SizedBox.shrink(),
          };
        },
      ),
    );
  }
}
