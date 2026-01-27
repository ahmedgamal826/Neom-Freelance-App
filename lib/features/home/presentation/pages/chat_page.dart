import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  List<ChatMessage> _messages = [];
  ChatUser currentUser = ChatUser(id: '0', firstName: "User");
  ChatUser geminiUser = ChatUser(id: '1', firstName: "AI Assistant");
  final Gemini gemini = Gemini.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUi(),
    );
  }

  Widget _buildUi() {
    return DashChat(
        currentUser: currentUser, onSend: _sendMessage, messages: _messages);
  }

  Future<void> _sendMessage(ChatMessage chatMessage) async {
    setState(() {
      _messages = [chatMessage, ..._messages];
    });

    try {
      String question = chatMessage.text;
      gemini.streamGenerateContent(question).listen((event) {
        ChatMessage? lastMessage = _messages.firstOrNull;
        if (lastMessage != null && lastMessage.user == geminiUser) {
          lastMessage = _messages.removeAt(0);
          String? response = event.content?.parts
              ?.fold("", (previous, current) => "$previous ${current.text}");
          lastMessage.text += response ?? "";
          setState(() {
            _messages = [lastMessage!, ..._messages];
          });
        } else {
          String? response = event.content?.parts
              ?.fold("", (previous, current) => "$previous ${current.text}");

          ChatMessage message = ChatMessage(
              user: geminiUser,
              createdAt: DateTime.now(),
              text: response ?? "");
          setState(() {
            _messages = [message, ..._messages];
          });
        }
      });
    } catch (e) {
      debugPrint('Error sending message: $e');
    }
  }
}
