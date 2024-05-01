import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/presentatin/home_screen/form_car_create.widget.dart';
import 'package:odo24_mobile/presentatin/home_screen/cars/car_item_widget.dart';
import 'package:odo24_mobile/presentatin/home_screen/cars/cars_cubit.dart';
import 'package:odo24_mobile/presentatin/home_screen/cars/create/car_create_widget.dart';
import 'package:odo24_mobile/presentatin/home_screen/cars/update/car_update_widget.dart';
import 'package:odo24_mobile/domain/services/auth/auth_service.dart';
import 'package:odo24_mobile/shared_widgets/dialogs/confirmation_dialog.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CarsCubit()..getAllCars(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text('ODO24 Сервисная книжка авто'),
          actions: [
            IconButton(
              onPressed: AuthService().logout,
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton(
            onPressed: context.read<CarsCubit>().onClickCreateCar,
            child: const Icon(Icons.add),
          ),
        ),
        body: BlocConsumer<CarsCubit, AppState>(
          listenWhen: (previous, current) => current is ListenCarsState || current is AppStateError,
          listener: (context, state) {
            if (state is ShowUpdateCarState) {
              showDialog<bool>(
                context: context,
                builder: (_) => BlocProvider.value(
                  value: context.read<CarsCubit>(),
                  child: SimpleDialog(
                    title: const Text('Редактирование авто'),
                    contentPadding: const EdgeInsets.all(26),
                    children: [
                      CarUpdateWidget(
                        state.car,
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is ShowCreateCarState) {
              showDialog(
                context: context,
                builder: (_) => BlocProvider.value(
                  value: context.read<CarsCubit>(),
                  child: SimpleDialog(
                    title: const Text('Добавление авто'),
                    contentPadding: const EdgeInsets.all(26),
                    children: [
                      CarCreateWidget(),
                    ],
                  ),
                ),
              );
            } else if (state is CarCreateSuccessState) {
              const SnackBar(
                content: Text('Авто успешно добавлено'),
              );
            } else if (state is ConfirmationDeleteCarState) {
              showConfirmationDialog(
                context,
                title: 'Удаление авто',
                message: 'Вы действительно хотите удалить ваш автомобиль "${state.car.name}" со всеми записями?',
              ).then((isOk) {
                if (isOk == true) {
                  context.read<CarsCubit>().delete(state.car);
                }
              });
            }
          },
          buildWhen: (previous, current) => current is BuildCarsState || current is AppStateLoading,
          builder: (context, state) {
            if (state is AppStateLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is CarsState && state.cars.isNotEmpty) {
              return ListView.builder(
                itemCount: state.cars.length,
                itemBuilder: (context, i) => CarItemWidget(state.cars[i]),
              );
            }

            return FormCarCreateWidget();
          },
        ),
      ),
    );
  }
}
