import 'package:flutter/material.dart';
import 'package:neon/core/locale/app_localizations.dart';

import 'chat_connection_status_card.dart';
import 'chat_rag_hero_header.dart';
import 'chat_setup_action_buttons.dart';
import 'chat_status_message_panel.dart';

class ChatLoadModelScrollBody extends StatelessWidget {
  const ChatLoadModelScrollBody({
    super.key,
    required this.l10n,
    required this.statusMessage,
    required this.isServerConnected,
    required this.resolvedBaseUrl,
    required this.isCheckingStatus,
    required this.isBusy,
    required this.canLoadModel,
    required this.onCheckServer,
    required this.onLoadModel,
  });

  final AppLocalizations l10n;
  final String statusMessage;
  final bool isServerConnected;
  final String resolvedBaseUrl;
  final bool isCheckingStatus;
  final bool isBusy;
  final bool canLoadModel;
  final VoidCallback onCheckServer;
  final VoidCallback onLoadModel;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 18),
          ChatRagHeroHeader(l10n: l10n),
          const SizedBox(height: 18),
          ChatConnectionStatusCard(
            l10n: l10n,
            isServerConnected: isServerConnected,
            resolvedBaseUrl: resolvedBaseUrl,
          ),
          const SizedBox(height: 12),
          ChatStatusMessagePanel(message: statusMessage),
          const SizedBox(height: 18),
          ChatSetupActionButtons(
            l10n: l10n,
            isCheckingStatus: isCheckingStatus,
            isBusy: isBusy,
            canLoadModel: canLoadModel,
            onCheckServer: onCheckServer,
            onLoadModel: onLoadModel,
          ),
        ],
      ),
    );
  }
}
