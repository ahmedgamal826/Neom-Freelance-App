import 'package:flutter/material.dart';
import 'package:neon/core/locale/app_localizations.dart';

class ChatConnectionStatusCard extends StatelessWidget {
  const ChatConnectionStatusCard({
    super.key,
    required this.l10n,
    required this.isServerConnected,
    required this.resolvedBaseUrl,
  });

  final AppLocalizations l10n;
  final bool isServerConnected;
  final String resolvedBaseUrl;

  @override
  Widget build(BuildContext context) {
    final statusColor =
        isServerConnected ? Colors.greenAccent : Colors.redAccent;
    final statusText =
        isServerConnected ? l10n.chatServerOnline : l10n.chatServerOffline;
    final statusIcon = isServerConnected ? Icons.cloud_done : Icons.cloud_off;

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
            'Server: $resolvedBaseUrl',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
