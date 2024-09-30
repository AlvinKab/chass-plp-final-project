import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/chassis.dart';
import '../../services/api_service.dart';
import '../company/add_chassis_page.dart';
import '../company/edit_chassis_page.dart';

class ChassisDisplayPage extends StatefulWidget {
  @override
  _ChassisDisplayPageState createState() => _ChassisDisplayPageState();
}

class _ChassisDisplayPageState extends State<ChassisDisplayPage> {
  late Future<List<Chassis>> _chassisFuture;

  @override
  void initState() {
    super.initState();
    _chassisFuture = Provider.of<ApiService>(context, listen: false).getChassis();
  }

  void _refreshChassis() {
    setState(() {
      _chassisFuture = Provider.of<ApiService>(context, listen: false).getChassis();
    });
  }

  void _deleteChassis(int id) async {
    final apiService = Provider.of<ApiService>(context, listen: false);
    final response = await apiService.deleteChassis(id);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Chassis deleted successfully')));
      _refreshChassis();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete chassis')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Chassis'),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: _refreshChassis,
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddChassisPage())).then((_) {
                  _refreshChassis();
                });
              },
            ),
          ],
        ),
        body: FutureBuilder<List<Chassis>>(
          future: _chassisFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No chassis available.'));
            } else {
              final chassisList = snapshot.data!;
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Suspension')),
                    DataColumn(label: Text('Transmission')),
                    DataColumn(label: Text('Brake Type')),
                    // Add more columns as needed
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: chassisList
                      .map(
                        (chassis) => DataRow(cells: [
                      DataCell(Text(chassis.id.toString())),
                      DataCell(Text(chassis.suspension)),
                      DataCell(Text(chassis.transmission)),
                      DataCell(Text(chassis.brakeType)),
                      // Add more cells as needed
                      DataCell(Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditChassisPage(chassis: chassis),
                                ),
                              ).then((_) {
                                _refreshChassis();
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _confirmDelete(chassis.id),
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

  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete Chassis'),
        content: Text('Are you sure you want to delete this chassis?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _deleteChassis(id);
            },
            child: Text('Yes'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('No'),
          ),
        ],
      ),
    );
  }
}
