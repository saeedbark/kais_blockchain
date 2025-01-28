// lib/src/login/login_view.dart

import 'package:flutter/material.dart';
import 'package:frontend/src/dashboard/dashboard_view.dart';
import 'package:frontend/src/login/login_controller.dart';
import 'package:frontend/src/register/register_view.dart';
import 'package:provider/provider.dart';

class LoginView extends StatelessWidget {
  static const routeName = '/login';

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginView({Key? key}) : super(key: key);

  void _submit(BuildContext context) async {
    final loginController =
        Provider.of<LoginController>(context, listen: false);
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter both username and password')),
      );
      return;
    }

    final user = await loginController.login(username, password);

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardView()),
      );
    } else {
      final errorMessage = loginController.errorMessage ?? 'Login failed';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  void _navigateToRegister(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginController>(
      create: (_) => LoginController(),
      child: Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Login')),
        ),
        body: Consumer<LoginController>(
          builder: (context, loginController, child) {
            return Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Username Field
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16.0),

                    // Password Field
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 24.0),

                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: loginController.isLoading
                            ? null
                            : () => _submit(context),
                        child: loginController.isLoading
                            ? CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : Text('Login'),
                      ),
                    ),

                    SizedBox(height: 16.0),

                    // Navigate to Register
                    TextButton(
                      onPressed: () => _navigateToRegister(context),
                      child: Text("Don't have an account? Register"),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
