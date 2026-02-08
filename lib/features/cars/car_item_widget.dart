import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:odo24_mobile/core/extensions/number_format_extension.dart';
import 'package:odo24_mobile/core/shared_widgets/app_card/app_card.dart';
import 'package:odo24_mobile/core/theme/color_scheme.dart';
import 'package:odo24_mobile/features/cars/bloc/cars_cubit.dart';
import 'package:odo24_mobile/features/cars/data/models/car_model.dart';

class CarItemWidget extends StatelessWidget {
  final CarModel car;

  const CarItemWidget({required this.car, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final numberFmt = NumberFormat.decimalPattern();
    final titleTextTheme = theme.textTheme.bodyMedium;
    return InkWell(
      onTap: () {
        context.read<CarsCubit>().onSelectCar(car);
      },
      child: AppCard(
        title: AppCardTitle(
          title: car.name,
          action: PopupMenuButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            itemBuilder: (ctx) => [
              PopupMenuItem(
                child: const ListTile(leading: Icon(Icons.edit), title: Text('Изменить')),
                onTap: () {
                  context.read<CarsCubit>().openFormEditCar(car);
                },
              ),
              PopupMenuItem(
                child: const ListTile(
                  leading: Icon(Icons.delete, color: Colors.red),
                  title: Text('Удалить', style: TextStyle(color: Colors.red)),
                ),
                onTap: () {
                  context.read<CarsCubit>().onClickDeleteCar(car);
                },
              ),
            ],
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text('Записей в книжке', style: titleTextTheme)),
                      SizedBox(
                        width: 160,
                        child: Text(
                          numberFmt.format(car.servicesTotal),
                          textAlign: TextAlign.right,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: Text('Пробег', style: titleTextTheme)),
                      SizedBox(
                        width: 160,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            style: const ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.only(right: 0))),
                            onPressed: () {
                              context.read<CarsCubit>().openFormEditODO(car);
                            },
                            icon: const Icon(Icons.edit, size: 20),
                            label: Text('${numberFmt.format(car.odo)} км'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (car.carExtraDataModel.isNotEmpty) ...[
                    Text('Ближайшее обслуживание:', style: theme.textTheme.titleMedium),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final e = car.carExtraDataModel[index];
                        final nextOdoInfo = e.calculateLeftODO(car.odo);
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Text(e.groupName, style: titleTextTheme),
                              ),
                            ),
                            Container(
                              width: 120,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: nextOdoInfo.colorLevel.color,
                                borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10, right: 10),
                                child: Text(
                                  '${nextOdoInfo.leftDistance.format()} км',
                                  style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.inverseTextColor),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(height: 8),
                      itemCount: car.carExtraDataModel.length,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
