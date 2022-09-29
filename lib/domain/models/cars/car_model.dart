import 'package:odo24_mobile/core/model_core.dart';

class CarModel implements ModelCore {
  String name;
  int odo;
  bool withAvatar;

  CarModel(this.name, this.odo, {this.withAvatar = false});

  factory CarModel.fromJson(Map<String, dynamic> json) => CarModel(
        json['name'] ?? '',
        json['odo'] ?? 0,
        withAvatar: json['withAvatar'] ?? false,
      );

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        'odo': odo,
        'withAvatar': withAvatar,
      };
}
