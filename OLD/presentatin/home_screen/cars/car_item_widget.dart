import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/presentatin/car_screen/car_screen.dart';
import 'package:odo24_mobile/presentatin/home_screen/cars/cars_cubit.dart';
import 'package:odo24_mobile/domain/services/cars/models/car.model.dart';
import 'package:odo24_mobile/presentatin/home_screen/cars/edit_miliage/edit_miliage_widget.dart';

class CarItemWidget extends StatelessWidget {
  final CarModel car;

  const CarItemWidget(this.car, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CarsCubit, AppState>(
      listenWhen: (previous, current) => current is ShowEditMiliageState,
      listener: (context, state) {
        if (state is ShowEditMiliageState) {
          showDialog<bool>(
            context: context,
            builder: (_) => BlocProvider.value(
              value: context.read<CarsCubit>(),
              child: SimpleDialog(
                title: const Text('Изменить пробег'),
                contentPadding: const EdgeInsets.all(26),
                children: [
                  EditMiliageWidget(
                    state.car,
                  ),
                ],
              ),
            ),
          );
        }
      },
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CarScreen(car),
            ),
          ).then((value) {
            context.read<CarsCubit>().refreshCarList();
          });
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(6)),
            border: Border.all(
              color: const Color(0xfff3f3f3),
            ),
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(top: 10, right: 10, bottom: 10, left: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 5),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.transparent,
                  ),
                  color: Theme.of(context).primaryColor.withAlpha(30),
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                ),
                padding: const EdgeInsets.all(10),
                child: Icon(
                  Icons.directions_car_sharp,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          car.name,
                          style: const TextStyle(fontSize: 20),
                        ),
                        PopupMenuButton(
                          elevation: 10,
                          shape: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black12, width: 1)),
                          icon: const Icon(Icons.more_vert),
                          itemBuilder: (ctx) => [
                            PopupMenuItem(
                              child: const ListTile(
                                leading: Icon(Icons.edit),
                                title: Text('Изменить'),
                              ),
                              onTap: () {
                                context.read<CarsCubit>().onClickUpdateCar(car);
                              },
                            ),
                            PopupMenuItem(
                              child: const ListTile(
                                leading: Icon(Icons.delete, color: Colors.red),
                                title: Text(
                                  'Удалить',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                              onTap: () {
                                context.read<CarsCubit>().onClickDeleteCar(car);
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Expanded(
                          flex: 1,
                          child: Text(
                            'Записей в книжке',
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            car.servicesTotal.toString(),
                            style: const TextStyle(color: Color(0xFF1fc18a)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Пробег',
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              context.read<CarsCubit>().onClickEditMiliage(car);
                            },
                            child: Wrap(
                              spacing: 4,
                              children: [
                                Text(
                                  '${car.odo} км',
                                  style: const TextStyle(
                                    color: Color(0xFF298ce7),
                                  ),
                                ),
                                const Icon(
                                  Icons.edit,
                                  color: Color(0xAA298ce7),
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
