import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'chat_screen.dart'; // Import your ChatScreen file
import 'package:logger/logger.dart'; // For better logging
// import 'dart:developer' as developer;

// void main() {
//   runApp(MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: AuthScreen(),
//   ));
// }

void main() {
  log('log me', name: 'my.app.category');
}

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoginMode = true;
  bool isLoading = false;

  String urlBackend = 'http://10.0.0.158:8080/auth'; // Backend URL

  Future<void> authenticate(String mode) async {
    if (!_formKey.currentState!.validate()) {
      log('Form validation failed', name: 'AuthScreen');
      return;
    }

    final url = '$urlBackend/$mode';
    setState(() {
      isLoading = true;
    });

    try {
      // Log request
      log('Sending $mode request to $url', name: 'AuthScreen');

      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': _usernameController.text.trim(),
          'password': _passwordController.text.trim(),
        }),
      );

      // Log response
      log('Response: ${response.statusCode} - ${response.body}',
          name: 'AuthScreen');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData.containsKey('token')) {
          final String token = responseData['token'];
          final String username = responseData['username'];

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ChatScreen(token: token, username: username),
            ),
          );
        } else {
          throw Exception('Token missing in response');
        }
      } else {
        final errorMessage =
            jsonDecode(response.body)['error'] ?? 'Authentication failed.';
        _showErrorDialog(errorMessage);
      }
    } catch (error) {
      log('Error during $mode: $error', name: 'AuthScreen');
      _showErrorDialog('An error occurred. Please try again later.');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    log('Displaying error dialog: $message', name: 'AuthScreen');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLoginMode ? 'Login' : 'Signup'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              if (isLoading)
                CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: () =>
                      authenticate(isLoginMode ? 'login' : 'register'),
                  child: Text(isLoginMode ? 'Login' : 'Signup'),
                ),
              TextButton(
                onPressed: () {
                  setState(() {
                    isLoginMode = !isLoginMode;
                  });
                  log('Switched to ${isLoginMode ? 'Login' : 'Signup'} mode',
                      name: 'AuthScreen');
                },
                child: Text(isLoginMode
                    ? 'Create an Account'
                    : 'Already have an account?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
