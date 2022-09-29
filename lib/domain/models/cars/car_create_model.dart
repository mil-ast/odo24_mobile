import 'package:odo24_mobile/core/model_core.dart';

class CarCreateModel implements ModelCore {
  String name;
  int odo;
  bool withAvatar;
  String uid;

  CarCreateModel(this.name, this.odo, this.uid, {this.withAvatar = false});

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        'odo': odo,
        'withAvatar': withAvatar,
        'uid': uid,
      };
}
