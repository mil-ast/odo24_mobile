import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/presentatin/car_screen/services/services_cubit.dart';
import 'package:odo24_mobile/domain/services/services/models/service_result_model.dart';

class ServiceItemWidget extends StatelessWidget {
  final ServiceModel service;

  const ServiceItemWidget(this.service, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(6)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset.zero, // changes position of shadow
          ),
        ],
        border: Border.all(
          color: const Color(0xfff3f3f3),
        ),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
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
                                const Icon(
                                  Icons.speed_outlined,
                                  color: Colors.black54,
                                ),
                                Text(
                                  '${service.formatOdo} км',
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                              ],
                            )
                          : const SizedBox.shrink(),
                    ),
                    Expanded(
                      flex: 7,
                      child: Text(
                        service.formatDt,
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: service.price != null
                          ? Align(
                              alignment: Alignment.centerRight,
                              child: Text('${service.formatPrice}', style: const TextStyle(color: Colors.green)),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
                if (service.description != null && service.description!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    service.description!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black54),
                  ),
                ],
                if (service.leftDistance != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    'Пройдено ${service.formatLeftOdo}км',
                    textScaler: const TextScaler.linear(0.9),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ],
            ),
          ),
          SizedBox(
            width: 40,
            child: PopupMenuButton(
              onSelected: (value) {},
              child: const Icon(Icons.menu),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    onTap: () {
                      context.read<ServicesCubit>().onClickEditService(service);
                    },
                    child: const Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 10,
                      children: [
                        Icon(Icons.edit),
                        Text('Изменить'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    onTap: () {
                      context.read<ServicesCubit>().onClickDeleteService(service);
                    },
                    child: const Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 10,
                      children: [
                        Icon(Icons.delete),
                        Text('Удалить'),
                      ],
                    ),
                  ),
                ];
              },
            ),
          ),
        ],
      ),
    );
  }
}
