import 'package:flutter/material.dart';
import 'package:frontend/src/login/login_view.dart';
import 'package:frontend/src/register/register_controller.dart';
import 'package:provider/provider.dart';

class RegisterView extends StatelessWidget {
  static const routeName = '/register';

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  RegisterView({Key? key}) : super(key: key);

  void _submit(BuildContext context) async {
    final registerController =
        Provider.of<RegisterController>(context, listen: false);
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter both username and password')),
      );
      return;
    }

    final user = await registerController.register(username, password);

    if (user != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginView()),
      );
    } else {
      final errorMessage = registerController.errorMessage ?? 'Login failed';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  void _navigateToLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RegisterController>(
      create: (_) => RegisterController(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Register'),
        ),
        body: Consumer<RegisterController>(
          builder: (context, registerController, child) {
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
                        onPressed: registerController.isLoading
                            ? null
                            : () => _submit(context),
                        child: registerController.isLoading
                            ? CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : Text('Register'),
                      ),
                    ),

                    SizedBox(height: 16.0),

                    // Navigate to Register
                    TextButton(
                      onPressed: () => _navigateToLogin(context),
                      child: Text("Have an account? Login"),
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
