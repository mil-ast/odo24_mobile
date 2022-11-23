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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'car_ref': carDoc,
      'dt': dt,
    };
    if (comment != null) {
      json['comment'] = comment;
    }
    if (odo != null) {
      json['odo'] = odo;
    }
    if (price != null) {
      json['price'] = price;
    }
    return json;
  }
}
