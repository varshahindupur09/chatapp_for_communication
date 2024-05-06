// chatapp_frontend/lib/login_screen.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'chat_screen.dart'; // Import ChatScreen

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoginMode = true;
  String urlBackend = 'http://10.0.0.158:8080/auth';

  // Function to handle login/signup (mode: 'login' or 'register')
  Future<void> authenticate(String mode) async {
    final url = '$urlBackend/$mode'; // Backend URL for login/signup

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': _usernameController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      // Extract the token from the response
      final token = jsonDecode(response.body)['token'];
      final username = _usernameController.text;

      // Navigate to the chat screen, passing the token and username
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(token: token, username: username),
        ),
      );
    } else {
      // Show an error if the login/signup fails
      print('Authentication failed: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isLoginMode ? 'Login' : 'Signup')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () => authenticate(isLoginMode ? 'login' : 'register'),
              child: Text(isLoginMode ? 'Login' : 'Signup'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  isLoginMode =
                      !isLoginMode; // Toggle between login and signup mode
                });
              },
              child: Text(isLoginMode
                  ? 'Create an Account'
                  : 'Already have an account?'),
            ),
          ],
        ),
      ),
    );
  }
}
