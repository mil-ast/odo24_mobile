import 'package:odo24_mobile/repository/services/service_result_dto.dart';

class ServiceModel {
  final int serviceID;
  final int? odo;
  final int? nextDistance;
  final String dt;
  final String? description;
  final int? price;

  ServiceModel({
    required this.serviceID,
    required this.odo,
    required this.nextDistance,
    required this.dt,
    required this.description,
    required this.price,
  });

  factory ServiceModel.fromDTO(ServiceDTO dto) {
    return ServiceModel(
      serviceID: dto.serviceID,
      odo: dto.odo,
      nextDistance: dto.nextDistance,
      dt: dto.dt,
      description: dto.description,
      price: dto.price,
    );
  }
}
