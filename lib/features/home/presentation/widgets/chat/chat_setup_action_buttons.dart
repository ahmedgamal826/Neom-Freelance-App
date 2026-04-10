import 'package:flutter/material.dart';
import 'package:neon/core/locale/app_localizations.dart';

class ChatSetupActionButtons extends StatelessWidget {
  const ChatSetupActionButtons({
    super.key,
    required this.l10n,
    required this.isCheckingStatus,
    required this.isBusy,
    required this.canLoadModel,
    required this.onCheckServer,
    required this.onLoadModel,
  });

  final AppLocalizations l10n;
  final bool isCheckingStatus;
  final bool isBusy;
  final bool canLoadModel;
  final VoidCallback onCheckServer;
  final VoidCallback onLoadModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            onPressed: isCheckingStatus ? null : onCheckServer,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF64B5F6)),
              foregroundColor: const Color(0xFF90CAF9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            icon: isCheckingStatus
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.wifi_protected_setup),
            label: Text(l10n.chatCheckServerConnection),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: canLoadModel ? onLoadModel : null,
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
            label: Text(isBusy ? l10n.chatLoading : l10n.chatLoadModel),
          ),
        ),
      ],
    );
  }
}
