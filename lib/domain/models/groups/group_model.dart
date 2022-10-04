import 'package:odo24_mobile/core/model_core.dart';

class GroupModel implements ModelCore {
  final String carDocID;
  final int? odo;
  final int? dt;
  final String? comment;

  GroupModel({
    required this.carDocID,
    this.odo,
    this.dt,
    this.comment,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) => GroupModel(
        carDocID: json['car_doc_id'] ?? '',
        odo: json['odo'],
        dt: json['dt'],
        comment: json['comment'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'car_doc_id': carDocID,
        'odo': odo,
        'dt': dt,
        'comment': comment,
      };
}
