import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:odo24_mobile/features/cars/bloc/cars_cubit.dart';
import 'package:odo24_mobile/features/cars/data/models/car_model.dart';

class CarItemWidget extends StatelessWidget {
  final CarModel car;

  const CarItemWidget({required this.car, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final numberFmt = NumberFormat.decimalPattern();

    return InkWell(
      onTap: () {
        context.read<CarsCubit>().onSelectCar(car);
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
        margin: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        car.name,
                        style: theme.textTheme.titleMedium,
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
                              context.read<CarsCubit>().openFormEditCar(car);
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
                              //context.read<CarsCubit>().openFormEditODO(car);
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Записей в книжке',
                          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black54),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 40),
                          child: Text(
                            numberFmt.format(car.servicesTotal),
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Пробег',
                          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black54),
                        ),
                      ),
                      Expanded(
                        child: Wrap(
                          spacing: 10,
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                context.read<CarsCubit>().openFormEditODO(car);
                              },
                              icon: const Icon(
                                Icons.edit,
                                color: Color(0xAA298ce7),
                                size: 20,
                              ),
                              label: Text(
                                '${numberFmt.format(car.odo)} км',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: const Color(0xFF298ce7),
                                ),
                              ),
                            ),
                          ],
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
    );
  }
}
