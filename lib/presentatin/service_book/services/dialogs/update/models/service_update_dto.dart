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

  Map<String, dynamic> toJson() => {
        'dt': dt,
        'comment': comment,
        'odo': odo,
        'price': price,
      };
}
