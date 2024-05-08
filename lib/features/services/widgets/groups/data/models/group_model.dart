class GroupModel {
  final int groupID;
  final String name;
  final int sort;

  GroupModel({
    required this.groupID,
    required this.name,
    required this.sort,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      groupID: json['group_id'] as int,
      name: json['name'] as String,
      sort: json['sort'] as int,
    );
  }
}
