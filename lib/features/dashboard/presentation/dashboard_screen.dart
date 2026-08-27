import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_locale.dart';
import '../../../core/responsive/content_wrapper.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/dashboard_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMl = ref.watch(localeProvider) == AppLang.ml;
    final user = ref.watch(authProvider).user;
    final dashboardAsync = ref.watch(dashboardDataProvider);

    final farmerName = user?['full_name'] ?? (isMl ? 'കർഷക മിത്രം' : 'Farmer');

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => ref.refresh(dashboardDataProvider),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ContentWrapper(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Top Header with Farmer Greeting & Language Toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => context.push('/profile'),
                          borderRadius: BorderRadius.circular(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isMl ? 'നമസ്കാരം,' : 'Namaskaram,',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                farmerName,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () => ref.read(localeProvider.notifier).toggle(),
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.primaryContainer,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.language, size: 16, color: AppColors.primary),
                                  const SizedBox(width: 4),
                                  Text(
                                    isMl ? 'EN' : 'മലയാളം',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () => context.go('/profile'),
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.person, size: 18, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  dashboardAsync.when(
                    data: (data) => Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // 2. Weather & Agro-Advisory Hero Card
                        _buildWeatherHeroCard(context, data.weather, isMl),
                        const SizedBox(height: 20),

                        // 3. Quick Action Buttons (Leaf Doctor, Voice AI, Mandi Rates)
                        _buildQuickActions(context, isMl),
                        const SizedBox(height: 24),

                        // 4. Personalized AI Daily Recommendations
                        _buildDailyRecommendations(data.recommendations, isMl),
                        const SizedBox(height: 24),

                        // 5. Live Market Rates Ticker
                        _buildMarketRatesSection(context, data.marketPrices, isMl),
                        const SizedBox(height: 24),

                        // 6. My Crops Portfolio
                        _buildMyCropsSection(context, data.crops, isMl),
                        const SizedBox(height: 24),
                      ],
                    ),
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: CircularProgressIndicator(color: AppColors.primary),
                      ),
                    ),
                    error: (err, _) => Center(
                      child: Text('Error loading dashboard: $err'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherHeroCard(BuildContext context, Map<String, dynamic> weather, bool isMl) {
    final current = weather['current'] ?? {};
    final temp = current['temperature']?.toString() ?? '28';
    final condition = isMl
        ? (current['condition']?['ml'] ?? 'മേഘാവൃതം')
        : (current['condition']?['en'] ?? 'Cloudy');
    final advisory = weather['advisory'] ?? {};
    final advisoryTitle = isMl ? advisory['title_ml'] : advisory['title_en'];
    final advisoryMsg = isMl ? advisory['message_ml'] : advisory['message_en'];

    return InkWell(
      onTap: () => context.go('/weather'),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.25),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.white70, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      isMl ? weather['district_ml'] ?? 'വയനാട്' : weather['district'] ?? 'Wayanad',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Text(
                  '$temp°C • $condition',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(color: Colors.white24, height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.lightbulb_outline, color: AppColors.accentAmber, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        advisoryTitle ?? (isMl ? 'ഇന്നത്തെ കാർഷിക ഉപദേശം' : 'Today\'s Farming Advisory'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        advisoryMsg ?? (isMl ? 'വളപ്രയോഗത്തിനും ജലസേചനത്തിനും അനുകൂലമായ കാലാവസ്ഥ.' : 'Favorable weather for routine crop care.'),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 12,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, bool isMl) {
    return Row(
      children: [
        Expanded(
          child: _buildActionTile(
            context,
            icon: Icons.camera_alt,
            title: isMl ? 'ഇല ഡോക്ടർ' : 'Crop Doctor',
            subtitle: isMl ? 'രോഗ നിർണയം' : 'Scan Leaf',
            color: const Color(0xFF2E7D32),
            onTap: () => context.go('/disease-detection'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionTile(
            context,
            icon: Icons.mic,
            title: isMl ? 'കൃഷി മിത്ര' : 'Krishi AI',
            subtitle: isMl ? 'സംസാരിക്കൂ' : 'Voice Chat',
            color: AppColors.accentOrange,
            onTap: () => context.go('/ai-assistant'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionTile(
            context,
            icon: Icons.currency_rupee,
            title: isMl ? 'വിപണി വില' : 'Mandi Rates',
            subtitle: isMl ? 'തത്സമയം' : 'Live Prices',
            color: const Color(0xFF0288D1),
            onTap: () => context.go('/market-prices'),
          ),
        ),
      ],
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              subtitle,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyRecommendations(List<dynamic> list, bool isMl) {
    if (list.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isMl ? 'ഇന്നത്തെ കാർഷിക നിർദ്ദേശങ്ങൾ' : 'Personalized Farm Advisory',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Icon(Icons.auto_awesome, color: AppColors.primaryLight, size: 20),
          ],
        ),
        const SizedBox(height: 12),
        ...list.map((rec) {
          final title = isMl ? rec['title_ml'] : rec['title_en'];
          final desc = isMl ? rec['description_ml'] : rec['description_en'];
          final category = rec['category'] ?? 'FERTILIZER';

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    category == 'PEST_CONTROL' ? Icons.bug_report : Icons.spa,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        desc ?? '',
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, height: 1.3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildMarketRatesSection(BuildContext context, List<dynamic> prices, bool isMl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isMl ? 'കേരള വിപണി നിരക്കുകൾ' : 'Kerala Mandi Prices',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () => context.go('/market-prices'),
              child: Text(isMl ? 'കൂടുതൽ' : 'View All'),
            ),
          ],
        ),
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: prices.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, idx) {
              final p = prices[idx];
              final name = isMl ? p['commodity_name_ml'] : p['commodity_name_en'];
              final price = p['modal_price']?.toString() ?? '0';
              final unit = p['unit'] ?? 'Kg';
              final isUp = p['trend'] == 'UP';

              return Container(
                width: 160,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          '₹$price',
                          style: const TextStyle(
                            fontSize: 18,
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
                    Row(
                      children: [
                        Icon(
                          isUp ? Icons.trending_up : Icons.trending_down,
                          size: 14,
                          color: isUp ? AppColors.success : AppColors.error,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${p['price_change_pct'] ?? 1.2}%',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isUp ? AppColors.success : AppColors.error,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMyCropsSection(BuildContext context, List<dynamic> crops, bool isMl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isMl ? 'എന്റെ കൃഷികൾ' : 'My Cultivated Crops',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
              onPressed: () => context.push('/farm-setup'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: crops.take(3).map((crop) {
            final name = isMl ? crop['crop_name_ml'] : crop['crop_name_en'];
            final acres = crop['area_acres']?.toString() ?? '1.0';

            return Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.eco, color: AppColors.primaryLight, size: 20),
                    const SizedBox(height: 6),
                    Text(
                      name ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '$acres ${isMl ? 'ഏക്കർ' : 'Acres'}',
                      style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
