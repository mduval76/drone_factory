import 'package:drone_factory/providers/auth_provider.dart' as auth_provider;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;
  bool _isSignUp = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<auth_provider.AuthProvider>(context);

    return Material(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You need to be logged in to access this feature.',
              style: TextStyle(color: Colors.white),
            ),
            TextField(
              controller: _emailController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.white),
              ),
            ),
            TextField(
              controller: _passwordController,
              style: const TextStyle(color: Colors.white),
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    try {
                      // REGISTRATION
                      if (_isSignUp) {
                        await authProvider.signUp(
                          _emailController.text.trim(),
                          _passwordController.text.trim(),
                        );
                        if (context.mounted) {
                          Navigator.pop(context, true);
                        }
                      }
                      // LOGIN
                      else {
                        await authProvider.signIn(
                          _emailController.text.trim(),
                          _passwordController.text.trim(),
                        );
                        if (context.mounted) {
                          Navigator.pop(context, true);
                        }
                      }
                    } 
                    catch (e) {
                      setState(() {
                        if (_isSignUp) {
                          _errorMessage = 'An error occurred during the registration process. Please try again.';
                        } 
                        else {
                          _errorMessage = 'An error occurred during the login process. Please try again.';
                        }
                      });
                    }
                  },
                  child: Text(_isSignUp ? 'Sign Up' : 'Login'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (context.mounted) {
                      Navigator.pop(context, false);
                    }
                  },
                  child: const Text('Cancel'),
                ),
              ],
            ),
            if (_errorMessage != null) ...[
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ],
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _isSignUp ? "Already a member?" : "Not a member?",
                  style: const TextStyle(color: Colors.white),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isSignUp = !_isSignUp;
                      _errorMessage = null;
                    });
                  },
                  child: Text(
                    _isSignUp ? "Login" : "Sign up!",
                    style: const TextStyle(color: Colors.amber),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
