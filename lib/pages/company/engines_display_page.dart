import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/api_service.dart';
import '../../models/engine.dart';
import 'add_engine_page.dart';
import 'edit_engine_page.dart';

class EnginesDisplayPage extends StatefulWidget {
  @override
  _EnginesDisplayPageState createState() => _EnginesDisplayPageState();
}

class _EnginesDisplayPageState extends State<EnginesDisplayPage> {
  late Future<List<Engine>> _futureEngines;

  @override
  void initState() {
    super.initState();
    _futureEngines = Provider.of<ApiService>(context, listen: false).getEngines();
  }

  void _refreshEngines() {
    setState(() {
      _futureEngines = Provider.of<ApiService>(context, listen: false).getEngines();
    });
  }

  void _deleteEngine(int id) async {
    final apiService = Provider.of<ApiService>(context, listen: false);
    final response = await apiService.deleteEngine(id);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Engine deleted successfully')),
      );
      _refreshEngines();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete engine')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Engines'),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddEnginePage()),
                ).then((_) => _refreshEngines());
              },
            ),
          ],
        ),
        body: FutureBuilder<List<Engine>>(
          future: _futureEngines,
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
                child: Text('No engines available'),
              );
            } else {
              final engines = snapshot.data!;
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Horsepower')),
                    DataColumn(label: Text('Torque')),
                    DataColumn(label: Text('RPM')),
                    DataColumn(label: Text('Configuration')),
                    DataColumn(label: Text('Energy Type')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: engines
                      .map(
                        (engine) => DataRow(cells: [
                      DataCell(Text(engine.horsepower.toString())),
                      DataCell(Text(engine.torque.toString())),
                      DataCell(Text(engine.rpm.toString())),
                      DataCell(Text(engine.configuration)),
                      DataCell(Text(engine.energyType)),
                      DataCell(Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditEnginePage(engine: engine),
                                ),
                              ).then((_) => _refreshEngines());
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteEngine(engine.id),
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
