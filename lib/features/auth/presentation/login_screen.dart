import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_locale.dart';
import '../../../core/responsive/content_wrapper.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneController = TextEditingController(text: '9847012345');
  final _nameController = TextEditingController(text: 'സുരേഷ് കുമാർ (Suresh)');

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    if (name.isEmpty || phone.isEmpty) return;

    final success = await ref.read(authProvider.notifier).loginWithPhone(phone, name);
    if (success && mounted) {
      final user = ref.read(authProvider).user;
      final hasProfile = user != null && user['farmer_profile'] != null;
      if (hasProfile) {
        context.go('/home');
      } else {
        context.go('/farm-setup');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMl = ref.watch(localeProvider) == AppLang.ml;
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: SafeArea(
        child: ContentWrapper(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                // Language Switcher in top right
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () => ref.read(localeProvider.notifier).toggle(),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.language, size: 18, color: AppColors.primary),
                          const SizedBox(width: 6),
                          Text(
                            isMl ? 'English' : 'മലയാളം',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Hero Logo & Title
                Center(
                  child: Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.eco,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  isMl ? 'കേരള കർഷക മിത്രം' : 'Kerala Farmer Companion',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isMl
                      ? 'നിങ്ങളുടെ സ്മാർട്ട് കാർഷിക സഹായി — രോഗ നിർണയം, വിപണി വില, AI ഉപദേശങ്ങൾ'
                      : 'Your Smart Agri Companion — Crop Doctor, Live Mandi Rates & AI Advisor',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 40),

                // Login Card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        isMl ? 'കർഷക പ്രവേശനം / രജിസ്ട്രേഷൻ' : 'Farmer Login / Registration',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: isMl ? 'പേര് (Full Name)' : 'Full Name',
                          prefixIcon: const Icon(Icons.person_outline, color: AppColors.primary),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: isMl ? 'മൊബൈൽ നമ്പർ (Mobile Number)' : 'Mobile Number',
                          prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.primary),
                          prefixText: '+91 ',
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: authState.isLoading ? null : _handleLogin,
                        child: authState.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    isMl ? 'തുടങ്ങുക (Get Started)' : 'Get Started',
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.arrow_forward, size: 18),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Features highlights
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildFeaturePill(Icons.camera_alt_outlined, isMl ? 'ഇല സ്കാനർ' : 'Leaf Doctor'),
                    _buildFeaturePill(Icons.mic_none, isMl ? 'വോയ്സ് AI' : 'Voice AI'),
                    _buildFeaturePill(Icons.trending_up, isMl ? 'വിപണി നിരക്ക്' : 'Mandi Rates'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturePill(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
