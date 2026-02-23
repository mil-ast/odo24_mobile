import 'package:odo24_mobile/core/http/models/json_serializable_interface.dart';

class GroupUpdateRequestModel implements JsonSerializable {
  final int groupID;
  final String name;

  GroupUpdateRequestModel({required this.groupID, required this.name});

  @override
  Map<String, Object?> toJson() => {'name': name};
}
