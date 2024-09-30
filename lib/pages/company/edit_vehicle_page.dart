import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/api_service.dart';
import '../../models/vehicle.dart';

class EditVehiclePage extends StatefulWidget {
  final Vehicle vehicle;

  EditVehiclePage({required this.vehicle});

  @override
  _EditVehiclePageState createState() => _EditVehiclePageState();
}

class _EditVehiclePageState extends State<EditVehiclePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _modelController;
  late TextEditingController _yearController;
  late TextEditingController _engineController;
  late TextEditingController _chassisController;
  late TextEditingController _seatingController;
  late TextEditingController _safetyRatingController;
  late TextEditingController _topSpeedController;
  late TextEditingController _priceController;
  late TextEditingController _quantityController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _modelController = TextEditingController(text: widget.vehicle.model);
    _yearController = TextEditingController(text: widget.vehicle.year.toString());
    _engineController = TextEditingController(text: widget.vehicle.engine);
    _chassisController = TextEditingController(text: widget.vehicle.chassis);
    _seatingController =
        TextEditingController(text: widget.vehicle.seatingCapacity.toString());
    _safetyRatingController =
        TextEditingController(text: widget.vehicle.safetyRating.toString());
    _topSpeedController =
        TextEditingController(text: widget.vehicle.topSpeed.toString());
    _priceController =
        TextEditingController(text: widget.vehicle.price.toStringAsFixed(2));
    _quantityController =
        TextEditingController(text: widget.vehicle.quantity.toString());
  }

  @override
  void dispose() {
    _modelController.dispose();
    _yearController.dispose();
    _engineController.dispose();
    _chassisController.dispose();
    _seatingController.dispose();
    _safetyRatingController.dispose();
    _topSpeedController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final updatedData = {
        'model': _modelController.text,
        'year': int.parse(_yearController.text),
        'engine': _engineController.text,
        'chassis': _chassisController.text,
        'seating_capacity': int.parse(_seatingController.text),
        'safety_rating': double.parse(_safetyRatingController.text),
        'top_speed': double.parse(_topSpeedController.text),
        'price': double.parse(_priceController.text),
        'quantity': int.parse(_quantityController.text),
      };

      final apiService = Provider.of<ApiService>(context, listen: false);
      final response =
      await apiService.updateVehicle(widget.vehicle.id, updatedData);

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Vehicle updated successfully')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update vehicle')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Vehicle'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _modelController,
                  decoration: InputDecoration(labelText: 'Model'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the model';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _yearController,
                  decoration: InputDecoration(labelText: 'Year'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        int.tryParse(value) == null) {
                      return 'Please enter a valid year';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _engineController,
                  decoration: InputDecoration(labelText: 'Engine'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the engine details';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _chassisController,
                  decoration: InputDecoration(labelText: 'Chassis'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the chassis details';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _seatingController,
                  decoration:
                  InputDecoration(labelText: 'Seating Capacity'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        int.tryParse(value) == null) {
                      return 'Please enter a valid seating capacity';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _safetyRatingController,
                  decoration: InputDecoration(labelText: 'Safety Rating'),
                  keyboardType:
                  TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        double.tryParse(value) == null) {
                      return 'Please enter a valid safety rating';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _topSpeedController,
                  decoration: InputDecoration(labelText: 'Top Speed'),
                  keyboardType:
                  TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        double.tryParse(value) == null) {
                      return 'Please enter a valid top speed';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType:
                  TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        double.tryParse(value) == null) {
                      return 'Please enter a valid price';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _quantityController,
                  decoration: InputDecoration(labelText: 'Quantity'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        int.tryParse(value) == null) {
                      return 'Please enter a valid quantity';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submit,
                  child: Text('Update Vehicle'),
                ),
              ],
            ),
          ),
        ));
  }
}
