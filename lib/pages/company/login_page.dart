import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/api_service.dart';
import '../company/dashboard.dart';
import '../company/registration_page.dart';

class CompanyLoginPage extends StatefulWidget {
  @override
  _CompanyLoginPageState createState() => _CompanyLoginPageState();
}

class _CompanyLoginPageState extends State<CompanyLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final apiService = Provider.of<ApiService>(context, listen: false);
      final response = await apiService.login(
        _emailController.text,
        _passwordController.text,
        'company',
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        // Navigate to Company Dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CompanyDashboard()),
        );
      } else {
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
          title: Text('Company Login'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !value.contains('@')) {
                      return 'Please enter a valid email';
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CompanyRegistrationPage()),
                    );
                  },
                  child: Text('Register'),
                ),
              ],
            ),
          ),
        ));
  }
}
