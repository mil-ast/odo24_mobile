import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/extensions/date_format_extension.dart';
import 'package:odo24_mobile/core/extensions/number_format_extension.dart';
import 'package:odo24_mobile/core/shared_widgets/app_card/app_card.dart';
import 'package:odo24_mobile/features/services/bloc/services_cubit.dart';
import 'package:odo24_mobile/features/services/data/models/service_model.dart';

class ServiceItemWidget extends StatelessWidget {
  final ServiceModel service;

  const ServiceItemWidget(this.service, {super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      title: AppCardTitle(
        title: service.dt.yMMMMd(),
        action: PopupMenuButton(
          onSelected: (value) {},
          icon: const Icon(Icons.more_vert, color: Colors.white),
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                onTap: () {
                  context.read<ServicesCubit>().showUpdateDialog(service);
                },
                child: const Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  children: [Icon(Icons.edit), Text('Изменить')],
                ),
              ),
              PopupMenuItem(
                onTap: () {
                  context.read<ServicesCubit>().confirmDeleteService(service);
                },
                child: const Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    Text('Удалить', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ];
          },
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              spacing: 6,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: service.odo != null
                          ? Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 6,
                              children: [
                                const Icon(Icons.speed_outlined),
                                Text(
                                  '${(service.odo ?? 0).format()} км',
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                              ],
                            )
                          : const SizedBox.shrink(),
                    ),
                    service.price != null
                        ? Align(
                            alignment: Alignment.centerRight,
                            child: Text(service.price!.currency(), style: const TextStyle(color: Colors.green)),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
                if (service.description != null && service.description!.isNotEmpty)
                  Text(
                    service.description!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black54),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceItemSeparatorWidget extends StatelessWidget {
  final int? leftDistance;
  const ServiceItemSeparatorWidget({required this.leftDistance, super.key});

  @override
  Widget build(BuildContext context) {
    if (leftDistance == null) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
      child: Row(
        children: [
          Text(
            'Пройдено ${leftDistance!.format()} км',
            textScaler: const TextScaler.linear(0.9),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
