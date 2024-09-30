import 'package:flutter/material.dart';
import 'pages/company/login_page.dart';
import 'pages/company/registration_page.dart';
import 'pages/company/vehicles_display_page.dart';
import 'pages/company/add_vehicle_page.dart';
import 'pages/company/edit_vehicle_page.dart';
import 'pages/company/engines_display_page.dart';
import 'pages/company/add_engine_page.dart';
import 'pages/company/edit_engine_page.dart';
import 'pages/company/chassis_display_page.dart';
import 'pages/company/add_chassis_page.dart';
import 'pages/company/edit_chassis_page.dart';
import 'pages/company/raw_materials_display_page.dart';
import 'pages/company/add_raw_material_page.dart';
import 'pages/company/edit_raw_material_page.dart';
import 'pages/company/orders_page.dart';
import 'pages/company/dashboard.dart';
import 'pages/user/login_page.dart';
import 'pages/user/register_page.dart';
import 'pages/user/place_order_page.dart';
import 'pages/user/user_orders_page.dart';
import 'pages/user/dashboard.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => CompanyLoginPage(),
  '/company/login': (context) => CompanyLoginPage(),
  '/company/register': (context) => CompanyRegistrationPage(),
  '/company/dashboard': (context) => CompanyDashboard(),
  '/company/vehicles': (context) => VehiclesDisplayPage(),
  '/company/vehicles/add': (context) => AddVehiclePage(),
  '/company/vehicles/edit': (context) => EditVehiclePage(),
  '/company/engines': (context) => EnginesDisplayPage(),
  '/company/engines/add': (context) => AddEnginePage(),
  '/company/engines/edit': (context) => EditEnginePage(),
  '/company/chassis': (context) => ChassisDisplayPage(),
  '/company/chassis/add': (context) => AddChassisPage(),
  '/company/chassis/edit': (context) => EditChassisPage(),
  '/company/raw_materials': (context) => RawMaterialsDisplayPage(),
  '/company/raw_materials/add': (context) => AddRawMaterialPage(),
  '/company/raw_materials/edit': (context) => EditRawMaterialPage(),
  '/company/orders': (context) => CompanyOrdersPage(),
  '/user/login': (context) => UserLoginPage(),
  '/user/register': (context) => UserRegisterPage(),
  '/user/dashboard': (context) => UserDashboard(),
  '/user/place_order': (context) => PlaceOrderPage(),
  '/user/orders': (context) => UserOrdersPage(),
};
