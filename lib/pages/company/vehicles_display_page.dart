import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/api_service.dart';
import '../../models/vehicle.dart';
import '../company/add_vehicle_page.dart';
import '../company/edit_vehicle_page.dart';

class VehiclesDisplayPage extends StatefulWidget {
  @override
  _VehiclesDisplayPageState createState() => _VehiclesDisplayPageState();
}

class _VehiclesDisplayPageState extends State<VehiclesDisplayPage> {
  late Future<List<Vehicle>> _futureVehicles;

  @override
  void initState() {
    super.initState();
    _futureVehicles = Provider.of<ApiService>(context, listen: false).getVehicles();
  }

  void _refreshVehicles() {
    setState(() {
      _futureVehicles = Provider.of<ApiService>(context, listen: false).getVehicles();
    });
  }

  void _deleteVehicle(int id) async {
    final apiService = Provider.of<ApiService>(context, listen: false);
    final response = await apiService.deleteVehicle(id);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vehicle deleted successfully')),
      );
      _refreshVehicles();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete vehicle')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Vehicles'),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddVehiclePage()),
                ).then((_) => _refreshVehicles());
              },
            ),
          ],
        ),
        body: FutureBuilder<List<Vehicle>>(
          future: _futureVehicles,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text('No vehicles available'),
              );
            } else {
              final vehicles = snapshot.data!;
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Model')),
                    DataColumn(label: Text('Year')),
                    DataColumn(label: Text('Engine')),
                    DataColumn(label: Text('Chassis')),
                    DataColumn(label: Text('Seating')),
                    DataColumn(label: Text('Safety Rating')),
                    DataColumn(label: Text('Top Speed')),
                    DataColumn(label: Text('Price')),
                    DataColumn(label: Text('Quantity')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: vehicles
                      .map(
                        (vehicle) => DataRow(cells: [
                      DataCell(Text(vehicle.model)),
                      DataCell(Text(vehicle.year.toString())),
                      DataCell(Text(vehicle.engine)),
                      DataCell(Text(vehicle.chassis)),
                      DataCell(Text(vehicle.seatingCapacity.toString())),
                      DataCell(Text(vehicle.safetyRating.toString())),
                      DataCell(Text(vehicle.topSpeed.toString())),
                      DataCell(Text('\$${vehicle.price.toStringAsFixed(2)}')),
                      DataCell(Text(vehicle.quantity.toString())),
                      DataCell(Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditVehiclePage(vehicle: vehicle),
                                ),
                              ).then((_) => _refreshVehicles());
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteVehicle(vehicle.id),
                          ),
                        ],
                      )),
                    ]),
                  )
                      .toList(),
                ),
              );
            }
          },
        ));
  }
}
