class Chassis {
  final int id;
  final String suspension;
  final String transmission;
  final String brakeType;
  // Add other chassis attributes

  Chassis({
    required this.id,
    required this.suspension,
    required this.transmission,
    required this.brakeType,
    // Initialize other attributes
  });

  factory Chassis.fromJson(Map<String, dynamic> json) {
    return Chassis(
      id: json['id'],
      suspension: json['suspension'],
      transmission: json['transmission'],
      brakeType: json['brake_type'],
      // Parse other attributes
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'suspension': suspension,
      'transmission': transmission,
      'brake_type': brakeType,
      // Add other attributes
    };
  }
}
