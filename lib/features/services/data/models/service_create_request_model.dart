class ServiceCreateRequestModel {
  final int? odo;
  final int? nextDistance;
  final String dt;
  final String? description;
  final int? price;

  const ServiceCreateRequestModel({
    this.odo,
    this.nextDistance,
    required this.dt,
    this.description,
    this.price,
  });

  Map<String, dynamic> toJson() => {
        'odo': odo,
        'next_distance': nextDistance,
        'dt': dt,
        'description': description,
        'price': price,
      };
}
