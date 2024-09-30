import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/vehicle.dart';
import '../models/engine.dart';
import '../models/chassis.dart';
import '../models/raw_material.dart';
import '../models/order.dart';

class ApiService {
  static const String baseUrl = 'https://your-api-base-url.com/api'; // Replace with your API base URL

  // Authentication
  Future<http.Response> login(String email, String password, String userType) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'user_type': userType, // 'company' or 'user'
      }),
    );
    return response;
  }

  Future<http.Response> register(Map<String, dynamic> userData) async {
    final url = Uri.parse('$baseUrl/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userData),
    );
    return response;
  }

  // Vehicles
  Future<List<Vehicle>> getVehicles() async {
    final url = Uri.parse('$baseUrl/vehicles');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Vehicle> vehicles = body.map((item) => Vehicle.fromJson(item)).toList();
      return vehicles;
    } else {
      throw Exception('Failed to load vehicles');
    }
  }

  Future<http.Response> addVehicle(Vehicle vehicle) async {
    final url = Uri.parse('$baseUrl/vehicles');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(vehicle.toJson()),
    );
    return response;
  }

  Future<http.Response> updateVehicle(int id, Map<String, dynamic> updatedData) async {
    final url = Uri.parse('$baseUrl/vehicles/$id');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updatedData),
    );
    return response;
  }

  Future<http.Response> deleteVehicle(int id) async {
    final url = Uri.parse('$baseUrl/vehicles/$id');
    final response = await http.delete(url);
    return response;
  }

  // Engines
  Future<List<Engine>> getEngines() async {
    final url = Uri.parse('$baseUrl/engines');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Engine> engines = body.map((item) => Engine.fromJson(item)).toList();
      return engines;
    } else {
      throw Exception('Failed to load engines');
    }
  }

  Future<http.Response> addEngine(Engine engine) async {
    final url = Uri.parse('$baseUrl/engines');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(engine.toJson()),
    );
    return response;
  }

  Future<http.Response> updateEngine(int id, Map<String, dynamic> updatedData) async {
    final url = Uri.parse('$baseUrl/engines/$id');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updatedData),
    );
    return response;
  }

  Future<http.Response> deleteEngine(int id) async {
    final url = Uri.parse('$baseUrl/engines/$id');
    final response = await http.delete(url);
    return response;
  }

  // Chassis
  Future<List<Chassis>> getChassis() async {
    final url = Uri.parse('$baseUrl/chassis');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Chassis> chassisList = body.map((item) => Chassis.fromJson(item)).toList();
      return chassisList;
    } else {
      throw Exception('Failed to load chassis');
    }
  }

  Future<http.Response> addChassis(Chassis chassis) async {
    final url = Uri.parse('$baseUrl/chassis');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(chassis.toJson()),
    );
    return response;
  }

  Future<http.Response> updateChassis(int id, Map<String, dynamic> updatedData) async {
    final url = Uri.parse('$baseUrl/chassis/$id');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updatedData),
    );
    return response;
  }

  Future<http.Response> deleteChassis(int id) async {
    final url = Uri.parse('$baseUrl/chassis/$id');
    final response = await http.delete(url);
    return response;
  }

  // Raw Materials
  Future<List<RawMaterial>> getRawMaterials() async {
    final url = Uri.parse('$baseUrl/raw_materials');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<RawMaterial> materials = body.map((item) => RawMaterial.fromJson(item)).toList();
      return materials;
    } else {
      throw Exception('Failed to load raw materials');
    }
  }

  Future<http.Response> addRawMaterial(RawMaterial material) async {
    final url = Uri.parse('$baseUrl/raw_materials');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(material.toJson()),
    );
    return response;
  }

  Future<http.Response> updateRawMaterial(int id, Map<String, dynamic> updatedData) async {
    final url = Uri.parse('$baseUrl/raw_materials/$id');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updatedData),
    );
    return response;
  }

  Future<http.Response> deleteRawMaterial(int id) async {
    final url = Uri.parse('$baseUrl/raw_materials/$id');
    final response = await http.delete(url);
    return response;
  }

  // Orders
  Future<List<Order>> getOrders({String? userType, int? userId}) async {
    String urlStr = '$baseUrl/orders';
    if (userType != null && userId != null) {
      urlStr += '?user_type=$userType&user_id=$userId';
    }
    final url = Uri.parse(urlStr);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Order> orders = body.map((item) => Order.fromJson(item)).toList();
      return orders;
    } else {
      throw Exception('Failed to load orders');
    }
  }

  Future<http.Response> placeOrder(Map<String, dynamic> orderData) async {
    final url = Uri.parse('$baseUrl/orders');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(orderData),
    );
    return response;
  }

  Future<http.Response> updateOrder(int id, Map<String, dynamic> updatedData) async {
    final url = Uri.parse('$baseUrl/orders/$id');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updatedData),
    );
    return response;
  }
}
