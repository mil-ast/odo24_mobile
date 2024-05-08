class CarCreateRequestModel {
  final String name;
  final int odo;
  final bool avatar;

  CarCreateRequestModel({
    required this.name,
    required this.odo,
    this.avatar = false,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'odo': odo,
        'avatar': avatar,
      };
}
