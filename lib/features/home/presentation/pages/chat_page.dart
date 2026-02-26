import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../core/Services/Api/api_services.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  final ApiServices _apiServices = ApiServices();
  final List<ChatMessage> _messages = <ChatMessage>[];
  final ChatUser _currentUser = ChatUser(id: '0', firstName: 'المستخدم');
  final ChatUser _chatbotUser = ChatUser(id: '1', firstName: 'NEOM Assistant');

  bool _isCheckingStatus = false;
  bool _isLoadingModel = false;
  bool _isWaitingForReply = false;
  bool _isModelLoaded = false;
  bool _isModelReadyOnServer = false;
  bool _isServerConnected = false;
  String _statusMessage = '';
  String _resolvedBaseUrl = '';

  @override
  void initState() {
    super.initState();
    _checkModelStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF202124), Color(0xFF343538), Color(0xFF1C1D1F)],
          ),
        ),
        child: SafeArea(
          child: _isModelLoaded ? _buildChatUi() : _buildLoadModelUi(),
        ),
      ),
    );
  }

  Widget _buildChatUi() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(16, 10, 16, 8),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF1F8B5C),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF35C48A)),
          ),
          child: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _isWaitingForReply
                      ? 'الخادم متصل - جاري توليد الرد...'
                      : 'الخادم متصل - المودل محمل وجاهز للمحادثة',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (_isWaitingForReply) ...[
                const SizedBox(width: 8),
                LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.white,
                  size: 22,
                ),
              ],
            ],
          ),
        ),
        Expanded(
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: DashChat(
              currentUser: _currentUser,
              onSend: _isWaitingForReply ? (_) {} : _sendMessage,
              messages: _messages,
              messageOptions: MessageOptions(
                showOtherUsersName: true,
                showCurrentUserAvatar: false,
                showOtherUsersAvatar: true,
                showTime: true,
                timeFormat: intl.DateFormat('hh:mm a'),
                currentUserContainerColor: const Color(0xFF5B3CC4),
                currentUserTextColor: Colors.white,
                currentUserTimeTextColor: Colors.white.withValues(alpha: 0.78),
                containerColor: const Color(0xFFFFFFFF),
                textColor: const Color(0xFF1E1F22),
                timeTextColor: const Color(0xFF6B7280),
                borderRadius: 16,
                messagePadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                marginDifferentAuthor: const EdgeInsets.only(top: 14),
                marginSameAuthor: const EdgeInsets.only(top: 6),
                messageDecorationBuilder:
                    (message, previousMessage, nextMessage) {
                  final isCurrentUser = message.user.id == _currentUser.id;
                  return BoxDecoration(
                    color: isCurrentUser
                        ? const Color(0xFF5B3CC4)
                        : const Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(16),
                    border: isCurrentUser
                        ? null
                        : Border.all(
                            color: const Color(0xFFD7DBE0),
                            width: 1,
                          ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  );
                },
                userNameBuilder: (user) => Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    user.firstName ?? user.id,
                    style: const TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              messageListOptions: MessageListOptions(
                showDateSeparator: true,
                dateSeparatorBuilder: (date) {
                  return Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.28),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        intl.DateFormat('hh:mm a').format(date),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                },
              ),
              inputOptions: InputOptions(
                sendOnEnter: true,
                alwaysShowSend: true,
                inputDisabled: _isWaitingForReply,
                inputTextDirection: TextDirection.rtl,
                cursorStyle: const CursorStyle(color: Color(0xFF37474F)),
                inputTextStyle: const TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                ),
                inputToolbarPadding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
                inputToolbarStyle: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                sendButtonBuilder: (send) => Padding(
                  padding: const EdgeInsets.only(right: 6, left: 6),
                  child: Material(
                    color: const Color(0xFF5B3CC4),
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      onTap: send,
                      borderRadius: BorderRadius.circular(8),
                      child: const SizedBox(
                        width: 42,
                        height: 42,
                        child: Icon(
                          Icons.send_rounded,
                          size: 21,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                inputDecoration: InputDecoration(
                  hintText: 'اكتب سؤالك عن نيوم...',
                  hintTextDirection: TextDirection.rtl,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color(0xFF9FA8DA),
                      width: 1.4,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadModelUi() {
    final isBusy = _isLoadingModel || _isCheckingStatus;
    final canLoadModel = _isServerConnected && !isBusy;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: const LinearGradient(
                colors: [Color(0xFF0F4C81), Color(0xFF2A9D8F)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Column(
              children: [
                Icon(Icons.smart_toy_rounded, color: Colors.white, size: 42),
                SizedBox(height: 8),
                Text(
                  'NEOM RAG Chatbot',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'جهّز المودل أولاً ثم ابدأ المحادثة',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _buildConnectionStatusCard(),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF2B2D31),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white12),
            ),
            child: Text(
              _statusMessage.isEmpty
                  ? 'اضغط على "فحص اتصال السيرفر" أولاً.'
                  : _statusMessage,
              style: const TextStyle(color: Colors.white70, height: 1.45),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: _isCheckingStatus ? null : _checkModelStatus,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF64B5F6)),
                foregroundColor: const Color(0xFF90CAF9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: _isCheckingStatus
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.wifi_protected_setup),
              label: const Text('فحص اتصال السيرفر'),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: canLoadModel ? _loadModel : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF19A974),
                disabledBackgroundColor: const Color(0xFF5B5E66),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: isBusy
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.download_for_offline_outlined),
              label: Text(isBusy ? 'جاري التحميل...' : 'تحميل المودل'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionStatusCard() {
    final statusColor =
        _isServerConnected ? Colors.greenAccent : Colors.redAccent;
    final statusText = _isServerConnected ? 'السيرفر متصل' : 'السيرفر غير متصل';
    final statusIcon = _isServerConnected ? Icons.cloud_done : Icons.cloud_off;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2D32),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: statusColor.withValues(alpha: 0.7)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(statusIcon, color: statusColor),
              const SizedBox(width: 8),
              Text(
                statusText,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Server: $_resolvedBaseUrl',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Future<void> _checkModelStatus() async {
    setState(() {
      _isCheckingStatus = true;
      _resolvedBaseUrl = _apiServices.baseUrl;
      _statusMessage = 'جاري التحقق من حالة الخادم...';
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
        // Keep user on load screen until they explicitly press the model button.
        _statusMessage = status.modelLoaded
            ? 'المودل جاهز على السيرفر. اضغط "تحميل المودل" للدخول إلى الشات.'
            : 'الخادم متصل. اضغط "تحميل المودل" لبدء تحميل النموذج.';
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isServerConnected = false;
        _resolvedBaseUrl = _apiServices.resolvedBaseUrl;
        _statusMessage = error.toString();
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
        _statusMessage = 'السيرفر غير متصل. نفّذ فحص الاتصال أولاً.';
      });
      return;
    }

    setState(() {
      _isLoadingModel = true;
      _statusMessage = 'جاري تحميل المودل، قد يستغرق ذلك عدة دقائق...';
    });

    try {
      if (_isModelReadyOnServer) {
        if (!mounted) {
          return;
        }
        setState(() {
          _statusMessage =
              'المودل كان محملاً بالفعل. جاري فتح شاشة المحادثة...';
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
        _statusMessage =
            '${loadResult.message}\nالمودل: ${loadResult.model}\nعدد الأسئلة: ${loadResult.questionsCount}';
      });
      if (loadResult.success) {
        _activateChatScreen();
      }
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _statusMessage = error.toString();
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
    setState(() {
      _isModelLoaded = true;
      if (_messages.isEmpty) {
        _messages.insert(
          0,
          ChatMessage(
            user: _chatbotUser,
            createdAt: DateTime.now(),
            text:
                'مرحباً بك! أنا مساعد نيوم الذكي. اسألني أي سؤال متعلق بمشروع NEOM.',
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
      setState(() {
        _messages.insert(
          0,
          ChatMessage(
            user: _chatbotUser,
            createdAt: DateTime.now(),
            text: 'حدث خطأ أثناء التواصل مع الخادم: $error',
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
