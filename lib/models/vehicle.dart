class Vehicle {
  final int id;
  final String model;
  final int year;
  final String engine;
  final String chassis;
  final int seatingCapacity;
  final double safetyRating;
  final double topSpeed;
  final double price;
  final int quantity;

  Vehicle({
    required this.id,
    required this.model,
    required this.year,
    required this.engine,
    required this.chassis,
    required this.seatingCapacity,
    required this.safetyRating,
    required this.topSpeed,
    required this.price,
    required this.quantity,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'],
      model: json['model'],
      year: json['year'],
      engine: json['engine'],
      chassis: json['chassis'],
      seatingCapacity: json['seating_capacity'],
      safetyRating: json['safety_rating'].toDouble(),
      topSpeed: json['top_speed'].toDouble(),
      price: json['price'].toDouble(),
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'model': model,
      'year': year,
      'engine': engine,
      'chassis': chassis,
      'seating_capacity': seatingCapacity,
      'safety_rating': safetyRating,
      'top_speed': topSpeed,
      'price': price,
      'quantity': quantity,
    };
  }
}
