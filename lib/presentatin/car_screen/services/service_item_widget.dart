import 'package:flutter/material.dart';
import 'package:odo24_mobile/services/services/models/service_result_model.dart';

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
              SizedBox(
                child: Icon(Icons.more_vert_outlined),
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
        ],
      ),
    );
  }
}
