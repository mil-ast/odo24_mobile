class CarUpdateDTO {
  final String name;
  final int odo;
  final bool withAvatar;

  CarUpdateDTO({
    required this.name,
    required this.odo,
    this.withAvatar = false,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'odo': odo,
        'with_avatar': withAvatar,
      };
}
