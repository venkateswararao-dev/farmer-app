import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/localization/app_locale.dart';
import '../../../core/responsive/content_wrapper.dart';
import '../../auth/providers/auth_provider.dart';
import '../../farm_profile/providers/farm_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    final isMl = ref.watch(localeProvider) == AppLang.ml;
    final user = ref.watch(authProvider).user;
    final farmState = ref.watch(farmProfileProvider);

    final name = user?['full_name'] ?? (isMl ? 'സുരേഷ് കുമാർ' : 'Suresh Kumar');
    final phone = user?['phone_number'] ?? '+91 98470 12345';
    final district = farmState.profile?['district'] ?? 'Wayanad';
    final landSize = farmState.profile?['total_land_acres']?.toString() ?? '3.5';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.canPop() ? context.pop() : context.go('/home'),
        ),
        title: Text(s.profile, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: ContentWrapper(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Profile Avatar & Name Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person, color: Colors.white, size: 36),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              phone,
                              style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.location_on, size: 14, color: AppColors.primary),
                                const SizedBox(width: 4),
                                Text(
                                  '$district, Kerala',
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Farm Summary Card
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              isMl ? 'കൃഷിയിട വിവരങ്ങൾ' : 'Farm Details',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          TextButton(
                            onPressed: () => context.push('/farm-setup'),
                            child: Text(isMl ? 'മാറ്റങ്ങൾ വരുത്തുക' : 'Edit'),
                          ),
                        ],
                      ),
                      const Divider(height: 12),
                      _buildInfoRow(isMl ? 'ജില്ല' : 'District', farmState.profile?['district'] ?? 'Idukki'),
                      _buildInfoRow(isMl ? 'വിസ്തീർണ്ണം' : 'Total Land', '$landSize ${isMl ? 'ഏക്കർ' : 'Acres'}'),
                      _buildInfoRow(isMl ? 'മണ്ണ്' : 'Soil Type', farmState.profile?['soil_type'] ?? (isMl ? 'വെട്ടുകൽ മണ്ണ്' : 'Laterite Soil')),
                      _buildInfoRow(isMl ? 'ജലസേചനം' : 'Irrigation', farmState.profile?['irrigation_type'] ?? (isMl ? 'തുള്ളി നന' : 'Drip & Open Well')),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Language Switcher Tile
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.language, color: AppColors.primary),
                    title: Text(isMl ? 'ആപ്പ് ഭാഷ (Language)' : 'App Language', style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(isMl ? 'മലയാളം' : 'English'),
                    trailing: Switch(
                      value: isMl,
                      activeThumbColor: AppColors.primary,
                      onChanged: (_) => ref.read(localeProvider.notifier).toggle(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Agriculture Helpline Card (Govt of Kerala)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.phone_in_talk, color: AppColors.primary, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            isMl ? 'കാർഷിക ഹെൽപ്പ് ലൈൻ നമ്പറുകൾ' : 'Kerala Agriculture Helplines',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildHelplineRow(
                        isMl ? 'കിസാൻ കോൾ സെന്റർ (ടോൾ ഫ്രീ):' : 'Kisan Call Centre (Toll-Free):',
                        '1800-180-1551',
                      ),
                      const SizedBox(height: 6),
                      _buildHelplineRow(
                        isMl ? 'കേരള കാർഷിക സർവകലാശാല (KAU):' : 'Kerala Agri University (KAU):',
                        '0487-2438011',
                      ),
                      const SizedBox(height: 6),
                      _buildHelplineRow(
                        isMl ? 'സ്പൈസസ് ബോർഡ് കൊച്ചി:' : 'Spices Board Kochi:',
                        '0484-2333610',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Logout Button
                InkWell(
                  onTap: () => _showLogoutDialog(context, ref, isMl),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.logout, color: AppColors.error, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          isMl ? 'ലോഗ് ഔട്ട് ചെയ്യുക' : 'Log Out',
                          style: const TextStyle(
                            color: AppColors.error,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref, bool isMl) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isMl ? 'ലോഗ് ഔട്ട്' : 'Log Out'),
        content: Text(
          isMl
              ? 'നിങ്ങൾ തീർച്ചയായും ലോഗ് ഔട്ട് ചെയ്യാൻ ആഗ്രഹിക്കുന്നുണ്ടോ?'
              : 'Are you sure you want to log out of your account?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(isMl ? 'റദ്ദാക്കുക' : 'Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) {
                context.go('/login');
              }
            },
            child: Text(isMl ? 'ലോഗ് ഔട്ട്' : 'Log Out'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelplineRow(String label, String phone) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textPrimary))),
        Text(phone, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
      ],
    );
  }
}
