import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/shared_widgets/dialogs/error_dialog.dart';
import 'package:odo24_mobile/features/cars/bloc/cars_cubit.dart';
import 'package:odo24_mobile/features/cars/bloc/cars_states.dart';
import 'package:odo24_mobile/features/cars/car_item_widget.dart';
import 'package:odo24_mobile/features/cars/widgets/create/car_create_dialog.dart';
import 'package:odo24_mobile/features/cars/widgets/create/car_create_form_widget.dart';
import 'package:odo24_mobile/features/cars/widgets/edit/car_edit_form_dialog.dart';
import 'package:odo24_mobile/features/cars/widgets/edit_miliage/edit_miliage_widget.dart';
import 'package:odo24_mobile/features/dependencies_scope.dart';
import 'package:odo24_mobile/features/profile/profile_screen.dart';
import 'package:odo24_mobile/features/services/services_screen.dart';

class CarsScreen extends StatelessWidget {
  const CarsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final carsRepository = DependenciesScope.of(context).carsRepository;

    return BlocProvider(
      create: (context) => CarsCubit(carsRepository: carsRepository)..getAllCars(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).primaryColor,
          //title: const Text('Сервисная книжка авто'),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Сервисная книжка авто'),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.settings),
                color: Colors.white,
              ),
            ],
          ),
        ),
        floatingActionButton: BlocBuilder<CarsCubit, CarsState>(
          buildWhen: (previous, current) => current.needBuild,
          builder: (context, state) {
            if (state is CarsLoadedState && state.cars.isNotEmpty) {
              return FloatingActionButton(
                onPressed: context.read<CarsCubit>().openFormCreateCar,
                child: const Icon(Icons.add),
              );
            }
            return const SizedBox.shrink();
          },
        ),
        body: BlocConsumer<CarsCubit, CarsState>(
          listener: (BuildContext context, CarsState state) {
            if (state is CarActionState) {
              switch (state.action) {
                case CarAction.select:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ServicesScreen(selectedCar: state.car!),
                    ),
                  ).then((_) {
                    context.read<CarsCubit>().getAllCars();
                  });
                case CarAction.create:
                  showDialog(
                    context: context,
                    builder: (_) => Dialog.fullscreen(
                      child: BlocProvider.value(
                        value: context.read<CarsCubit>(),
                        child: const CarCreateDialog(),
                      ),
                    ),
                  );
                case CarAction.edit:
                  showDialog(
                    context: context,
                    builder: (_) => Dialog.fullscreen(
                      child: BlocProvider.value(
                        value: context.read<CarsCubit>(),
                        child: CarEditDialog(car: state.car!),
                      ),
                    ),
                  );
                case CarAction.editMiliage:
                  showDialog(
                    context: context,
                    builder: (_) => Dialog.fullscreen(
                      child: BlocProvider.value(
                        value: context.read<CarsCubit>(),
                        child: EditMiliageWidget(state.car!),
                      ),
                    ),
                  );
                case CarAction.delete:
                // TODO: Handle this case.
              }
            } else if (state is CarCreateSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Новый авто успешно добавлен!'),
                ),
              );
            } else if (state is CarUpdateSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Изменения успешно сохранены!'),
                ),
              );
            } else if (state is CarsErrorState) {
              showErrorDialog(context, title: 'Ошибка', message: state.message);
            }
          },
          buildWhen: (previous, current) => current.needBuild,
          builder: (context, state) {
            if (state is CarsWaitingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is CarsLoadedState && state.cars.isNotEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 0, 10),
                    child: Text(
                      'Мои авто',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.cars.length,
                      itemBuilder: (context, i) => CarItemWidget(car: state.cars[i]),
                    ),
                  ),
                ],
              );
            }

            return const SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(top: 40),
                child: CarCreateFormWidget(),
              ),
            );
          },
        ),
      ),
    );
  }
}
