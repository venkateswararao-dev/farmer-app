import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/localization/app_locale.dart';
import '../../../core/responsive/content_wrapper.dart';
import '../providers/market_prices_provider.dart';

class MarketPricesScreen extends ConsumerStatefulWidget {
  const MarketPricesScreen({super.key});

  @override
  ConsumerState<MarketPricesScreen> createState() => _MarketPricesScreenState();
}

class _MarketPricesScreenState extends ConsumerState<MarketPricesScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    final isMl = ref.watch(localeProvider) == AppLang.ml;
    final activeCategory = ref.watch(marketCategoryFilterProvider);
    final pricesAsync = ref.watch(marketPricesListProvider);

    final categories = [
      {'id': 'All', 'label': s.allCategories},
      {'id': 'Plantation', 'label': s.plantation},
      {'id': 'Spices', 'label': s.spices},
      {'id': 'Grains', 'label': s.grains},
      {'id': 'Fruits', 'label': s.fruits},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(s.mandiRatesTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: () => ref.read(localeProvider.notifier).toggle(),
            child: Text(isMl ? 'EN' : 'മലയാളം', style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SafeArea(
        child: ContentWrapper(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Search Input
              TextField(
                controller: _searchController,
                onChanged: (val) {
                  ref.read(marketSearchQueryProvider.notifier).state = val;
                },
                decoration: InputDecoration(
                  hintText: s.searchCommodity,
                  prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            ref.read(marketSearchQueryProvider.notifier).state = '';
                          },
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 12),

              // Category Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: categories.map((cat) {
                    final isSelected = activeCategory == cat['id'];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        selected: isSelected,
                        label: Text(cat['label']!),
                        selectedColor: AppColors.primaryContainer,
                        checkmarkColor: AppColors.primary,
                        labelStyle: TextStyle(
                          color: isSelected ? AppColors.primary : AppColors.textSecondary,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        onSelected: (_) {
                          ref.read(marketCategoryFilterProvider.notifier).state = cat['id']!;
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),

              // Prices List
              Expanded(
                child: pricesAsync.when(
                  data: (prices) {
                    if (prices.isEmpty) {
                      return Center(
                        child: Text(
                          isMl ? 'വില വിവരങ്ങൾ ലഭ്യമല്ല' : 'No price records found',
                          style: const TextStyle(color: AppColors.textMuted),
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () async => ref.refresh(marketPricesListProvider),
                      child: ListView.separated(
                        itemCount: prices.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, idx) {
                          final item = prices[idx];
                          final name = isMl ? item['commodity_name_ml'] : item['commodity_name_en'];
                          final market = item['market_name'] ?? '';
                          final modal = item['modal_price']?.toString() ?? '0';
                          final min = item['min_price']?.toString() ?? '0';
                          final max = item['max_price']?.toString() ?? '0';
                          final unit = item['unit'] ?? 'Kg';
                          final isUp = item['trend'] == 'UP';
                          final change = item['price_change_pct']?.toString() ?? '0';

                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name ?? '',
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(Icons.storefront_outlined, size: 14, color: AppColors.textMuted),
                                          const SizedBox(width: 4),
                                          Text(
                                            market,
                                            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${s.minMax}: ₹$min - ₹$max',
                                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          '₹$modal',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w800,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        Text(
                                          '/$unit',
                                          style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: (isUp ? AppColors.success : AppColors.error).withOpacity(0.12),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            isUp ? Icons.arrow_upward : Icons.arrow_downward,
                                            size: 12,
                                            color: isUp ? AppColors.success : AppColors.error,
                                          ),
                                          const SizedBox(width: 2),
                                          Text(
                                            '$change%',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: isUp ? AppColors.success : AppColors.error,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                  error: (err, _) => Center(child: Text('Error loading prices: $err')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
