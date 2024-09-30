class Engine {
  final int id;
  final int horsepower;
  final int torque;
  final int rpm;
  final String configuration;
  final String energyType;

  Engine({
    required this.id,
    required this.horsepower,
    required this.torque,
    required this.rpm,
    required this.configuration,
    required this.energyType,
  });

  factory Engine.fromJson(Map<String, dynamic> json) {
    return Engine(
      id: json['id'],
      horsepower: json['horsepower'],
      torque: json['torque'],
      rpm: json['rpm'],
      configuration: json['configuration'],
      energyType: json['energy_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'horsepower': horsepower,
      'torque': torque,
      'rpm': rpm,
      'configuration': configuration,
      'energy_type': energyType,
    };
  }
}
