// chart_screen.dart
// 'ws://10.0.0.158:8080/user/${widget.token}
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class ChatScreen extends StatefulWidget {
  final String token; // JWT Token passed from AuthScreen
  final String username; // Username passed from AuthScreen

  ChatScreen(
      {required this.token,
      required this.username}); // Accept both token and username

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late WebSocketChannel channel;
  final TextEditingController _controller = TextEditingController();
  List<String> _messages = [];

  @override
  void initState() {
    super.initState();
    // Use token in WebSocket connection
    channel = WebSocketChannel.connect(
      Uri.parse(
          'ws://10.0.0.158:8080/chat?token=${widget.token}'), // Authenticate WebSocket with token
    );
  }

  @override
  void dispose() {
    // Close WebSocket connection when widget is disposed
    channel.sink.close(status.goingAway);
    super.dispose();
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      // Send message along with the username
      channel.sink.add('${widget.username}: ${_controller.text}');
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Multi-User WebSocket Chat'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder(
                stream: channel.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    _messages.add(snapshot.data.toString());
                  }
                  return ListView.builder(
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_messages[index]), // Display message
                      );
                    },
                  );
                },
              ),
            ),
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Send a message'),
              onSubmitted: (_) => _sendMessage(),
            ),
            ElevatedButton(
              onPressed: _sendMessage,
              child: Text('Send'),
            ),
          ],
        ),
      ),
    );
  }
}
