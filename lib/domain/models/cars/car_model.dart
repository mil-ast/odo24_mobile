class CarModel {
  String name;
  int odo;
  bool withAvatar;

  CarModel(this.name, this.odo, {this.withAvatar = false});

  factory CarModel.fromJson(Map<String, dynamic> json) => CarModel(
        json['name'] ?? '',
        json['odo'] ?? 0,
        withAvatar: json['withAvatar'] ?? false,
      );
}
