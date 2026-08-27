import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../auth/providers/auth_provider.dart';
import '../../farm_profile/providers/farm_provider.dart';

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
  final farmState = ref.watch(farmProfileProvider);
  final user = ref.watch(authProvider).user;

  // Dynamically resolve the farmer's selected district
  final userDistrict = farmState.profile?['district']?.toString() ??
      user?['farmer_profile']?['district']?.toString() ??
      'Idukki';

  Map<String, dynamic> weather = {
    'district': userDistrict,
    'district_ml': userDistrict,
    'current': {
      'temperature': 24.5,
      'humidity': 84,
      'feels_like': 25.0,
      'wind_speed': 9.0,
      'condition': {'en': 'Partly Cloudy', 'ml': 'ഭാഗികമായി മേഘാവൃതം', 'icon': 'partly_cloudy'},
    },
    'advisory': {
      'title_en': 'Favorable Weather in $userDistrict',
      'title_ml': '$userDistrict ജില്ലയിൽ അനുയോജ്യമായ കാലാവസ്ഥ',
      'message_en': 'Optimal conditions for routine agricultural practices and pest management.',
      'message_ml': '$userDistrict ജില്ലയിലെ കൃഷിയിടങ്ങൾക്ക് അനുയോജ്യമായ കാലാവസ്ഥ.',
      'alert_level': 'NORMAL',
    },
  };

  List<dynamic> recommendations = [
    {
      'id': 'rec-1',
      'category': 'FERTILIZER',
      'title_en': 'Compost & Bio-fertilizer Application',
      'title_ml': 'ജൈവവള പ്രയോഗം',
      'description_en': 'Apply organic compost with Trichoderma in the crop basin.',
      'description_ml': 'ചാണകപ്പൊടിയും ട്രൈക്കോഡെർമയും ചേർത്ത് തടത്തിൽ ഇടുക.',
      'is_completed': false,
    },
    {
      'id': 'rec-2',
      'category': 'PEST_CONTROL',
      'title_en': 'Preventative Spray for Fungal Diseases',
      'title_ml': 'കുമിൾ രോഗങ്ങൾക്കെതിരെയുള്ള മുൻകരുതൽ',
      'description_en': 'Spray 1% Bordeaux mixture on leaves and vine basins during clear weather.',
      'description_ml': 'തെളിഞ്ഞ കാലാവസ്ഥയിൽ 1% ബോർഡോ മിശ്രിതം തളിക്കുക.',
      'is_completed': false,
    },
  ];

  List<dynamic> marketPrices = [
    {
      'commodity_name_en': 'Cardamom (7-8mm)',
      'commodity_name_ml': 'ചെറു ഏലം',
      'market_name': 'Vandanmedu Spices Board (Idukki)',
      'modal_price': 2650.0,
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
      'commodity_name_en': 'Rubber (RSS-4)',
      'commodity_name_ml': 'റബ്ബർ (RSS-4)',
      'market_name': 'Kottayam Rubber Board',
      'modal_price': 192.0,
      'unit': 'Kg',
      'price_change_pct': 0.85,
      'trend': 'UP',
    },
    {
      'commodity_name_en': 'Coconut (Raw)',
      'commodity_name_ml': 'പച്ചത്തേങ്ങ',
      'market_name': 'APMC Market',
      'modal_price': 39.5,
      'unit': 'Kg',
      'price_change_pct': 3.4,
      'trend': 'UP',
    },
  ];

  List<dynamic> crops = farmState.crops.isNotEmpty
      ? farmState.crops
      : [
          {'id': '1', 'crop_name_en': 'Cardamom', 'crop_name_ml': 'ഏലം', 'area_acres': 1.5, 'health_status': 'Healthy', 'growth_stage': 'Yielding'},
          {'id': '2', 'crop_name_en': 'Black Pepper', 'crop_name_ml': 'കുരുമുളക്', 'area_acres': 1.0, 'health_status': 'Healthy', 'growth_stage': 'Flowering'},
        ];

  List<dynamic> diagnoses = [];

  // 1. Fetch live weather for user's district from backend Open-Meteo API
  try {
    final weatherRes = await dio.get(ApiEndpoints.weather, queryParameters: {'district': userDistrict});
    if (weatherRes.data is Map<String, dynamic>) {
      weather = weatherRes.data;
    }
  } catch (_) {}

  // 2. Fetch active recommendations
  try {
    final recRes = await dio.get(ApiEndpoints.aiRecommendations);
    if (recRes.data is List && (recRes.data as List).isNotEmpty) {
      recommendations = recRes.data;
    }
  } catch (_) {}

  // 3. Fetch live market prices
  try {
    final priceRes = await dio.get(ApiEndpoints.marketPrices, queryParameters: {'district': userDistrict});
    if (priceRes.data is List && (priceRes.data as List).isNotEmpty) {
      marketPrices = priceRes.data;
    }
  } catch (_) {}

  // 4. Fetch farmer's cultivated crops from DB
  try {
    final cropsRes = await dio.get(ApiEndpoints.crops);
    if (cropsRes.data is List && (cropsRes.data as List).isNotEmpty) {
      crops = cropsRes.data;
    }
  } catch (_) {}

  // 5. Fetch disease diagnosis history
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
