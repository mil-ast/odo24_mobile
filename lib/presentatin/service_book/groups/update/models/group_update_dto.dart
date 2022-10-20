class GroupUpdateDTO {
  final String name;

  GroupUpdateDTO({
    required this.name,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
      };
}
