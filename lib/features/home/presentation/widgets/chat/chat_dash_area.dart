import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:neon/core/locale/app_localizations.dart';

import 'chat_connection_banner.dart';
import 'chat_message_text_direction.dart';

class ChatDashArea extends StatelessWidget {
  const ChatDashArea({
    super.key,
    required this.l10n,
    required this.isArabicApp,
    required this.messages,
    required this.isWaitingForReply,
    required this.onSend,
  });

  final AppLocalizations l10n;
  final bool isArabicApp;
  final List<ChatMessage> messages;
  final bool isWaitingForReply;
  final void Function(ChatMessage) onSend;

  @override
  Widget build(BuildContext context) {
    final ChatUser currentUser =
        ChatUser(id: '0', firstName: l10n.chatCurrentUserName);
    final TextDirection inputDir =
        isArabicApp ? TextDirection.rtl : TextDirection.ltr;

    return Column(
      children: [
        ChatConnectionBanner(
          l10n: l10n,
          isWaitingForReply: isWaitingForReply,
        ),
        Expanded(
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: DashChat(
              currentUser: currentUser,
              onSend: isWaitingForReply ? (_) {} : onSend,
              messages: messages,
              messageOptions: MessageOptions(
                showOtherUsersName: true,
                showCurrentUserAvatar: false,
                showOtherUsersAvatar: true,
                showTime: false,
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
                  final isCurrentUser = message.user.id == currentUser.id;
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
                messageTextBuilder: (message, previousMessage, nextMessage) {
                  final isCurrentUser = message.user.id == currentUser.id;
                  final detectedDirection =
                      resolveChatMessageTextDirection(message.text);
                  final TextDirection bubbleDirection = isCurrentUser
                      ? (isArabicApp
                          ? TextDirection.rtl
                          : TextDirection.ltr)
                      : detectedDirection;
                  final formattedTime = intl.DateFormat(
                    'hh:mm a',
                  ).format(message.createdAt);

                  return Directionality(
                    textDirection: bubbleDirection,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment:
                          bubbleDirection == TextDirection.rtl
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.text,
                          textAlign: bubbleDirection == TextDirection.rtl
                              ? TextAlign.right
                              : TextAlign.left,
                          style: TextStyle(
                            color: isCurrentUser
                                ? Colors.white
                                : const Color(0xFF1E1F22),
                            fontSize: 14,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Align(
                          widthFactor: 1,
                          alignment: isCurrentUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: Text(
                              formattedTime,
                              style: TextStyle(
                                fontSize: 11,
                                color: isCurrentUser
                                    ? Colors.white.withValues(alpha: 0.78)
                                    : const Color(0xFF6B7280),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
                inputDisabled: isWaitingForReply,
                inputTextDirection: inputDir,
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
                  hintText: l10n.chatInputHint,
                  hintTextDirection: inputDir,
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
}
