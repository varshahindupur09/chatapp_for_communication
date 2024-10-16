import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

void main() => runApp(ChatApp());

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WebSocket Chat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final WebSocketChannel channel = WebSocketChannel.connect(
    Uri.parse(
        'ws://10.0.0.158:8080/user/your-user-id'), // Replace with WebSocket server URL and user ID
  );

  List<String> _messages = [];

  @override
  void dispose() {
    // Close WebSocket connection when the widget is disposed
    channel.sink.close(status.goingAway);
    super.dispose();
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      // Format the message to include the user ID and message content
      channel.sink.add('your-user-id: ${_controller.text}');
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
                    // Add new messages to the list
                    _messages.add(snapshot.data.toString());
                  }
                  return ListView.builder(
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_messages[index]),
                      );
                    },
                  );
                },
              ),
            ),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Send a message',
              ),
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
