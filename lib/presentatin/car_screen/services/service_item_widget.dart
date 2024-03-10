import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
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
        border: Border.all(
          color: const Color(0xfff3f3f3),
        ),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: service.odo != null ? Text('${service.formatOdo} км') : const SizedBox.shrink(),
              ),
              Expanded(
                flex: 5,
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
              const SizedBox(width: 20),
              PopupMenuButton(
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
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  service.description ?? '',
                  style: const TextStyle(color: Colors.black54),
                ),
              ),
            ],
          ),
          if (service.leftDistance != null)
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
              ),
              child: Text(
                'Пройдено ${service.formatLeftOdo}км',
                textScaler: const TextScaler.linear(0.9),
              ),
            ),
        ],
      ),
    );
  }
}
