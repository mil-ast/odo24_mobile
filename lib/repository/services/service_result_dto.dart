class ServiceDTO {
  final int serviceID;
  final int? odo;
  final int? nextDistance;
  final String dt;
  final String? description;
  final int? price;

  ServiceDTO({
    required this.serviceID,
    required this.odo,
    required this.nextDistance,
    required this.dt,
    required this.description,
    required this.price,
  });

  factory ServiceDTO.fromJson(Map<String, dynamic> json) {
    return ServiceDTO(
      serviceID: json['service_id'] as int,
      odo: json['odo'] as int?,
      nextDistance: json['next_distance'] as int?,
      dt: json['dt'] as String,
      description: json['description'] as String?,
      price: json['price'] as int?,
    );
  }
}
