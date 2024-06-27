class ServiceModel implements Comparable<ServiceModel> {
  final int serviceID;
  final int? odo;
  final int? nextDistance;
  final DateTime dt;
  final String? description;
  final int? price;
  // осталось до следующей замены
  int? leftDistance;

  ServiceModel({
    required this.serviceID,
    required this.odo,
    required this.nextDistance,
    required this.dt,
    required this.description,
    required this.price,
  });

  ServiceModel copyWith({
    required DateTime dt,
    int? odo,
    int? price,
    int? nextDistance,
    String? description,
  }) =>
      ServiceModel(
        serviceID: serviceID,
        odo: odo,
        dt: dt,
        price: price,
        nextDistance: nextDistance,
        description: description,
      );

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      serviceID: json['service_id'] as int,
      odo: json['odo'] as int?,
      nextDistance: json['next_distance'] as int?,
      dt: DateTime.parse(json['dt'] as String),
      description: json['description'] as String?,
      price: json['price'] as int?,
    );
  }

  @override
  int compareTo(ServiceModel other) {
    if (odo != null && other.odo != null) {
      return other.odo! - odo!;
    }
    return 0;
  }
}
