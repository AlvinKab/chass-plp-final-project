class Order {
  final int id;
  final int vehicleId;
  final String color;
  final String customConfiguration;
  final String status;

  Order({
    required this.id,
    required this.vehicleId,
    required this.color,
    required this.customConfiguration,
    required this.status,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      vehicleId: json['vehicle_id'],
      color: json['color'],
      customConfiguration: json['custom_configuration'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vehicle_id': vehicleId,
      'color': color,
      'custom_configuration': customConfiguration,
      'status': status,
    };
  }
}
