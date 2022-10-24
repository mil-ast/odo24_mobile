class GroupCreateDTO {
  final String uid;
  final String name;
  final int sort;

  GroupCreateDTO({
    required this.uid,
    required this.name,
    this.sort = 0,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'sort': sort,
      };
}
