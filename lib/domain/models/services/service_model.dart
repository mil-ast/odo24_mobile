import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:odo24_mobile/core/model_core.dart';
import 'package:intl/intl.dart';

class ServiceModel implements ModelCore {
  final DocumentReference carRef;
  final int? odo;
  final Timestamp? dt;
  final String? comment;

  ServiceModel({
    required this.carRef,
    this.odo,
    this.dt,
    this.comment,
  });

  String formatDt() {
    if (dt == null) {
      return '';
    }
    final date = dt!.toDate();
    final DateFormat formatter = DateFormat('dd.MM.yyyy');
    return formatter.format(date);
  }

  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
        carRef: json['car_ref'],
        odo: json['odo'],
        dt: json['dt'],
        comment: json['comment'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'car_ref': carRef,
        'odo': odo,
        'dt': dt,
        'comment': comment,
      };
}

class ServiceModelExt extends ServiceModel {
  final String groupName;

  ServiceModelExt({
    required this.groupName,
    required super.carRef,
    super.odo,
    super.dt,
    super.comment,
  });
}
