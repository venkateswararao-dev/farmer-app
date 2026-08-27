import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/constants/api_endpoints.dart';

final selectedWeatherDistrictProvider = StateProvider<String>((ref) => 'Wayanad');

final weatherDetailsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final district = ref.watch(selectedWeatherDistrictProvider);
  final dio = ref.watch(dioClientProvider).client;

  try {
    final res = await dio.get(ApiEndpoints.weather, queryParameters: {'district': district});
    return res.data as Map<String, dynamic>;
  } catch (e) {
    // Fallback data
    return {
      'district': district,
      'district_ml': district,
      'current': {
        'temperature': 28.0,
        'humidity': 78,
        'feels_like': 30.5,
        'wind_speed': 12.0,
        'precipitation': 0.0,
        'condition': {'en': 'Partly Cloudy', 'ml': 'ഭാഗികമായി മേഘാവൃതം', 'icon': 'partly_cloudy'},
      },
      'advisory': {
        'title_en': 'Favorable Farming Conditions',
        'title_ml': 'അനുകൂല കാർഷിക കാലാവസ്ഥ',
        'message_en': 'Optimal weather for organic fertilizer application, weeding, and normal irrigation.',
        'message_ml': 'ജൈവവള പ്രയോഗത്തിനും കളപറിക്കലിനും ആവശ്യമായ ജലസേചനത്തിനും അനുകൂലമായ കാലാവസ്ഥ.',
        'alert_level': 'NORMAL',
      },
      'forecast': [
        {'date': 'Tomorrow', 'temp_max': 29, 'temp_min': 21, 'precipitation_probability': 40, 'condition': {'en': 'Light Rain', 'ml': 'ചാറ്റൽമഴ'}},
        {'date': 'Day 3', 'temp_max': 28, 'temp_min': 20, 'precipitation_probability': 65, 'condition': {'en': 'Rain', 'ml': 'മഴ'}},
        {'date': 'Day 4', 'temp_max': 27, 'temp_min': 20, 'precipitation_probability': 75, 'condition': {'en': 'Heavy Rain', 'ml': 'ശക്തമായ മഴ'}},
        {'date': 'Day 5', 'temp_max': 28, 'temp_min': 21, 'precipitation_probability': 30, 'condition': {'en': 'Cloudy', 'ml': 'മേഘാവൃതം'}},
      ],
    };
  }
});
