import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/api_service.dart';
import '../company/login_page.dart';

class CompanyRegistrationPage extends StatefulWidget {
  @override
  _CompanyRegistrationPageState createState() => _CompanyRegistrationPageState();
}

class _CompanyRegistrationPageState extends State<CompanyRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  void _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final apiService = Provider.of<ApiService>(context, listen: false);
      final response = await apiService.register({
        'name': _nameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'user_type': 'company',
      });

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration successful! Please log in.')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CompanyLoginPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Company Registration'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Company Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your company name';
                    }
                    return null;
                  },
                ),
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
                    if (value == null || value.length < 6) {
                      return 'Password must be at least 6 characters';
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
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CompanyLoginPage()),
                    );
                  },
                  child: Text('Already have an account? Login'),
                ),
              ],
            ),
          ),
        ));
  }
}
