class GroupModel implements Comparable<GroupModel> {
  final int groupID;
  final String name;
  final int sort;
  final GroupExtraDataModel? groupExtraDataModel;

  const GroupModel({
    required this.groupID,
    required this.name,
    required this.sort,
    this.groupExtraDataModel,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {'group_id': num id, 'name': String name} => GroupModel(
        groupID: id.toInt(),
        name: name,
        sort: (json['sort'] as num? ?? 0).toInt(),
        groupExtraDataModel: switch (json['group_ext_data']) {
          Map<String, Object?> extra => GroupExtraDataModel.fromJson(extra),
          _ => null,
        },
      ),
      _ => throw FormatException('Неверный формат JSON для GroupModel: $json'),
    };
  }

  @override
  int compareTo(GroupModel other) {
    return sort.compareTo(other.sort);
  }
}

class GroupExtraDataModel {
  final int odo;
  final int leftOdo;

  const GroupExtraDataModel({required this.odo, required this.leftOdo});

  factory GroupExtraDataModel.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {'service_odo': int odo, 'left_odo': int leftOdo} => GroupExtraDataModel(
        odo: odo.toInt(),
        leftOdo: leftOdo.toInt(),
      ),
      _ => throw FormatException(
        'Неверный формат JSON для GroupExtraDataModel: $json',
      ),
    };
  }
}
