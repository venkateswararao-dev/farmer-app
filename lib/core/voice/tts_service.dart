import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsNotifier extends StateNotifier<bool> {
  final FlutterTts _tts = FlutterTts();

  TtsNotifier() : super(false) {
    _initTts();
  }

  Future<void> _initTts() async {
    try {
      await _tts.setSpeechRate(0.48);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);

      _tts.setStartHandler(() {
        state = true;
      });

      _tts.setCompletionHandler(() {
        state = false;
      });

      _tts.setErrorHandler((msg) {
        state = false;
        debugPrint('TTS Error: $msg');
      });
    } catch (e) {
      debugPrint('TTS init error: $e');
    }
  }

  Future<void> speak(String text, {bool isMalayalam = true}) async {
    try {
      if (state) {
        await stop();
      }

      // Set language code
      if (isMalayalam) {
        await _tts.setLanguage('ml-IN');
      } else {
        await _tts.setLanguage('en-IN');
      }

      await _tts.speak(text);
    } catch (e) {
      debugPrint('TTS speak error: $e');
      state = false;
    }
  }

  Future<void> stop() async {
    await _tts.stop();
    state = false;
  }
}

final ttsProvider = StateNotifierProvider<TtsNotifier, bool>((ref) {
  return TtsNotifier();
});
