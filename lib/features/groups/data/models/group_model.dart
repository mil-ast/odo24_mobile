class GroupModel implements Comparable<GroupModel> {
  final int groupID;
  final String name;
  final int sort;

  const GroupModel({required this.groupID, required this.name, required this.sort});

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(groupID: json['group_id'] as int, name: json['name'] as String, sort: json['sort'] as int);
  }

  @override
  int compareTo(GroupModel other) {
    return sort.compareTo(other.sort);
  }
}
