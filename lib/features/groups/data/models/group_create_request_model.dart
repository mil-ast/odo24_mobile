import 'package:odo24_mobile/core/http/models/json_serializable_interface.dart';

class GroupCreateRequestModel implements JsonSerializable {
  final String name;

  GroupCreateRequestModel({required this.name});

  @override
  Map<String, Object?> toJson() => {'name': name};
}
