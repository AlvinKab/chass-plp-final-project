import 'package:flutter/material.dart';

class CompanyDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Optionally, implement an AppBar or a Drawer for navigation
      appBar: AppBar(
        title: Text('Company Dashboard'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          _dashboardCard(context, 'Vehicles', Icons.directions_car, '/company/vehicles'),
          _dashboardCard(context, 'Engines', Icons.settings, '/company/engines'),
          _dashboardCard(context, 'Chassis', Icons.build, '/company/chassis'),
          _dashboardCard(context, 'Raw Materials', Icons.inventory, '/company/raw_materials'),
          _dashboardCard(context, 'Orders', Icons.shopping_cart, '/company/orders'),
          // Add more dashboard cards as needed
        ],
      ),
    );
  }

  Widget _dashboardCard(BuildContext context, String title, IconData icon, String route) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Card(
        margin: EdgeInsets.all(16.0),
        elevation: 4.0,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 50.0, color: Colors.blue),
              SizedBox(height: 10.0),
              Text(title, style: TextStyle(fontSize: 18.0)),
            ],
          ),
        ),
      ),
    );
  }
}
