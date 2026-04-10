import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:neon/core/locale/app_localizations.dart';
import 'package:neon/core/locale/locale_provider.dart';
import 'package:provider/provider.dart';

import '../../../../core/Services/Api/api_services.dart';
import '../widgets/chat/chat_dash_area.dart';
import '../widgets/chat/chat_load_model_scroll_body.dart';
import '../widgets/chat/chat_page_background.dart';
import '../widgets/chat/chat_setup_phase.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  final ApiServices _apiServices = ApiServices();
  final List<ChatMessage> _messages = <ChatMessage>[];
  static final ChatUser _chatbotUser =
      ChatUser(id: '1', firstName: 'NEOM Assistant');

  ChatSetupPhase _phase = ChatSetupPhase.promptTapCheck;
  /// Kept as the thrown value so status text re-localizes when locale changes.
  Object? _lastSetupError;
  String _summaryApiMsg = '';
  String _summaryModel = '';
  int _summaryQuestions = 0;

  bool _isCheckingStatus = false;
  bool _isLoadingModel = false;
  bool _isWaitingForReply = false;
  bool _isModelLoaded = false;
  bool _isModelReadyOnServer = false;
  bool _isServerConnected = false;
  String _resolvedBaseUrl = '';

  @override
  void initState() {
    super.initState();
    _checkModelStatus();
  }

  String _displaySetupStatus(AppLocalizations l10n) {
    return formatChatSetupStatus(
      _phase,
      l10n,
      rawErrorText: _phase == ChatSetupPhase.rawError &&
              _lastSetupError != null
          ? _apiErrorUserText(_lastSetupError!, l10n)
          : '',
      summaryApiMsg: _summaryApiMsg,
      summaryModel: _summaryModel,
      summaryQuestions: _summaryQuestions,
    );
  }

  /// Maps [ApiUserFacing] to UI strings so API stays free of Flutter l10n.
  String _apiErrorUserText(Object error, AppLocalizations l10n) {
    if (error is ApiException && error.facing != null) {
      switch (error.facing!) {
        case ApiUserFacing.serverConnectionTimeout:
          return l10n.chatErrorServerConnectionTimeout;
        case ApiUserFacing.loadModelTimeout:
          return l10n.chatErrorLoadModelTimeout;
        case ApiUserFacing.sendMessageTimeout:
          return l10n.chatErrorSendMessageTimeout;
      }
    }
    return error.toString();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations(context.watch<LocaleProvider>().locale);
    final isArabicApp = l10n.locale.languageCode == 'ar';

    return Scaffold(
      body: ChatPageBackground(
        child: _isModelLoaded
            ? ChatDashArea(
                l10n: l10n,
                isArabicApp: isArabicApp,
                messages: _messages,
                isWaitingForReply: _isWaitingForReply,
                onSend: _sendMessage,
              )
            : ChatLoadModelScrollBody(
                l10n: l10n,
                statusMessage: _displaySetupStatus(l10n),
                isServerConnected: _isServerConnected,
                resolvedBaseUrl: _resolvedBaseUrl,
                isCheckingStatus: _isCheckingStatus,
                isBusy: _isLoadingModel || _isCheckingStatus,
                canLoadModel: _isServerConnected &&
                    !(_isLoadingModel || _isCheckingStatus),
                onCheckServer: _checkModelStatus,
                onLoadModel: _loadModel,
              ),
      ),
    );
  }

  Future<void> _checkModelStatus() async {
    setState(() {
      _isCheckingStatus = true;
      _resolvedBaseUrl = _apiServices.baseUrl;
      _phase = ChatSetupPhase.checkingServer;
      _lastSetupError = null;
    });

    try {
      final status = await _apiServices.getStatus();
      if (!mounted) {
        return;
      }
      setState(() {
        _isServerConnected = true;
        _resolvedBaseUrl = _apiServices.resolvedBaseUrl;
        _isModelReadyOnServer = status.modelLoaded;
        _lastSetupError = null;
        _phase = status.modelLoaded
            ? ChatSetupPhase.onlineModelReady
            : ChatSetupPhase.onlineModelNotReady;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isServerConnected = false;
        _resolvedBaseUrl = _apiServices.resolvedBaseUrl;
        _phase = ChatSetupPhase.rawError;
        _lastSetupError = error;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isCheckingStatus = false;
        });
      }
    }
  }

  Future<void> _loadModel() async {
    if (!_isServerConnected) {
      setState(() {
        _phase = ChatSetupPhase.disconnectedBeforeLoad;
      });
      return;
    }

    setState(() {
      _isLoadingModel = true;
      _phase = ChatSetupPhase.loadingModel;
      _lastSetupError = null;
    });

    try {
      if (_isModelReadyOnServer) {
        if (!mounted) {
          return;
        }
        setState(() {
          _phase = ChatSetupPhase.openingChat;
        });
        _activateChatScreen();
        return;
      }

      final loadResult = await _apiServices.loadModel();
      if (!mounted) {
        return;
      }
      setState(() {
        _isModelReadyOnServer = loadResult.success;
        _phase = ChatSetupPhase.loadResultSummary;
        _summaryApiMsg = loadResult.message;
        _summaryModel = loadResult.model;
        _summaryQuestions = loadResult.questionsCount;
      });
      if (loadResult.success) {
        _activateChatScreen();
      }
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _phase = ChatSetupPhase.rawError;
        _lastSetupError = error;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingModel = false;
        });
      }
    }
  }

  void _activateChatScreen() {
    final l10n = AppLocalizations(context.read<LocaleProvider>().locale);
    setState(() {
      _isModelLoaded = true;
      if (_messages.isEmpty) {
        _messages.insert(
          0,
          ChatMessage(
            user: _chatbotUser,
            createdAt: DateTime.now(),
            text: l10n.chatWelcomeMessage,
          ),
        );
      }
    });
  }

  Future<void> _sendMessage(ChatMessage chatMessage) async {
    setState(() {
      _messages.insert(0, chatMessage);
      _isWaitingForReply = true;
    });

    try {
      final response = await _apiServices.sendMessage(
        question: chatMessage.text,
        topK: 4,
        temperature: 0.1,
        maxTokens: 220,
      );
      if (!mounted) {
        return;
      }
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
    } catch (error) {
      if (!mounted) {
        return;
      }
      final l10n = AppLocalizations(context.read<LocaleProvider>().locale);
      final errorText = error is ApiException && error.facing != null
          ? _apiErrorUserText(error, l10n)
          : l10n.chatSendError(error);
      setState(() {
        _messages.insert(
          0,
          ChatMessage(
            user: _chatbotUser,
            createdAt: DateTime.now(),
            text: errorText,
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
}
