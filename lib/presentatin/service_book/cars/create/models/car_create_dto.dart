class CarCreateDTO {
  final String uid;
  final String name;
  final int odo;
  final bool withAvatar;

  CarCreateDTO({
    required this.uid,
    required this.name,
    required this.odo,
    this.withAvatar = false,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'odo': odo,
        'with_avatar': withAvatar,
      };
}
