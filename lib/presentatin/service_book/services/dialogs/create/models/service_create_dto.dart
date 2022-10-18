import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceCreateDTO {
  final DocumentReference carDoc;
  final Timestamp dt;
  final String? comment;
  final int? odo;
  final int? price;

  ServiceCreateDTO({
    required this.carDoc,
    required this.dt,
    this.comment,
    this.odo,
    this.price,
  });

  Map<String, dynamic> toJson() => {
        'car_ref': carDoc,
        'dt': dt,
        'comment': comment,
        'odo': odo,
        'price': price,
      };
}
