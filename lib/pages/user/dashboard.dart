import 'package:flutter/material.dart';

class UserDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Dashboard'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          _buildDashboardCard(context, Icons.add_shopping_cart, 'Place Order', '/user/place_order'),
          _buildDashboardCard(context, Icons.list, 'My Orders', '/user/orders'),
          // Add more dashboard cards as needed
        ],
      ),
    );
  }

  Widget _buildDashboardCard(BuildContext context, IconData icon, String title, String route) {
    return Card(
      margin: EdgeInsets.all(16.0),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, route);
        },
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 50.0, color: Theme.of(context).primaryColor),
              SizedBox(height: 10),
              Text(title, style: TextStyle(fontSize: 18.0)),
            ],
          ),
        ),
      ),
    );
  }
}
