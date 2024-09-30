import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/api_service.dart';
import '../../models/order.dart';

class CompanyOrdersPage extends StatefulWidget {
  @override
  _CompanyOrdersPageState createState() => _CompanyOrdersPageState();
}

class _CompanyOrdersPageState extends State<CompanyOrdersPage> {
  late Future<List<Order>> _futureOrders;

  @override
  void initState() {
    super.initState();
    _futureOrders = Provider.of<ApiService>(context, listen: false).getOrders();
  }

  void _refreshOrders() {
    setState(() {
      _futureOrders = Provider.of<ApiService>(context, listen: false).getOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Customer Orders'),
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
                child: Text('No orders available'),
              );
            } else {
              final orders = snapshot.data!;
              return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return Card(
                    margin: EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text('Order ID: ${order.id}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Vehicle ID: ${order.vehicleId}'),
                          Text('Color: ${order.color}'),
                          Text('Custom Configuration: ${order.customConfiguration}'),
                          Text('Status: ${order.status}'),
                        ],
                      ),
                      // Optionally, add actions like viewing more details
                    ),
                  );
                },
              );
            }
          },
        ));
  }
}
