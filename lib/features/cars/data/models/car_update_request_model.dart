class CarUpdateRequestModel {
  final int carID;
  final String name;
  final int odo;
  final bool avatar;

  const CarUpdateRequestModel({
    required this.carID,
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
