import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceUpdateDTO {
  final Timestamp dt;
  final String? comment;
  final int? odo;
  final int? price;

  ServiceUpdateDTO({
    required this.dt,
    this.comment,
    this.odo,
    this.price,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
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
