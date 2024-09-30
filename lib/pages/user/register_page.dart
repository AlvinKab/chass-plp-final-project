import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/api_service.dart';
import '../user/dashboard.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserRegisterPage extends StatefulWidget {
  @override
  _UserRegisterPageState createState() => _UserRegisterPageState();
}

class _UserRegisterPageState extends State<UserRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _register() async {
    if (_formKey.currentState!.validate()) {
      final userData = {
        'name': _nameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'user_type': 'user',
      };

      final apiService = Provider.of<ApiService>(context, listen: false);
      final response = await apiService.register(userData);

      if (response.statusCode == 201) {
        Fluttertoast.showToast(msg: 'Registration successful');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserDashboard()),
        );
      } else {
        Fluttertoast.showToast(msg: 'Registration failed');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('User Registration'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password should be at least 6 characters long';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _register,
                    child: Text('Register'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/user/login');
                    },
                    child: Text('Already have an account? Login here'),
                  ),
                ],
              )),
        ));
  }
}
