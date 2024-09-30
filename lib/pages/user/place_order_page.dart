import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/api_service.dart';
import '../../models/vehicle.dart';
import '../../widgets/custom_widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PlaceOrderPage extends StatefulWidget {
  @override
  _PlaceOrderPageState createState() => _PlaceOrderPageState();
}

class _PlaceOrderPageState extends State<PlaceOrderPage> {
  final _formKey = GlobalKey<FormState>();
  final _colorController = TextEditingController();
  final _customConfigController = TextEditingController();
  Vehicle? _selectedVehicle;
  late Future<List<Vehicle>> _futureVehicles;

  @override
  void initState() {
    super.initState();
    _futureVehicles = Provider.of<ApiService>(context, listen: false).getVehicles();
  }

  @override
  void dispose() {
    _colorController.dispose();
    _customConfigController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate() && _selectedVehicle != null) {
      final orderData = {
        'vehicle_id': _selectedVehicle!.id,
        'color': _colorController.text,
        'custom_configuration': _customConfigController.text,
      };

      final apiService = Provider.of<ApiService>(context, listen: false);
      final response = await apiService.placeOrder(orderData);

      if (response.statusCode == 201) {
        Fluttertoast.showToast(msg: 'Order placed successfully');
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(msg: 'Failed to place order');
      }
    } else {
      Fluttertoast.showToast(msg: 'Please select a vehicle');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Place Order'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
              key: _formKey,
              child: FutureBuilder<List<Vehicle>>(
                future: _futureVehicles,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No vehicles available'));
                  } else {
                    final vehicles = snapshot.data!;
                    return ListView(
                      children: [
                        DropdownButtonFormField<Vehicle>(
                          decoration: InputDecoration(labelText: 'Select Vehicle'),
                          items: vehicles
                              .map((vehicle) => DropdownMenuItem<Vehicle>(
                            value: vehicle,
                            child: Text('${vehicle.model} (${vehicle.year})'),
                          ))
                              .toList(),
                          onChanged: (Vehicle? newValue) {
                            setState(() {
                              _selectedVehicle = newValue;
                            });
                          },
                          validator: (value) => value == null ? 'Please select a vehicle' : null,
                        ),
                        CustomTextField(
                          controller: _colorController,
                          label: 'Color',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the color';
                            }
                            return null;
                          },
                        ),
                        CustomTextField(
                          controller: _customConfigController,
                          label: 'Custom Configuration',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter custom configuration';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _submit,
                          child: Text('Place Order'),
                        ),
                      ],
                    );
                  }
                },
              )),
        ));
  }
}
