import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/localization/app_locale.dart';
import '../../../core/responsive/content_wrapper.dart';
import '../providers/disease_provider.dart';
import 'diagnosis_result_screen.dart';

class LeafScannerScreen extends ConsumerWidget {
  const LeafScannerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    final isMl = ref.watch(localeProvider) == AppLang.ml;
    final diseaseState = ref.watch(diseaseDetectionProvider);

    // If result exists, show diagnosis screen
    if (diseaseState.result != null) {
      return DiagnosisResultScreen(result: diseaseState.result!);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(s.scanLeafTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
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
                // Header Banner
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.center_focus_strong, color: Colors.white, size: 48),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        isMl ? 'സസ്യ രോഗ നിർണയം' : 'AI Plant Pathology Scanner',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isMl
                            ? 'രോഗബാധയുള്ള ഇലയുടെയോ തണ്ടിന്റെയോ ഫോട്ടോ എടുക്കൂ; ഉടനടി ജൈവ-കീടനാശിനി പരിഹാരങ്ങൾ ലഭിക്കും.'
                            : 'Snap a clear photo of the affected leaf or stem for instant organic & chemical remedies.',
                        style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13, height: 1.4),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Error banner if any
                if (diseaseState.error != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.error.withOpacity(0.4)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.error_outline, color: AppColors.error),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                diseaseState.error!,
                                style: const TextStyle(color: AppColors.error, fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => ref.read(diseaseDetectionProvider.notifier).reset(),
                            child: Text(isMl ? 'വീണ്ടും ശ്രമിക്കുക' : 'Retry'),
                          ),
                        ),
                      ],
                    ),
                  ),

                if (diseaseState.isScanning)
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        if (diseaseState.selectedImageFile != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: SizedBox(
                              height: 180,
                              width: double.infinity,
                              child: Image.file(
                                diseaseState.selectedImageFile!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        const SizedBox(height: 20),
                        const CircularProgressIndicator(color: AppColors.primary),
                        const SizedBox(height: 16),
                        Text(
                          s.analyzingImage,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          isMl
                              ? 'ലക്ഷണങ്ങളും രോഗകാരികളും പരിശോധിക്കുന്നു...'
                              : 'AI is analyzing pathological symptoms and treatment guidelines...',
                          style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                else ...[
                  // Action Buttons
                  ElevatedButton.icon(
                    onPressed: () => ref.read(diseaseDetectionProvider.notifier).pickAndScanImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: Text(s.takePhoto, style: const TextStyle(fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                  const SizedBox(height: 14),
                  OutlinedButton.icon(
                    onPressed: () => ref.read(diseaseDetectionProvider.notifier).pickAndScanImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library_outlined, color: AppColors.primary),
                    label: Text(s.pickFromGallery, style: const TextStyle(fontSize: 16, color: AppColors.primary)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Tips Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.tips_and_updates_outlined, color: AppColors.accentOrange, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              isMl ? 'നല്ല ഫലം ലഭിക്കാൻ ശ്രദ്ധിക്കേണ്ടവ:' : 'Photography Tips:',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _buildTip(isMl ? '• ആവശ്യത്തിന് വെളിച്ചത്തിൽ ഇലയുടെ മധ്യഭാഗം ഫോക്കസ് ചെയ്യുക.' : '• Ensure good lighting and focus on the affected leaf area.'),
                        _buildTip(isMl ? '• രോഗലക്ഷണങ്ങൾ വ്യക്തമായി കാണുന്ന വിധത്തിൽ ക്ലോസ്-അപ്പ് എടുക്കുക.' : '• Take a clear close-up showing discoloration or spots.'),
                        _buildTip(isMl ? '• ക്യാമറ കുലുങ്ങാതെ നോക്കുക.' : '• Avoid blurry or out-of-focus images.'),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTip(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text, style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.3)),
    );
  }
}
