import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/localization/app_locale.dart';
import '../../../core/responsive/content_wrapper.dart';
import '../../../core/voice/speech_service.dart';
import '../../../core/voice/tts_service.dart';
import '../providers/ai_chat_provider.dart';

class AiAssistantScreen extends ConsumerStatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  ConsumerState<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends ConsumerState<AiAssistantScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage([String? customText]) {
    final text = customText ?? _textController.text.trim();
    if (text.isEmpty) return;

    ref.read(aiChatProvider.notifier).sendMessage(text);
    _textController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 80,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _toggleVoiceListening() {
    final speechState = ref.read(speechProvider);
    final isMl = ref.read(localeProvider) == AppLang.ml;

    if (speechState.isListening) {
      ref.read(speechProvider.notifier).stopListening();
    } else {
      ref.read(speechProvider.notifier).startListening(
        localeId: isMl ? 'ml_IN' : 'en_IN',
        onResult: (spokenText) {
          if (spokenText.isNotEmpty) {
            _sendMessage(spokenText);
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    final isMl = ref.watch(localeProvider) == AppLang.ml;
    final chatState = ref.watch(aiChatProvider);
    final speechState = ref.watch(speechProvider);
    final isSpeakingTts = ref.watch(ttsProvider);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: AppColors.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.eco, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                s.aiTitle,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          if (isSpeakingTts)
            IconButton(
              icon: const Icon(Icons.volume_off, color: AppColors.primary),
              tooltip: 'Stop audio',
              onPressed: () => ref.read(ttsProvider.notifier).stop(),
            ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Clear chat',
            onPressed: () => ref.read(aiChatProvider.notifier).clearChat(),
          ),
          TextButton(
            onPressed: () => ref.read(localeProvider.notifier).toggle(),
            child: Text(
              isMl ? 'EN' : 'മലയാളം',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ContentWrapper(
          child: Column(
            children: [
              // Listening Banner when mic active
              if (speechState.isListening)
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.accentAmber.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.accentAmber),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.accentAmber),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          speechState.recognizedWords.isEmpty
                              ? (isMl ? 'കേൾക്കുന്നു... സംസാരിക്കൂ' : 'Listening... Speak now')
                              : speechState.recognizedWords,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                        ),
                      ),
                    ],
                  ),
                ),

              // Chat Messages List
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  itemCount: chatState.messages.length,
                  itemBuilder: (context, idx) {
                    final msg = chatState.messages[idx];
                    return _buildMessageBubble(msg, isMl);
                  },
                ),
              ),

              // Quick suggestion chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    _buildChip(s.q1, () => _sendMessage(s.q1)),
                    const SizedBox(width: 8),
                    _buildChip(s.q2, () => _sendMessage(s.q2)),
                    const SizedBox(width: 8),
                    _buildChip(s.q3, () => _sendMessage(s.q3)),
                  ],
                ),
              ),
              const SizedBox(height: 6),

              // Input Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Voice Mic Button
                    GestureDetector(
                      onTap: _toggleVoiceListening,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: speechState.isListening ? AppColors.accentOrange : AppColors.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          speechState.isListening ? Icons.mic : Icons.mic_none,
                          color: speechState.isListening ? Colors.white : AppColors.primary,
                          size: 22,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _sendMessage(),
                        decoration: InputDecoration(
                          hintText: isMl ? 'സംശയം ചോദിക്കൂ...' : 'Ask your farming question...',
                          hintStyle: const TextStyle(fontSize: 14, color: AppColors.textMuted),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: chatState.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                            )
                          : const Icon(Icons.send_rounded, color: AppColors.primary),
                      onPressed: chatState.isLoading ? null : () => _sendMessage(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg, bool isMl) {
    return Align(
      alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(14),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.82),
        decoration: BoxDecoration(
          color: msg.isUser ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: msg.isUser ? const Radius.circular(16) : Radius.zero,
            bottomRight: msg.isUser ? Radius.zero : const Radius.circular(16),
          ),
          border: msg.isUser ? null : Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              msg.text,
              style: TextStyle(
                color: msg.isUser ? Colors.white : AppColors.textPrimary,
                fontSize: 14.5,
                height: 1.4,
              ),
            ),
            if (!msg.isUser) ...[
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.bottomRight,
                child: InkWell(
                  onTap: () => ref.read(ttsProvider.notifier).speak(msg.text, isMalayalam: isMl),
                  child: const Icon(Icons.volume_up_outlined, size: 18, color: AppColors.primary),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label, VoidCallback onTap) {
    return ActionChip(
      label: Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textPrimary)),
      backgroundColor: AppColors.surfaceVariant,
      side: const BorderSide(color: AppColors.border),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      onPressed: onTap,
    );
  }
}
