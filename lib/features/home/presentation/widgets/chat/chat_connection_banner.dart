import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:neon/core/locale/app_localizations.dart';

class ChatConnectionBanner extends StatelessWidget {
  const ChatConnectionBanner({
    super.key,
    required this.l10n,
    required this.isWaitingForReply,
  });

  final AppLocalizations l10n;
  final bool isWaitingForReply;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              isWaitingForReply
                  ? l10n.chatServerConnectedGenerating
                  : l10n.chatServerConnectedReady,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (isWaitingForReply) ...[
            const SizedBox(width: 8),
            LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.white,
              size: 22,
            ),
          ],
        ],
      ),
    );
  }
}
