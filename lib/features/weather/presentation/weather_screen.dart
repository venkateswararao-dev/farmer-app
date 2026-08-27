import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/kerala_districts.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/localization/app_locale.dart';
import '../../../core/responsive/content_wrapper.dart';
import '../providers/weather_provider.dart';

class WeatherScreen extends ConsumerWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    final isMl = ref.watch(localeProvider) == AppLang.ml;
    final selectedDistrict = ref.watch(selectedWeatherDistrictProvider);
    final weatherAsync = ref.watch(weatherDetailsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(s.weather, style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: () => ref.read(localeProvider.notifier).toggle(),
            child: Text(isMl ? 'EN' : 'മലയാളം', style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => ref.refresh(weatherDetailsProvider),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ContentWrapper(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // District Dropdown Selector
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedDistrict,
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.primary),
                        items: keralaDistrictsList.map((d) {
                          return DropdownMenuItem(
                            value: d.nameEn,
                            child: Row(
                              children: [
                                const Icon(Icons.location_on, size: 18, color: AppColors.primary),
                                const SizedBox(width: 8),
                                Text('${d.nameEn} (${d.nameMl})', style: const TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            ref.read(selectedWeatherDistrictProvider.notifier).state = val;
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  weatherAsync.when(
                    data: (weather) {
                      final current = weather['current'] ?? {};
                      final temp = current['temperature']?.toString() ?? '28';
                      final condition = isMl
                          ? (current['condition']?['ml'] ?? 'മേഘാവൃതം')
                          : (current['condition']?['en'] ?? 'Cloudy');
                      final humidity = current['humidity']?.toString() ?? '80';
                      final wind = current['wind_speed']?.toString() ?? '10';
                      final advisory = weather['advisory'] ?? {};
                      final forecast = weather['forecast'] as List<dynamic>? ?? [];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Main Weather Card
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.25),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '$temp°C',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 44,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: -1,
                                          ),
                                        ),
                                        Text(
                                          condition,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Icon(Icons.cloud_queue, color: Colors.white, size: 64),
                                  ],
                                ),
                                const Divider(color: Colors.white24, height: 32),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    _buildWeatherMetric(Icons.water_drop_outlined, s.humidity, '$humidity%'),
                                    _buildWeatherMetric(Icons.air, s.wind, '$wind km/h'),
                                    _buildWeatherMetric(
                                      Icons.umbrella_outlined,
                                      s.rainChance,
                                      '${forecast.isNotEmpty ? (forecast[0]['precipitation_probability'] ?? 30) : 30}%',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Agro-Advisory Banner
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.agriculture, color: AppColors.primary, size: 22),
                                    const SizedBox(width: 8),
                                    Text(
                                      isMl
                                          ? (advisory['title_ml'] ?? 'കാർഷിക മുന്നറിയിപ്പ്')
                                          : (advisory['title_en'] ?? 'Agro-Advisory'),
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  isMl ? (advisory['message_ml'] ?? '') : (advisory['message_en'] ?? ''),
                                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.4),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // 7-Day Forecast Section
                          Text(
                            isMl ? '7 ദിവസത്തെ കാലാവസ്ഥ' : '7-Day Agricultural Forecast',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          ...forecast.map((day) {
                            final date = day['date']?.toString() ?? '';
                            final tMax = day['temp_max']?.toString() ?? '28';
                            final tMin = day['temp_min']?.toString() ?? '22';
                            final rainProb = day['precipitation_probability']?.toString() ?? '20';

                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(date, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      children: [
                                        const Icon(Icons.water_drop, size: 14, color: AppColors.info),
                                        const SizedBox(width: 4),
                                        Text('$rainProb%', style: const TextStyle(fontSize: 12, color: AppColors.info)),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '$tMax° / $tMin°C',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                ],
                              ),
                            );
                          }),
                          const SizedBox(height: 24),
                        ],
                      );
                    },
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: CircularProgressIndicator(color: AppColors.primary),
                      ),
                    ),
                    error: (err, _) => Center(child: Text('Error loading weather: $err')),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherMetric(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 22),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 11)),
      ],
    );
  }
}
