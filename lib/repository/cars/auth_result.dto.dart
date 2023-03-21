import 'dart:core';

class CarDTO {
  final int carID;
  final String name;
  final int odo;
  final bool avatar;

  CarDTO({
    required this.carID,
    required this.name,
    required this.odo,
    required this.avatar,
  });

  factory CarDTO.fromJson(Map<String, dynamic> json) {
    return CarDTO(
      carID: json['car_id'] as int,
      name: json['name'] as String,
      odo: json['odo'] as int,
      avatar: json['avatar'] as bool,
    );
  }
}
