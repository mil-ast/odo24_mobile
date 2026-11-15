import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/extensions/number_format_extension.dart';
import 'package:odo24_mobile/core/next_odo_information_level_enum.dart';
import 'package:odo24_mobile/core/shared_widgets/meta_chip.dart';
import 'package:odo24_mobile/core/theme/color_scheme.dart';
import 'package:odo24_mobile/features/cars/bloc/cars_cubit.dart';
import 'package:odo24_mobile/features/cars/data/models/car_model.dart';

class CarItemWidget extends StatelessWidget {
  static const _sectionColor = Color(0xFFF7F8FA);

  final CarModel car;

  const CarItemWidget({required this.car, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _mostUrgentStatusColor();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.read<CarsCubit>().onSelectCar(car),
          overlayColor: WidgetStatePropertyAll(
            Colors.black.withValues(alpha: 0.03),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 4, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    _CarAvatar(statusColor: statusColor),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 7,
                        children: [
                          Text(
                            car.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: [
                              MetaChip(
                                icon: Icons.edit_rounded,
                                label: '${car.odo.format()} км',
                                tooltip: 'Изменить пробег',
                                onTap: () => context
                                    .read<CarsCubit>()
                                    .openFormEditODO(car),
                              ),
                              MetaChip(
                                icon: Icons.menu_book_outlined,
                                label: 'Записей: ${car.servicesTotal}',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    _CarActionsMenu(car: car),
                  ],
                ),
                if (car.carExtraDataModel.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 14, right: 8),
                    child: _UpcomingServices(car: car),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color? _mostUrgentStatusColor() {
    if (car.carExtraDataModel.isEmpty) {
      return null;
    }

    final colors = car.carExtraDataModel.map(
      (e) => nextODOColor(carOdo: car.odo, odo: e.odo, leftOdo: e.leftOdo),
    );

    if (colors.contains(ODO24Colors.alarm)) {
      return ODO24Colors.alarm;
    }
    if (colors.contains(ODO24Colors.warning)) {
      return ODO24Colors.warning;
    }
    return ODO24Colors.success;
  }
}

class _CarAvatar extends StatelessWidget {
  final Color? statusColor;

  const _CarAvatar({this.statusColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.directions_car_filled_rounded,
              size: 26,
              color: Colors.black38,
            ),
          ),
          if (statusColor != null)
            Positioned(
              right: -1,
              bottom: -1,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _UpcomingServices extends StatelessWidget {
  final CarModel car;

  const _UpcomingServices({required this.car});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Row(
          spacing: 6,
          children: [
            const Icon(
              Icons.build_circle_outlined,
              size: 17,
              color: Colors.black45,
            ),
            Text(
              'Ближайшее обслуживание',
              style: theme.textTheme.titleSmall?.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: CarItemWidget._sectionColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 10,
            children: [
              ...car.carExtraDataModel.map(
                (e) => Row(
                  children: [
                    Expanded(
                      child: Text(
                        e.groupName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                    const SizedBox(width: 8),
                    MetaChip(
                      icon: Icons.speed_rounded,
                      label: '${e.leftOdo.format()} км',
                      color: nextODOColor(
                        carOdo: car.odo,
                        odo: e.odo,
                        leftOdo: e.leftOdo,
                      ),
                    ),
                    //RemainingOdoBadge(
                    //  leftOdo: e.leftOdo,
                    //  color: nextODOColor(
                    //    carOdo: car.odo,
                    //    odo: e.odo,
                    //    leftOdo: e.leftOdo,
                    //  ),
                    //),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

enum _CarAction { edit, delete }

class _CarActionsMenu extends StatelessWidget {
  final CarModel car;

  const _CarActionsMenu({required this.car});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_CarAction>(
      tooltip: 'Действия',
      icon: const Icon(Icons.more_vert_rounded, color: Colors.black45),
      onSelected: (action) {
        final cubit = context.read<CarsCubit>();
        switch (action) {
          case _CarAction.edit:
            cubit.openFormEditCar(car);
          case _CarAction.delete:
            cubit.onClickDeleteCar(car);
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: _CarAction.edit,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: const Row(
            spacing: 12,
            children: [Icon(Icons.edit_outlined), Text('Изменить')],
          ),
        ),
        PopupMenuItem(
          value: _CarAction.delete,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: const Row(
            spacing: 12,
            children: [
              Icon(Icons.delete_outline_rounded, color: Colors.red),
              Text('Удалить', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
    );
  }
}
