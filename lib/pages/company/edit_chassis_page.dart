import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/chassis.dart';
import '../../services/api_service.dart';

class EditChassisPage extends StatefulWidget {
  final Chassis chassis;

  EditChassisPage({required this.chassis});

  @override
  _EditChassisPageState createState() => _EditChassisPageState();
}

class _EditChassisPageState extends State<EditChassisPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _suspensionController;
  late TextEditingController _transmissionController;
  late TextEditingController _brakeTypeController;
  // Add controllers for more chassis attributes

  @override
  void initState() {
    super.initState();
    _suspensionController = TextEditingController(text: widget.chassis.suspension);
    _transmissionController = TextEditingController(text: widget.chassis.transmission);
    _brakeTypeController = TextEditingController(text: widget.chassis.brakeType);
    // Initialize other controllers
  }

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
      final updatedData = {
        'suspension': _suspensionController.text,
        'transmission': _transmissionController.text,
        'brake_type': _brakeTypeController.text,
        // Add other updated attributes
      };

      final apiService = Provider.of<ApiService>(context, listen: false);
      final response = await apiService.updateChassis(widget.chassis.id, updatedData);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Chassis updated successfully')));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update chassis')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Chassis'),
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
                    child: Text('Update Chassis'),
                  ),
                ],
              )),
        ));
  }
}
