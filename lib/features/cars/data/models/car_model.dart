class CarModel {
  final int carID;
  final String name;
  final int odo;
  final bool avatar;
  final int servicesTotal;

  CarModel({
    required this.carID,
    required this.name,
    required this.odo,
    required this.avatar,
    required this.servicesTotal,
  });

  CarModel copyWith({
    required int newOdo,
  }) =>
      CarModel(
        carID: carID,
        name: name,
        odo: newOdo,
        avatar: avatar,
        servicesTotal: servicesTotal,
      );

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      carID: json['car_id'] as int,
      name: json['name'] as String,
      odo: json['odo'] as int,
      avatar: json['avatar'] as bool,
      servicesTotal: json['services_total'] as int,
    );
  }
}
