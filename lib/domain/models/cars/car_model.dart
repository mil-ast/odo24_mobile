class CarModel {
  final String uid;
  final String name;
  final int odo;
  final bool withAvatar;

  const CarModel({
    required this.uid,
    required this.name,
    required this.odo,
    required this.withAvatar,
  });

  factory CarModel.fromJson(json) => CarModel(
        uid: json['uid'],
        name: json['name'],
        odo: json['odo'],
        withAvatar: json['with_avatar'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'odo': odo,
        'with_avatar': withAvatar,
      };
}
