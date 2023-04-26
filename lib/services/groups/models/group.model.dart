import 'package:odo24_mobile/repository/groups/group_result_dto.dart';

class GroupModel {
  final int groupID;
  String name;
  int sort;

  GroupModel({
    required this.groupID,
    required this.name,
    required this.sort,
  });

  factory GroupModel.fromDTO(GroupDTO dto) {
    return GroupModel(
      groupID: dto.groupID,
      name: dto.name,
      sort: dto.sort,
    );
  }
}
