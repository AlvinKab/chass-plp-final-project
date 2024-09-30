import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/chassis.dart';
import '../../services/api_service.dart';

class AddChassisPage extends StatefulWidget {
  @override
  _AddChassisPageState createState() => _AddChassisPageState();
}

class _AddChassisPageState extends State<AddChassisPage> {
  final _formKey = GlobalKey<FormState>();
  final _suspensionController = TextEditingController();
  final _transmissionController = TextEditingController();
  final _brakeTypeController = TextEditingController();
  // Add controllers for more chassis attributes

  @override
  void dispose() {
    _suspensionController.dispose();
    _transmissionController.dispose();
    _brakeTypeController.dispose();
    // Dispose other controllers
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final chassis = Chassis(
        id: 0, // ID will be set by the backend
        suspension: _suspensionController.text,
        transmission: _transmissionController.text,
        brakeType: _brakeTypeController.text,
        // Initialize other attributes
      );

      final apiService = Provider.of<ApiService>(context, listen: false);
      final response = await apiService.addChassis(chassis);

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Chassis added successfully')));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add chassis')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Chassis'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _suspensionController,
                    decoration: InputDecoration(labelText: 'Suspension'),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter suspension type';
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _transmissionController,
                    decoration: InputDecoration(labelText: 'Transmission'),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter transmission type';
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _brakeTypeController,
                    decoration: InputDecoration(labelText: 'Brake Type'),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter brake type';
                      return null;
                    },
                  ),
                  // Add more form fields for additional attributes
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submit,
                    child: Text('Add Chassis'),
                  ),
                ],
              )),
        ));
  }
}
