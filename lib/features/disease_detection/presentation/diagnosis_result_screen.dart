import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/localization/app_locale.dart';
import '../../../core/responsive/content_wrapper.dart';
import '../providers/disease_provider.dart';

class DiagnosisResultScreen extends ConsumerWidget {
  final DiseaseDiagnosisResult result;

  const DiagnosisResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    final isMl = ref.watch(localeProvider) == AppLang.ml;

    final diseaseName = isMl ? result.diseaseNameMl : result.diseaseNameEn;
    final symptoms = isMl ? result.symptomsMl : result.symptomsEn;
    final organic = isMl ? result.organicRemedyMl : result.organicRemedyEn;
    final chemical = isMl ? result.chemicalRemedyMl : result.chemicalRemedyEn;
    final prevention = isMl ? result.preventionTipsMl : result.preventionTipsEn;

    return Scaffold(
      appBar: AppBar(
        title: Text(s.diagnosisResult, style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(diseaseDetectionProvider.notifier).reset(),
          ),
          TextButton(
            onPressed: () => ref.read(localeProvider.notifier).toggle(),
            child: Text(isMl ? 'EN' : 'മലയാളം', style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SafeArea(
        child: ContentWrapper(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Result Banner
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              result.detectedCrop,
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getSeverityColor(result.severity).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${result.confidence.toStringAsFixed(0)}% Match • ${result.severity}',
                              style: TextStyle(
                                color: _getSeverityColor(result.severity),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        diseaseName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (isMl && result.diseaseNameEn.isNotEmpty)
                        Text(
                          result.diseaseNameEn,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textMuted,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Symptoms Card
                if (symptoms.isNotEmpty)
                  _buildSectionCard(
                    icon: Icons.visibility_outlined,
                    iconColor: AppColors.info,
                    title: isMl ? 'കണ്ടെത്തിയ രോഗ ലക്ഷണങ്ങൾ' : 'Observed Symptoms',
                    content: symptoms,
                  ),
                const SizedBox(height: 12),

                // Organic Remedy Card (Green / Eco-friendly)
                if (organic.isNotEmpty)
                  _buildSectionCard(
                    icon: Icons.eco,
                    iconColor: AppColors.primaryLight,
                    title: isMl ? 'ജൈവ നിയന്ത്രണ മാർഗ്ഗങ്ങൾ (Organic)' : 'Organic & Bio-Control Remedies',
                    content: organic,
                    highlightColor: AppColors.primaryContainer,
                  ),
                const SizedBox(height: 12),

                // Chemical Remedy Card
                if (chemical.isNotEmpty)
                  _buildSectionCard(
                    icon: Icons.sanitizer_outlined,
                    iconColor: AppColors.accentOrange,
                    title: isMl ? 'കീടനാശിനി / കുമിൾനാശിനി പ്രയോഗം' : 'Chemical / Fungicide Remedy',
                    content: chemical,
                  ),
                const SizedBox(height: 12),

                // Prevention Tips Card
                if (prevention.isNotEmpty)
                  _buildSectionCard(
                    icon: Icons.shield_outlined,
                    iconColor: AppColors.success,
                    title: isMl ? 'പ്രതിരോധ മാർഗ്ഗങ്ങൾ & തോട്ടം സംരക്ഷണം' : 'Prevention & Soil Care Tips',
                    content: prevention,
                  ),
                const SizedBox(height: 24),

                // Scan Again Button
                ElevatedButton.icon(
                  onPressed: () => ref.read(diseaseDetectionProvider.notifier).reset(),
                  icon: const Icon(Icons.camera_alt_outlined),
                  label: Text(isMl ? 'മറ്റൊരു ഇല സ്കാൻ ചെയ്യുക' : 'Scan Another Leaf'),
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String content,
    Color? highlightColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: highlightColor ?? AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          Text(
            content,
            style: const TextStyle(fontSize: 14, height: 1.4, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toUpperCase()) {
      case 'CRITICAL':
      case 'HIGH':
        return AppColors.error;
      case 'MEDIUM':
        return AppColors.accentOrange;
      default:
        return AppColors.success;
    }
  }
}
