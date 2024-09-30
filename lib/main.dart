import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/api_service.dart';
import 'routes.dart';

void main() {
  runApp(ChassApp());
}

class ChassApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiService>(
          create: (_) => ApiService(),
        ),
        // Add other providers here if needed
      ],
      child: MaterialApp(
        title: 'Chass',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: appRoutes,
      ),
    );
  }
}
