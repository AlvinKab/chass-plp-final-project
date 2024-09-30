import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/api_service.dart';
import '../../models/order.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserOrdersPage extends StatefulWidget {
  @override
  _UserOrdersPageState createState() => _UserOrdersPageState();
}

class _UserOrdersPageState extends State<UserOrdersPage> {
  late Future<List<Order>> _futureOrders;

  @override
  void initState() {
    super.initState();
    // Assuming you have a method to get the current user's ID
    int userId = 1; // Replace with actual user ID
    _futureOrders = Provider.of<ApiService>(context, listen: false).getOrders(userType: 'user', userId: userId);
  }

  void _refreshOrders() {
    setState(() {
      int userId = 1; // Replace with actual user ID
      _futureOrders = Provider.of<ApiService>(context, listen: false).getOrders(userType: 'user', userId: userId);
    });
  }

  void _confirmArrival(int orderId, bool hasArrived) async {
    final apiService = Provider.of<ApiService>(context, listen: false);
    final updatedData = {
      'status': hasArrived ? 'Arrived' : 'Pending',
    };
    final response = await apiService.updateOrder(orderId, updatedData);

    if (response.statusCode == 200) {
      Fluttertoast.showToast(msg: 'Order status updated');
      _refreshOrders();
    } else {
      Fluttertoast.showToast(msg: 'Failed to update order status');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My Orders'),
        ),
        body: FutureBuilder<List<Order>>(
          future: _futureOrders,
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
                child: Text('No orders found'),
              );
            } else {
              final orders = snapshot.data!;
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Order ID')),
                    DataColumn(label: Text('Vehicle ID')),
                    DataColumn(label: Text('Color')),
                    DataColumn(label: Text('Custom Configuration')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Confirm Arrival')),
                  ],
                  rows: orders
                      .map(
                        (order) => DataRow(cells: [
                      DataCell(Text(order.id.toString())),
                      DataCell(Text(order.vehicleId.toString())),
                      DataCell(Text(order.color)),
                      DataCell(Text(order.customConfiguration)),
                      DataCell(Text(order.status)),
                      DataCell(
                        Checkbox(
                          value: order.status == 'Arrived',
                          onChanged: (bool? value) {
                            _confirmArrival(order.id, value ?? false);
                          },
                        ),
                      ),
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
