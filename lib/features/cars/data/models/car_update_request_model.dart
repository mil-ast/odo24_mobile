import 'package:odo24_mobile/core/http/models/json_serializable_interface.dart';

class CarUpdateRequestModel implements JsonSerializable {
  final int carID;
  final String name;
  final int odo;
  final bool avatar;

  const CarUpdateRequestModel({required this.carID, required this.name, required this.odo, this.avatar = false});

  @override
  Map<String, Object?> toJson() => {'name': name, 'odo': odo, 'avatar': avatar};
}
