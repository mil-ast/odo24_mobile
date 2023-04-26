class GroupCreateRequestModel {
  final String name;

  GroupCreateRequestModel({
    required this.name,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
      };
}
