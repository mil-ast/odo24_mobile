class GroupCreateDTO {
  final String uid;
  final String name;

  GroupCreateDTO({
    required this.uid,
    required this.name,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
      };
}
