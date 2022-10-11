import 'package:odo24_mobile/core/model_core.dart';

class ServiceModel implements ModelCore {
  final String carRef;
  final int? odo;
  final int? dt;
  final String? comment;

  ServiceModel({
    required this.carRef,
    this.odo,
    this.dt,
    this.comment,
  });

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
