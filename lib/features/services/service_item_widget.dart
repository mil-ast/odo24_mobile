import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/extensions/date_format_extension.dart';
import 'package:odo24_mobile/core/extensions/number_format_extension.dart';
import 'package:odo24_mobile/core/shared_widgets/meta_chip.dart';
import 'package:odo24_mobile/features/services/bloc/services_cubit.dart';
import 'package:odo24_mobile/features/services/data/models/service_model.dart';

class ServiceItemWidget extends StatelessWidget {
  static const _priceColor = Color(0xFF2E7D32);

  final ServiceModel service;

  const ServiceItemWidget(this.service, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasMeta = service.odo != null || service.price != null;
    final description = service.description;

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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 4, 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _ServiceAvatar(),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 7,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        service.dt.yMMMMd(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (hasMeta)
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          if (service.odo != null)
                            MetaChip(
                              icon: Icons.speed_rounded,
                              label: '${service.odo!.format()} км',
                            ),
                          if (service.price != null)
                            MetaChip(
                              icon: Icons.payments_outlined,
                              label: service.price!.currency(),
                              color: _priceColor,
                            ),
                        ],
                      ),
                    if (description != null && description.isNotEmpty)
                      Text(
                        description,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.black54,
                          height: 1.35,
                        ),
                      ),
                  ],
                ),
              ),
              _ServiceActionsMenu(service: service),
            ],
          ),
        ),
      ),
    );
  }
}

class _ServiceAvatar extends StatelessWidget {
  const _ServiceAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Icon(Icons.build_rounded, size: 25, color: Colors.black38),
    );
  }
}

class ServiceItemSeparatorWidget extends StatelessWidget {
  /// Пройденное расстояние с предыдущего обслуживания.
  final int? serviceDistance;

  const ServiceItemSeparatorWidget({required this.serviceDistance, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: serviceDistance == null
          ? const SizedBox(height: 6)
          : Row(
              spacing: 10,
              children: [
                const Expanded(
                  child: Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0xFFE1E3E6),
                  ),
                ),
                Row(
                  spacing: 4,
                  children: [
                    const Icon(
                      Icons.south_rounded,
                      size: 14,
                      color: Colors.black38,
                    ),
                    Text(
                      'Пройдено ${serviceDistance!.format()} км',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: Colors.black45,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const Expanded(
                  child: Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0xFFE1E3E6),
                  ),
                ),
              ],
            ),
    );
  }
}

enum _ServiceAction { edit, delete }

class _ServiceActionsMenu extends StatelessWidget {
  final ServiceModel service;

  const _ServiceActionsMenu({required this.service});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_ServiceAction>(
      tooltip: 'Действия',
      icon: const Icon(Icons.more_vert_rounded, color: Colors.black45),
      onSelected: (action) {
        final cubit = context.read<ServicesCubit>();
        switch (action) {
          case _ServiceAction.edit:
            cubit.showUpdateDialog(service);
          case _ServiceAction.delete:
            cubit.confirmDeleteService(service);
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: _ServiceAction.edit,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: const Row(
            spacing: 12,
            children: [Icon(Icons.edit_outlined), Text('Изменить')],
          ),
        ),
        PopupMenuItem(
          value: _ServiceAction.delete,
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
