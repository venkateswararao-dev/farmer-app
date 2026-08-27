import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/kerala_districts.dart';
import '../../../core/localization/app_locale.dart';
import '../../../core/responsive/content_wrapper.dart';
import '../providers/farm_provider.dart';

class FarmSetupScreen extends ConsumerStatefulWidget {
  const FarmSetupScreen({super.key});

  @override
  ConsumerState<FarmSetupScreen> createState() => _FarmSetupScreenState();
}

class _FarmSetupScreenState extends ConsumerState<FarmSetupScreen> {
  String _selectedDistrict = 'Wayanad';
  final _landSizeController = TextEditingController(text: '3.5');
  String _selectedSoil = 'Laterite (വെട്ടുകൽ മണ്ണ്)';
  String _selectedIrrigation = 'Drip & Open Well (തുള്ളി നന & കിണർ)';
  final List<String> _selectedCrops = ['Coconut (തെങ്ങ്)', 'Black Pepper (കുരുമുളക്)', 'Rubber (റബ്ബർ)'];

  final List<String> _availableCrops = [
    'Coconut (തെങ്ങ്)',
    'Rubber (റബ്ബർ)',
    'Black Pepper (കുരുമുളക്)',
    'Cardamom (ഏലം)',
    'Banana / Nendran (നേന്ത്രവാഴ)',
    'Paddy / Rice (നെല്ല്)',
    'Arecanut (അടക്ക)',
    'Nutmeg (ജാതിക്ക)',
    'Ginger (ഇഞ്ചി)',
    'Tapioca (കപ്പ)',
  ];

  @override
  void dispose() {
    _landSizeController.dispose();
    super.dispose();
  }

  void _saveFarmProfile() async {
    final landSize = double.tryParse(_landSizeController.text.trim()) ?? 2.0;

    final success = await ref.read(farmProfileProvider.notifier).saveProfile({
      'district': _selectedDistrict,
      'total_land_acres': landSize,
      'soil_type': _selectedSoil,
      'irrigation_type': _selectedIrrigation,
    });

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Farm profile saved successfully!'),
          backgroundColor: AppColors.primary,
        ),
      );
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMl = ref.watch(localeProvider) == AppLang.ml;
    final farmState = ref.watch(farmProfileProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.canPop() ? context.pop() : context.go('/home'),
        ),
        title: Text(isMl ? 'കൃഷിയിട വിവരങ്ങൾ' : 'Farm Profile Setup'),
        actions: [
          TextButton.icon(
            onPressed: () => ref.read(localeProvider.notifier).toggle(),
            icon: const Icon(Icons.language, size: 18),
            label: Text(isMl ? 'EN' : 'മലയാളം'),
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
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.landscape, color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isMl ? 'നിങ്ങളുടെ കൃഷിയിടം സജ്ജീകരിക്കുക' : 'Setup Your Farm Details',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isMl
                                  ? 'കൃത്യമായ AI ഉപദേശങ്ങൾക്കും വിപണി വിലകൾക്കും ഇത് സഹായിക്കുന്നു'
                                  : 'Enables tailored AI advice & accurate mandi rates',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // District Dropdown
                Text(
                  isMl ? '1. ജില്ല തിരഞ്ഞെടുക്കുക' : '1. Select Kerala District',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: _selectedDistrict,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.location_on_outlined, color: AppColors.primary),
                  ),
                  items: keralaDistrictsList.map((d) {
                    return DropdownMenuItem(
                      value: d.nameEn,
                      child: Text(
                        '${d.nameEn} (${d.nameMl})',
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedDistrict = val);
                  },
                ),
                const SizedBox(height: 20),

                // Total Land Size
                Text(
                  isMl ? '2. കൃഷിസ്ഥലത്തിന്റെ വിസ്തീർണ്ണം (ഏക്കറിൽ)' : '2. Total Land Size (Acres)',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _landSizeController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.straighten, color: AppColors.primary),
                    suffixText: 'Acres',
                  ),
                ),
                const SizedBox(height: 20),

                // Soil Type
                Text(
                  isMl ? '3. മണ്ണിന്റെ ഇനം' : '3. Soil Type',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: _selectedSoil,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.grass, color: AppColors.primary),
                  ),
                  items: [
                    'Laterite (വെട്ടുകൽ മണ്ണ്)',
                    'Red Loam (ചെമ്മണ്ണ്)',
                    'Coastal Sandy (തീരദേശ മണൽമണ്ണ്)',
                    'Clayey Loam (കരിമണ്ണ് / എക്കൽമണ്ണ്)',
                  ].map((s) => DropdownMenuItem(
                    value: s,
                    child: Text(s, overflow: TextOverflow.ellipsis),
                  )).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedSoil = val);
                  },
                ),
                const SizedBox(height: 20),

                // Irrigation
                Text(
                  isMl ? '4. ജലസേചന രീതി' : '4. Irrigation Method',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: _selectedIrrigation,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.water_drop_outlined, color: AppColors.primary),
                  ),
                  items: [
                    'Drip & Open Well (തുള്ളി നന & കിണർ)',
                    'Sprinkler Irrigation (സ്പ്രിങ്ക്ളർ)',
                    'Rainfed (മഴാശ്രയം)',
                    'Borewell & Canal (ബോർവെൽ / കനാൽ)',
                  ].map((s) => DropdownMenuItem(
                    value: s,
                    child: Text(s, overflow: TextOverflow.ellipsis),
                  )).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedIrrigation = val);
                  },
                ),
                const SizedBox(height: 20),

                // Cultivated Crops Multi-Select
                Text(
                  isMl ? '5. പ്രധാന വിളകൾ' : '5. Cultivated Crops',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _availableCrops.map((crop) {
                    final isSelected = _selectedCrops.contains(crop);
                    return FilterChip(
                      selected: isSelected,
                      label: Text(crop),
                      selectedColor: AppColors.primaryContainer,
                      checkmarkColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color: isSelected ? AppColors.primary : AppColors.textSecondary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedCrops.add(crop);
                          } else {
                            _selectedCrops.remove(crop);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 32),

                // Save Button
                ElevatedButton(
                  onPressed: farmState.isLoading ? null : _saveFarmProfile,
                  child: farmState.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : Text(isMl ? 'കൃഷിയിടം സേവ് ചെയ്യുക' : 'Save Farm Profile'),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
