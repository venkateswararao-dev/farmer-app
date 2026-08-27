import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechState {
  final bool isListening;
  final String recognizedWords;
  final bool isAvailable;

  const SpeechState({
    this.isListening = false,
    this.recognizedWords = '',
    this.isAvailable = false,
  });

  SpeechState copyWith({
    bool? isListening,
    String? recognizedWords,
    bool? isAvailable,
  }) {
    return SpeechState(
      isListening: isListening ?? this.isListening,
      recognizedWords: recognizedWords ?? this.recognizedWords,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}

class SpeechNotifier extends StateNotifier<SpeechState> {
  final stt.SpeechToText _speech = stt.SpeechToText();

  SpeechNotifier() : super(const SpeechState()) {
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    try {
      final available = await _speech.initialize(
        onError: (val) {
          state = state.copyWith(isListening: false);
        },
        onStatus: (status) {
          if (status == 'done' || status == 'notListening') {
            state = state.copyWith(isListening: false);
          }
        },
      );
      state = state.copyWith(isAvailable: available);
    } catch (e) {
      debugPrint('Speech init error: $e');
    }
  }

  Future<void> startListening({
    String localeId = 'ml_IN',
    required Function(String text) onResult,
  }) async {
    if (!state.isAvailable) {
      await _initSpeech();
    }

    state = state.copyWith(isListening: true, recognizedWords: '');

    try {
      await _speech.listen(
        onResult: (result) {
          final words = result.recognizedWords;
          state = state.copyWith(recognizedWords: words);
          if (result.finalResult) {
            onResult(words);
          }
        },
        listenOptions: stt.SpeechListenOptions(
          listenMode: stt.ListenMode.confirmation,
          partialResults: true,
        ),
      );
    } catch (e) {
      state = state.copyWith(isListening: false);
    }
  }

  Future<void> stopListening() async {
    await _speech.stop();
    state = state.copyWith(isListening: false);
  }
}

final speechProvider = StateNotifierProvider<SpeechNotifier, SpeechState>((ref) {
  return SpeechNotifier();
});
