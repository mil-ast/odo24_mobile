import 'package:odo24_mobile/core/http/models/json_serializable_interface.dart';

class CarCreateRequestModel implements JsonSerializable {
  final String name;
  final int odo;
  final bool avatar;

  const CarCreateRequestModel({required this.name, required this.odo, this.avatar = false});

  @override
  Map<String, Object?> toJson() => {'name': name, 'odo': odo, 'avatar': avatar};
}
