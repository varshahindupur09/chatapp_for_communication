// chatapp_frontend/lib/main.dart
// Starting with the login screen first.
// Upon successful login, navigate to the chat screen with the JWT token.
// Using the WebSocket connection in the chat screen once authenticated.

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:chatapp_frontend/screens/login_screen.dart'; // LoginScreen
import 'package:chatapp_frontend/screens/chat_screen.dart'; // ChatScreen

void main() => runApp(ChatApp());

final url_ws = 'ws://10.0.0.158:8080/chat';

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WebSocket Chat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Ensuring the initial screen is the ChatScreen
      home: AuthScreen(), // This ensures the app starts with the login screen
    );
  }
}
