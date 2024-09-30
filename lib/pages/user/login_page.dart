import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/api_service.dart';

class UserLoginPage extends StatefulWidget {
  @override
  _UserLoginPageState createState() => _UserLoginPageState();
}

class _UserLoginPageState extends State<UserLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final response = await apiService.login(
        _emailController.text,
        _passwordController.text,
        'user',
      );

      if (response.statusCode == 200) {
        // Handle successful login, navigate to user dashboard
        Navigator.pushReplacementNamed(context, '/user/dashboard');
      } else {
        // Handle login failure
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed. Please check your credentials.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('User Login'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      // Add more robust email validation if needed
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
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _login,
                    child: Text('Login'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/user/register');
                    },
                    child: Text('Don\'t have an account? Register'),
                  ),
                ],
              )),
        ));
  }
}
