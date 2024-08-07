import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:odo24_mobile/core/extensions/number_format_extension.dart';
import 'package:odo24_mobile/features/cars/bloc/cars_cubit.dart';
import 'package:odo24_mobile/features/cars/data/models/car_model.dart';

class CarItemWidget extends StatelessWidget {
  final CarModel car;

  const CarItemWidget({required this.car, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final numberFmt = NumberFormat.decimalPattern();

    final titleTextTheme = theme.textTheme.bodyMedium?.copyWith(color: Colors.black54);

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
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
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
                        style: theme.textTheme.titleLarge,
                      ),
                      PopupMenuButton(
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
                              context.read<CarsCubit>().onClickDeleteCar(car);
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Text(
                          'Записей в книжке',
                          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black54),
                        ),
                      ),
                      Expanded(
                        flex: 3,
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
                        flex: 4,
                        child: Text(
                          'Пробег',
                          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black54),
                        ),
                      ),
                      Expanded(
                        flex: 3,
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
                  if (car.carExtraDataModel.isNotEmpty) ...[
                    const Text('До ближайшего обслуживания:'),
                    const SizedBox(height: 10),
                    ListView.separated(
                      itemBuilder: (context, index) {
                        final e = car.carExtraDataModel[index];
                        final nextOdoInfo = e.calculateLeftODO(car.odo);
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 4,
                              child: Text(
                                e.groupName,
                                style: titleTextTheme,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: nextOdoInfo.colorLevel.color,
                                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 2),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 40, right: 10),
                                  child: Text('${nextOdoInfo.leftDistance.format()} км'),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(height: 8),
                      itemCount: car.carExtraDataModel.length,
                      shrinkWrap: true,
                    ),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
