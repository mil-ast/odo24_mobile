import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/presentatin/home_screen/form_car_create.widget.dart';
import 'package:odo24_mobile/presentatin/home_screen/cars/car_item_widget.dart';
import 'package:odo24_mobile/presentatin/home_screen/cars/cars_cubit.dart';
import 'package:odo24_mobile/presentatin/home_screen/cars/create/car_create_widget.dart';
import 'package:odo24_mobile/presentatin/home_screen/cars/update/car_update_widget.dart';
import 'package:odo24_mobile/services/auth/auth_service.dart';
import 'package:odo24_mobile/shared_widgets/dialogs/confirmation_dialog.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('ODO24 Сервисная книжка авто'),
        actions: [
          IconButton(
            onPressed: () async {
              AuthService().logout();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: BlocProvider(
          create: (context) => CarsCubit()..getAllCars(),
          child: BlocConsumer<CarsCubit, AppState>(
            listenWhen: (previous, current) => current is ListenCarsState || current is AppStateError,
            listener: (context, state) {
              if (state is ShowUpdateCarState) {
                showDialog<bool>(
                  context: context,
                  builder: (BuildContext ctx) => SimpleDialog(
                    title: const Text('Редактирование авто'),
                    contentPadding: const EdgeInsets.all(26),
                    children: [
                      CarUpdateWidget(
                        state.car,
                        context.read<CarsCubit>(),
                      ),
                    ],
                  ),
                );
              } else if (state is ShowCreateCarState) {
                showDialog(
                  context: context,
                  builder: (BuildContext ctx) => SimpleDialog(
                    title: const Text('Добавление авто'),
                    contentPadding: const EdgeInsets.all(26),
                    children: [
                      CarCreateWidget(context.read<CarsCubit>()),
                    ],
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
              if (state is CarsState) {
                if (state.cars.isEmpty) {
                  return FormCarCreateWidget();
                }

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10, right: 10),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: FilledButton(
                          child: const Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 6,
                            children: [
                              Icon(Icons.add),
                              Text('Добавить авто'),
                            ],
                          ),
                          onPressed: () {
                            context.read<CarsCubit>().onClickCreateCar();
                          },
                        ),
                      ),
                    ),
                    ...state.cars.map((e) => CarItemWidget(e)).toList()
                  ],
                );
              }

              return FormCarCreateWidget();
            },
          ),
        ),
      ),
    );
  }
}
