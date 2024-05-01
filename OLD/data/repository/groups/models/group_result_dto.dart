class GroupDTO {
  final int groupID;
  final String name;
  final int sort;

  GroupDTO({
    required this.groupID,
    required this.name,
    required this.sort,
  });

  factory GroupDTO.fromJson(Map<String, dynamic> json) {
    return GroupDTO(
      groupID: json['group_id'] as int,
      name: json['name'] as String,
      sort: json['sort'] as int,
    );
  }
}
