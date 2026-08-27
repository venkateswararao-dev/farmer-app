import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/localization/app_locale.dart';
import '../../../core/voice/tts_service.dart';

class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime createdAt;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.createdAt,
  });
}

class AiChatState {
  final bool isLoading;
  final List<ChatMessage> messages;
  final String? sessionId;
  final String? error;

  const AiChatState({
    this.isLoading = false,
    this.messages = const [],
    this.sessionId,
    this.error,
  });

  AiChatState copyWith({
    bool? isLoading,
    List<ChatMessage>? messages,
    String? sessionId,
    String? error,
  }) {
    return AiChatState(
      isLoading: isLoading ?? this.isLoading,
      messages: messages ?? this.messages,
      sessionId: sessionId ?? this.sessionId,
      error: error,
    );
  }
}

class AiChatNotifier extends StateNotifier<AiChatState> {
  final DioClient _dioClient;
  final Ref _ref;

  AiChatNotifier(this._dioClient, this._ref) : super(const AiChatState()) {
    _initWelcomeMessage();
  }

  void _initWelcomeMessage() {
    final isMl = _ref.read(localeProvider) == AppLang.ml;
    state = state.copyWith(
      messages: [
        ChatMessage(
          id: 'welcome',
          text: isMl
              ? 'നമസ്കാരം! ഞാൻ നിങ്ങളുടെ കൃഷി മിത്ര AI സഹായി. തെങ്ങ്, റബ്ബർ, കുരുമുളക്, ഏലം, വാഴ തുടങ്ങിയ വിളകളുടെ പരിപാലനം, രോഗങ്ങൾ, വളപ്രയോഗം എന്നിവയെക്കുറിച്ച് എന്നോട് ചോദിക്കാം അല്ലെങ്കിൽ സംസാരിക്കാം.'
              : 'Namaskaram! I am your Krishi Mithra AI Assistant. You can ask or speak to me about crop care, leaf diseases, fertilizer dosage, or Kerala mandi prices.',
          isUser: false,
          createdAt: DateTime.now(),
        ),
      ],
    );
  }

  Future<void> sendMessage(String text, {bool speakResponse = true}) async {
    if (text.trim().isEmpty) return;

    final userMsg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isUser: true,
      createdAt: DateTime.now(),
    );

    state = state.copyWith(
      isLoading: true,
      messages: [...state.messages, userMsg],
      error: null,
    );

    final isMl = _ref.read(localeProvider) == AppLang.ml;

    try {
      final response = await _dioClient.client.post(
        ApiEndpoints.aiChat,
        data: {
          'message': text,
          'session_id': state.sessionId,
          'language': isMl ? 'ml' : 'en',
        },
      );

      final replyText = response.data['reply'] as String;
      final sessionId = response.data['session_id'] as String?;

      final aiMsg = ChatMessage(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        text: replyText,
        isUser: false,
        createdAt: DateTime.now(),
      );

      state = state.copyWith(
        isLoading: false,
        sessionId: sessionId ?? state.sessionId,
        messages: [...state.messages, aiMsg],
      );

      // Auto-speak response if requested
      if (speakResponse) {
        _ref.read(ttsProvider.notifier).speak(replyText, isMalayalam: isMl);
      }
    } catch (e) {
      final errorReply = isMl
          ? 'സെർവറുമായി ബന്ധപ്പെടാൻ സാധിച്ചില്ല. ദയവായി ഇന്റർനെറ്റ് കണക്ഷനും സെർവറും പരിശോധിക്കുക: $e'
          : 'Failed to connect to AI server. Please verify your connection: $e';

      final aiMsg = ChatMessage(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        text: errorReply,
        isUser: false,
        createdAt: DateTime.now(),
      );

      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        messages: [...state.messages, aiMsg],
      );
    }
  }

  void clearChat() {
    _initWelcomeMessage();
  }
}

final aiChatProvider = StateNotifierProvider<AiChatNotifier, AiChatState>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return AiChatNotifier(dioClient, ref);
});
