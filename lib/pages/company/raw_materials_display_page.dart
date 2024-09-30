import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/raw_material.dart';
import '../../services/api_service.dart';
import '../company/add_raw_material_page.dart';
import '../company/edit_raw_material_page.dart';

class RawMaterialsDisplayPage extends StatefulWidget {
  @override
  _RawMaterialsDisplayPageState createState() => _RawMaterialsDisplayPageState();
}

class _RawMaterialsDisplayPageState extends State<RawMaterialsDisplayPage> {
  late Future<List<RawMaterial>> _rawMaterialsFuture;

  @override
  void initState() {
    super.initState();
    _rawMaterialsFuture = Provider.of<ApiService>(context, listen: false).getRawMaterials();
  }

  void _refreshRawMaterials() {
    setState(() {
      _rawMaterialsFuture = Provider.of<ApiService>(context, listen: false).getRawMaterials();
    });
  }

  void _deleteRawMaterial(int id) async {
    final apiService = Provider.of<ApiService>(context, listen: false);
    final response = await apiService.deleteRawMaterial(id);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Raw material deleted successfully')));
      _refreshRawMaterials();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete raw material')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Raw Materials'),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: _refreshRawMaterials,
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddRawMaterialPage())).then((_) {
                  _refreshRawMaterials();
                });
              },
            ),
          ],
        ),
        body: FutureBuilder<List<RawMaterial>>(
          future: _rawMaterialsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No raw materials available.'));
            } else {
              final materials = snapshot.data!;
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Material')),
                    DataColumn(label: Text('Quantity (tonnes)')),
                    DataColumn(label: Text('Price per Ton')),
                    DataColumn(label: Text('Total Price')),
                    DataColumn(label: Text('Paid Amount')),
                    DataColumn(label: Text('Amount Owed')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: materials
                      .map(
                        (material) => DataRow(cells: [
                      DataCell(Text(material.id.toString())),
                      DataCell(Text(material.material)),
                      DataCell(Text(material.quantityInTonnes.toString())),
                      DataCell(Text(material.pricePerTon.toStringAsFixed(2))),
                      DataCell(Text(material.totalPrice.toStringAsFixed(2))),
                      DataCell(Text(material.paidAmount.toStringAsFixed(2))),
                      DataCell(Text(material.amountOwed.toStringAsFixed(2))),
                      DataCell(Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditRawMaterialPage(material: material),
                                ),
                              ).then((_) {
                                _refreshRawMaterials();
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _confirmDelete(material.id),
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
        title: Text('Delete Raw Material'),
        content: Text('Are you sure you want to delete this raw material?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _deleteRawMaterial(id);
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
