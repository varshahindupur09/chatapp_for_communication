// login_screen.dart
//  Uri.parse('http://10.0.0.158:8080/auth/login'), // Use your backend IP

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'chat_screen.dart'; // Import the ChatScreen

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoginMode = true;

  // Personalized for your backend to authenticate with Spring Boot
  Future<void> authenticate(String mode) async {
    final url =
        'http://127.0.0.1:8080/auth/${mode}'; // Use the correct backend URL

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
      final token = jsonDecode(response.body)['token']; // Extract JWT token
      final username =
          _usernameController.text; // Pass the username along with the token

      // Navigate to ChatScreen, passing the token
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(
              token: token,
              username: username), // Send token and username to ChatScreen
        ),
      );
    } else {
      print('Authentication failed');
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
              onPressed: () => authenticate(isLoginMode ? 'login' : 'signup'),
              child: Text(isLoginMode ? 'Login' : 'Signup'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  isLoginMode = !isLoginMode;
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
