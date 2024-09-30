import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/engine.dart';
import '../../services/api_service.dart';

class EditEnginePage extends StatefulWidget {
  final Engine engine;

  EditEnginePage({required this.engine});

  @override
  _EditEnginePageState createState() => _EditEnginePageState();
}

class _EditEnginePageState extends State<EditEnginePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _horsepowerController;
  late TextEditingController _torqueController;
  late TextEditingController _rpmController;
  late TextEditingController _configurationController;
  late String _energyType;

  @override
  void initState() {
    super.initState();
    _horsepowerController = TextEditingController(text: widget.engine.horsepower.toString());
    _torqueController = TextEditingController(text: widget.engine.torque.toString());
    _rpmController = TextEditingController(text: widget.engine.rpm.toString());
    _configurationController = TextEditingController(text: widget.engine.configuration);
    _energyType = widget.engine.energyType;
  }

  @override
  void dispose() {
    _horsepowerController.dispose();
    _torqueController.dispose();
    _rpmController.dispose();
    _configurationController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final updatedData = {
        'horsepower': int.parse(_horsepowerController.text),
        'torque': int.parse(_torqueController.text),
        'rpm': int.parse(_rpmController.text),
        'configuration': _configurationController.text,
        'energy_type': _energyType,
      };

      final apiService = Provider.of<ApiService>(context, listen: false);
      final response = await apiService.updateEngine(widget.engine.id, updatedData);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Engine updated successfully')));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update engine')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Engine'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _horsepowerController,
                    decoration: InputDecoration(labelText: 'Horsepower'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter horsepower';
                      if (int.tryParse(value) == null) return 'Enter a valid number';
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _torqueController,
                    decoration: InputDecoration(labelText: 'Torque'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter torque';
                      if (int.tryParse(value) == null) return 'Enter a valid number';
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _rpmController,
                    decoration: InputDecoration(labelText: 'RPM'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter RPM';
                      if (int.tryParse(value) == null) return 'Enter a valid number';
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _configurationController,
                    decoration: InputDecoration(labelText: 'Configuration'),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter configuration';
                      return null;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    value: _energyType,
                    decoration: InputDecoration(labelText: 'Energy Type'),
                    items: ['Diesel', 'Petrol', 'Hybrid', 'Electric', 'Hydrogen']
                        .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _energyType = value!;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submit,
                    child: Text('Update Engine'),
                  ),
                ],
              )),
        ));
  }
}
