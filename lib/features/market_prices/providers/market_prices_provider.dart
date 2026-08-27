import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/constants/api_endpoints.dart';

final marketCategoryFilterProvider = StateProvider<String>((ref) => 'All');
final marketSearchQueryProvider = StateProvider<String>((ref) => '');

final marketPricesListProvider = FutureProvider<List<dynamic>>((ref) async {
  final dio = ref.watch(dioClientProvider).client;
  final category = ref.watch(marketCategoryFilterProvider);
  final search = ref.watch(marketSearchQueryProvider);

  try {
    final queryParams = <String, dynamic>{};
    if (category != 'All') queryParams['category'] = category;
    if (search.isNotEmpty) queryParams['search'] = search;

    final response = await dio.get(ApiEndpoints.marketPrices, queryParameters: queryParams);
    return response.data as List<dynamic>;
  } catch (e) {
    // Fallback list
    return [
      {
        'commodity_name_en': 'Rubber (RSS-4)',
        'commodity_name_ml': 'റബ്ബർ (RSS-4)',
        'category': 'Plantation',
        'market_name': 'Kottayam Rubber Board',
        'district': 'Kottayam',
        'modal_price': 192.0,
        'min_price': 188.0,
        'max_price': 194.5,
        'unit': 'Kg',
        'price_change_pct': 1.85,
        'trend': 'UP',
      },
      {
        'commodity_name_en': 'Black Pepper (Garbled)',
        'commodity_name_ml': 'കുരുമുളക് (ഗാർബിൾഡ്)',
        'category': 'Spices',
        'market_name': 'Kochi Spices Market',
        'district': 'Ernakulam',
        'modal_price': 672.0,
        'min_price': 660.0,
        'max_price': 685.0,
        'unit': 'Kg',
        'price_change_pct': 2.15,
        'trend': 'UP',
      },
      {
        'commodity_name_en': 'Cardamom (Small 7-8mm)',
        'commodity_name_ml': 'ചെറു ഏലം',
        'category': 'Spices',
        'market_name': 'Vandanmedu Spices Board',
        'district': 'Idukki',
        'modal_price': 2650.0,
        'min_price': 2450.0,
        'max_price': 2820.0,
        'unit': 'Kg',
        'price_change_pct': -0.95,
        'trend': 'DOWN',
      },
      {
        'commodity_name_en': 'Coconut (Raw)',
        'commodity_name_ml': 'പച്ചത്തേങ്ങ',
        'category': 'Plantation',
        'market_name': 'Kozhikode APMC',
        'district': 'Kozhikode',
        'modal_price': 39.5,
        'min_price': 36.0,
        'max_price': 42.0,
        'unit': 'Kg',
        'price_change_pct': 3.4,
        'trend': 'UP',
      },
      {
        'commodity_name_en': 'Copra (Milling)',
        'commodity_name_ml': 'കൊപ്ര (മില്ലിംഗ്)',
        'category': 'Plantation',
        'market_name': 'Kochi Coconut Market',
        'district': 'Ernakulam',
        'modal_price': 115.0,
        'min_price': 112.0,
        'max_price': 118.5,
        'unit': 'Kg',
        'price_change_pct': 0.0,
        'trend': 'STABLE',
      },
      {
        'commodity_name_en': 'Banana (Nendran)',
        'commodity_name_ml': 'നേന്ത്രക്കായ (വയനാടൻ)',
        'category': 'Fruits',
        'market_name': 'Thrissur Wholesale',
        'district': 'Thrissur',
        'modal_price': 48.0,
        'min_price': 44.0,
        'max_price': 52.0,
        'unit': 'Kg',
        'price_change_pct': 2.2,
        'trend': 'UP',
      },
      {
        'commodity_name_en': 'Arecanut (Dried / Kottepak)',
        'commodity_name_ml': 'അടക്ക (കൊട്ടടക്ക)',
        'category': 'Plantation',
        'market_name': 'Kasaragod APMC',
        'district': 'Kasaragod',
        'modal_price': 415.0,
        'min_price': 390.0,
        'max_price': 440.0,
        'unit': 'Kg',
        'price_change_pct': -1.2,
        'trend': 'DOWN',
      },
      {
        'commodity_name_en': 'Fresh Ginger',
        'commodity_name_ml': 'പച്ച ഇഞ്ചി',
        'category': 'Spices',
        'market_name': 'Wayanad Agri Mandi',
        'district': 'Wayanad',
        'modal_price': 98.0,
        'min_price': 85.0,
        'max_price': 110.0,
        'unit': 'Kg',
        'price_change_pct': 4.5,
        'trend': 'UP',
      },
      {
        'commodity_name_en': 'Paddy / Raw Rice (Uma)',
        'commodity_name_ml': 'നെല്ല് (ഉമ)',
        'category': 'Grains',
        'market_name': 'Palakkad SupplyCo Market',
        'district': 'Palakkad',
        'modal_price': 29.2,
        'min_price': 28.2,
        'max_price': 30.5,
        'unit': 'Kg',
        'price_change_pct': 0.5,
        'trend': 'STABLE',
      },
    ];
  }
});
