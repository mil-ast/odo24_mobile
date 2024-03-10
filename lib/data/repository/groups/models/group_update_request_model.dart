class GroupUpdateRequestModel {
  final int groupID;
  final String name;

  GroupUpdateRequestModel({
    required this.groupID,
    required this.name,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
      };
}
