import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/api_service.dart';
import '../../models/raw_material.dart';
import '../../widgets/custom_widgets.dart';

class EditRawMaterialPage extends StatefulWidget {
  final RawMaterial material;

  EditRawMaterialPage({required this.material});

  @override
  _EditRawMaterialPageState createState() => _EditRawMaterialPageState();
}

class _EditRawMaterialPageState extends State<EditRawMaterialPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _materialController;
  late TextEditingController _quantityController;
  late TextEditingController _pricePerTonController;
  late TextEditingController _paidAmountController;

  @override
  void initState() {
    super.initState();
    _materialController = TextEditingController(text: widget.material.material);
    _quantityController = TextEditingController(text: widget.material.quantityInTonnes.toString());
    _pricePerTonController = TextEditingController(text: widget.material.pricePerTon.toString());
    _paidAmountController = TextEditingController(text: widget.material.paidAmount.toString());
  }

  @override
  void dispose() {
    _materialController.dispose();
    _quantityController.dispose();
    _pricePerTonController.dispose();
    _paidAmountController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      double quantity = double.parse(_quantityController.text);
      double pricePerTon = double.parse(_pricePerTonController.text);
      double paidAmount = double.parse(_paidAmountController.text);
      double totalPrice = quantity * pricePerTon;
      double amountOwed = totalPrice - paidAmount;

      Map<String, dynamic> updatedData = {
        'material': _materialController.text,
        'quantity_in_tonnes': quantity,
        'price_per_ton': pricePerTon,
        'total_price': totalPrice,
        'paid_amount': paidAmount,
        'amount_owed': amountOwed,
      };

      final apiService = Provider.of<ApiService>(context, listen: false);
      final response = await apiService.updateRawMaterial(widget.material.id, updatedData);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Raw Material updated successfully')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update raw material')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Raw Material'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  CustomTextField(
                    controller: _materialController,
                    label: 'Material',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the material name';
                      }
                      return null;
                    },
                  ),
                  CustomTextField(
                    controller: _quantityController,
                    label: 'Quantity (Tonnes)',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the quantity';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  CustomTextField(
                    controller: _pricePerTonController,
                    label: 'Price per Ton',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the price per ton';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  CustomTextField(
                    controller: _paidAmountController,
                    label: 'Paid Amount',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the paid amount';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submit,
                    child: Text('Update Raw Material'),
                  ),
                ],
              )),
        ));
  }
}
