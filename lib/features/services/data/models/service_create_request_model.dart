import 'package:odo24_mobile/core/http/models/json_serializable_interface.dart';

class ServiceCreateRequestModel implements JsonSerializable {
  final int? odo;
  final int? nextDistance;
  final String dt;
  final String? description;
  final int? price;

  const ServiceCreateRequestModel({this.odo, this.nextDistance, required this.dt, this.description, this.price});

  @override
  Map<String, Object?> toJson() => {
    'odo': odo,
    'next_distance': nextDistance,
    'dt': dt,
    'description': description,
    'price': price,
  };
}
