import 'package:neon/core/locale/app_localizations.dart';

/// Loading / setup states before the DashChat UI is shown.
enum ChatSetupPhase {
  promptTapCheck,
  checkingServer,
  onlineModelReady,
  onlineModelNotReady,
  loadingModel,
  openingChat,
  loadResultSummary,
  rawError,
  disconnectedBeforeLoad,
}

String formatChatSetupStatus(
  ChatSetupPhase phase,
  AppLocalizations l10n, {
  required String rawErrorText,
  required String summaryApiMsg,
  required String summaryModel,
  required int summaryQuestions,
}) {
  switch (phase) {
    case ChatSetupPhase.promptTapCheck:
      return l10n.chatTapCheckFirst;
    case ChatSetupPhase.checkingServer:
      return l10n.chatCheckingServer;
    case ChatSetupPhase.onlineModelReady:
      return l10n.chatModelReadyTapLoad;
    case ChatSetupPhase.onlineModelNotReady:
      return l10n.chatServerOkTapLoadModel;
    case ChatSetupPhase.loadingModel:
      return l10n.chatLoadingModelWait;
    case ChatSetupPhase.openingChat:
      return l10n.chatOpeningChat;
    case ChatSetupPhase.loadResultSummary:
      return l10n.chatModelLoadSummary(
        summaryApiMsg,
        summaryModel,
        summaryQuestions,
      );
    case ChatSetupPhase.rawError:
      return rawErrorText;
    case ChatSetupPhase.disconnectedBeforeLoad:
      return l10n.chatServerOfflineCheckFirst;
  }
}
