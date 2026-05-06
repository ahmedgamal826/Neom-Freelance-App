
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:neon/core/locale/app_localizations.dart';
import 'package:neon/core/locale/locale_provider.dart';
import 'package:provider/provider.dart';

import '../../../../core/Services/Api/api_services.dart';
import '../widgets/chat/chat_dash_area.dart';
import '../widgets/chat/chat_page_background.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // =========================
  // API SERVICE
  // =========================
  final ApiServices _apiServices = ApiServices();

  // =========================
  // CHAT MESSAGES
  // =========================
  final List<ChatMessage> _messages = [];

  // =========================
  // BOT USER
  // =========================
  static final ChatUser _chatbotUser = ChatUser(
    id: '1',
    firstName: 'NEOM Assistant',
  );

  // =========================
  // STATES
  // =========================
  bool _isWaitingForReply = false;

  // =========================
  // INIT
  // =========================
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final l10n =
      AppLocalizations(context.read<LocaleProvider>().locale);

      setState(() {
        _messages.insert(
          0,
          ChatMessage(
            user: _chatbotUser,
            createdAt: DateTime.now(),
            text: l10n.chatWelcomeMessage,
          ),
        );
      });
    });
  }

  // =========================
  // SEND MESSAGE
  // =========================
  Future<void> _sendMessage(ChatMessage message) async {
    setState(() {
      _messages.insert(0, message);
      _isWaitingForReply = true;
    });

    try {
      final response = await _apiServices.sendMessage(
        question: message.text,
        topK: 4,
        temperature: 0.1,
        maxTokens: 500,
      );

      if (!mounted) return;

      setState(() {
        _messages.insert(
          0,
          ChatMessage(
            user: _chatbotUser,
            createdAt: DateTime.now(),
            text: response.answer,
          ),
        );
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _messages.insert(
          0,
          ChatMessage(
            user: _chatbotUser,
            createdAt: DateTime.now(),
            text: '❌ $e',
          ),
        );
      });
    } finally {
      if (mounted) {
        setState(() {
          _isWaitingForReply = false;
        });
      }
    }
  }

  // =========================
  // UI
  // =========================
  @override
  Widget build(BuildContext context) {
    final l10n =
    AppLocalizations(context.watch<LocaleProvider>().locale);

    final isArabicApp =
        l10n.locale.languageCode == 'ar';

    return Scaffold(
      body: ChatPageBackground(
        child: ChatDashArea(
          l10n: l10n,
          isArabicApp: isArabicApp,
          messages: _messages,
          isWaitingForReply: _isWaitingForReply,
          onSend: (message) async {
            await _sendMessage(message);
          },
        ),
      ),
    );
  }
}
