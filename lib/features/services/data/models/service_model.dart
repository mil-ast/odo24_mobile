import 'package:intl/intl.dart';

class ServiceModel {
  final int serviceID;
  final int? odo;
  final int? nextDistance;
  final DateTime dt;
  final String? description;
  final int? price;
  // осталось до следующей замены
  int? leftDistance;

  ServiceModel({
    required this.serviceID,
    required this.odo,
    required this.nextDistance,
    required this.dt,
    required this.description,
    required this.price,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      serviceID: json['service_id'] as int,
      odo: json['odo'] as int?,
      nextDistance: json['next_distance'] as int?,
      dt: DateTime.parse(json['dt'] as String),
      description: json['description'] as String?,
      price: json['price'] as int?,
    );
  }
}
