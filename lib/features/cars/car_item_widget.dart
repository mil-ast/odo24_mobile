import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:odo24_mobile/core/extensions/number_format_extension.dart';
import 'package:odo24_mobile/core/next_odo_information_level_enum.dart';
import 'package:odo24_mobile/core/shared_widgets/app_card/app_card.dart';
import 'package:odo24_mobile/core/theme/color_scheme.dart';
import 'package:odo24_mobile/features/cars/bloc/cars_cubit.dart';
import 'package:odo24_mobile/features/cars/data/models/car_model.dart';

class CarItemWidget extends StatelessWidget {
  final CarModel car;

  const CarItemWidget({required this.car, super.key});

  NextODOInformationColorLevel _accentColor(List<CarExtraDataModel> carExtraDataModel) {
    NextODOInformationColorLevel warnLevel = NextODOInformationColorLevel.normal;

    if (car.carExtraDataModel.isNotEmpty) {
      for (final item in car.carExtraDataModel) {
        final nextOdoInfo = item.calculateLeftODO(car.odo);
        if (nextOdoInfo.colorLevel < warnLevel) {
          warnLevel = nextOdoInfo.colorLevel;
        }
      }
    }
    return warnLevel;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final numberFmt = NumberFormat.decimalPattern();

    final titleTextTheme = theme.textTheme.bodyMedium;

    final accentColor = _accentColor(car.carExtraDataModel);
    //final titleColor = accentColor == NextODOInformationColorLevel.alarm ? Colors.white : theme.colorScheme.primary;

    return AppCard(
      title: AppCardTitle(
        title: 'Test',
        //titleColor: titleColor,
        backgroundColor: accentColor.color,
      ),
      child: Text('Text'),
    );

    return InkWell(
      onTap: () {
        context.read<CarsCubit>().onSelectCar(car);
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
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
                            style: titleTextTheme,
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
                    Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Text(
                            'Пробег',
                            style: titleTextTheme,
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
                                  size: 20,
                                ),
                                label: Text(
                                  '${numberFmt.format(car.odo)} км',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (car.carExtraDataModel.isNotEmpty) ...[
                      Text(
                        'До ближайшего обслуживания:',
                        style: theme.textTheme.titleMedium,
                      ),
                      ListView.separated(
                        itemBuilder: (context, index) {
                          final e = car.carExtraDataModel[index];
                          final nextOdoInfo = e.calculateLeftODO(car.odo);
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 4,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text(
                                    e.groupName,
                                    style: titleTextTheme,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: nextOdoInfo.colorLevel.color,
                                    borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 2),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 40, right: 10),
                                    child: Text(
                                      '${nextOdoInfo.leftDistance.format()} км',
                                      style: theme.textTheme.bodyLarge?.copyWith(
                                        color: theme.colorScheme.inverseTextColor,
                                      ),
                                    ),
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
      ),
    );
  }
}
