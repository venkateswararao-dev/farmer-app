import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/constants/api_endpoints.dart';

class DashboardData {
  final Map<String, dynamic> weather;
  final List<dynamic> recommendations;
  final List<dynamic> marketPrices;
  final List<dynamic> crops;
  final List<dynamic> diagnoses;

  DashboardData({
    required this.weather,
    required this.recommendations,
    required this.marketPrices,
    required this.crops,
    required this.diagnoses,
  });
}

final dashboardDataProvider = FutureProvider<DashboardData>((ref) async {
  final dio = ref.watch(dioClientProvider).client;

  Map<String, dynamic> weather = {
    'district': 'Wayanad',
    'district_ml': 'വയനാട്',
    'current': {
      'temperature': 27.5,
      'humidity': 82,
      'feels_like': 29.0,
      'wind_speed': 10.5,
      'condition': {'en': 'Partly Cloudy', 'ml': 'ഭാഗികമായി മേഘാവൃതം', 'icon': 'partly_cloudy'},
    },
    'advisory': {
      'title_en': 'Favorable Weather for Weeding & Composting',
      'title_ml': 'വളപ്രയോഗത്തിനും കളപറിക്കലിനും അനുകൂലമായ കാലാവസ്ഥ',
      'message_en': 'Optimal conditions for organic fertilizer application and routine farm care.',
      'message_ml': 'ജൈവവള പ്രയോഗത്തിനും കളപറിക്കലിനും ആവശ്യമായ ജലസേചനത്തിനും അനുകൂലമായ കാലാവസ്ഥ.',
      'alert_level': 'NORMAL',
    },
  };

  List<dynamic> recommendations = [
    {
      'id': 'rec-1',
      'category': 'FERTILIZER',
      'title_en': 'Second Compost Dosage for Coconut Palms',
      'title_ml': 'തെങ്ങിനുള്ള രണ്ടാം ഗഡു ജൈവവള പ്രയോഗം',
      'description_en': 'Apply 25kg farmyard manure + 500g Trichoderma in the palm basin.',
      'description_ml': 'ഒരു തെങ്ങിന് 25 കിലോ ചാണകപ്പൊടിയും 500 ഗ്രാം ട്രൈക്കോഡെർമയും ചേർത്ത് തടത്തിൽ ഇടുക.',
      'is_completed': false,
    },
    {
      'id': 'rec-2',
      'category': 'PEST_CONTROL',
      'title_en': 'Bordeaux Mixture for Black Pepper Vines',
      'title_ml': 'കുരുമുളകിന് ബോർഡോ മിശ്രിത തളിക്കൽ',
      'description_en': 'Spray 1% Bordeaux mixture on leaves and drench basin with copper oxychloride for quick wilt.',
      'description_ml': 'ദ്രുതവാട്ടം തടയാൻ കുരുമുളക് വള്ളികളിൽ 1% ബോർഡോ മിശ്രിതം തളിക്കുക.',
      'is_completed': false,
    },
  ];

  List<dynamic> marketPrices = [
    {
      'commodity_name_en': 'Rubber (RSS-4)',
      'commodity_name_ml': 'റബ്ബർ (RSS-4)',
      'market_name': 'Kottayam Rubber Board',
      'modal_price': 192.0,
      'unit': 'Kg',
      'price_change_pct': 1.85,
      'trend': 'UP',
    },
    {
      'commodity_name_en': 'Black Pepper (Garbled)',
      'commodity_name_ml': 'കുരുമുളക് (ഗാർബിൾഡ്)',
      'market_name': 'Kochi Spices Market',
      'modal_price': 672.0,
      'unit': 'Kg',
      'price_change_pct': 2.15,
      'trend': 'UP',
    },
    {
      'commodity_name_en': 'Cardamom (7-8mm)',
      'commodity_name_ml': 'ചെറു ഏലം',
      'market_name': 'Vandanmedu Spices Board',
      'modal_price': 2650.0,
      'unit': 'Kg',
      'price_change_pct': -0.95,
      'trend': 'DOWN',
    },
    {
      'commodity_name_en': 'Coconut (Raw)',
      'commodity_name_ml': 'പച്ചത്തേങ്ങ',
      'market_name': 'Kozhikode APMC',
      'modal_price': 39.5,
      'unit': 'Kg',
      'price_change_pct': 3.4,
      'trend': 'UP',
    },
  ];

  List<dynamic> crops = [
    {'id': '1', 'crop_name_en': 'Coconut', 'crop_name_ml': 'തെങ്ങ്', 'area_acres': 1.5, 'health_status': 'Healthy', 'growth_stage': 'Yielding'},
    {'id': '2', 'crop_name_en': 'Black Pepper', 'crop_name_ml': 'കുരുമുളക്', 'area_acres': 1.0, 'health_status': 'Healthy', 'growth_stage': 'Flowering'},
    {'id': '3', 'crop_name_en': 'Rubber', 'crop_name_ml': 'റബ്ബർ', 'area_acres': 1.0, 'health_status': 'Good', 'growth_stage': 'Tapping'},
  ];

  List<dynamic> diagnoses = [];

  try {
    final weatherRes = await dio.get(ApiEndpoints.weather, queryParameters: {'district': 'Wayanad'});
    weather = weatherRes.data;
  } catch (_) {}

  try {
    final recRes = await dio.get(ApiEndpoints.aiRecommendations);
    if (recRes.data is List && (recRes.data as List).isNotEmpty) {
      recommendations = recRes.data;
    }
  } catch (_) {}

  try {
    final priceRes = await dio.get(ApiEndpoints.marketPrices);
    if (priceRes.data is List && (priceRes.data as List).isNotEmpty) {
      marketPrices = priceRes.data;
    }
  } catch (_) {}

  try {
    final cropsRes = await dio.get(ApiEndpoints.crops);
    if (cropsRes.data is List && (cropsRes.data as List).isNotEmpty) {
      crops = cropsRes.data;
    }
  } catch (_) {}

  try {
    final diagRes = await dio.get(ApiEndpoints.aiDiseaseHistory);
    if (diagRes.data is List) {
      diagnoses = diagRes.data;
    }
  } catch (_) {}

  return DashboardData(
    weather: weather,
    recommendations: recommendations,
    marketPrices: marketPrices,
    crops: crops,
    diagnoses: diagnoses,
  );
});
