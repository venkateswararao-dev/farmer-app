import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/kerala_districts.dart';
import '../../../core/localization/app_locale.dart';
import '../../../core/responsive/content_wrapper.dart';
import '../providers/farm_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../dashboard/providers/dashboard_provider.dart';
import '../../weather/providers/weather_provider.dart';

class CropOption {
  final String id;
  final String nameEn;
  final String nameMl;

  const CropOption({required this.id, required this.nameEn, required this.nameMl});
}

const List<CropOption> availableCropsList = [
  CropOption(id: 'Coconut', nameEn: 'Coconut', nameMl: 'തെങ്ങ്'),
  CropOption(id: 'Rubber', nameEn: 'Rubber', nameMl: 'റബ്ബർ'),
  CropOption(id: 'Black Pepper', nameEn: 'Black Pepper', nameMl: 'കുരുമുളക്'),
  CropOption(id: 'Cardamom', nameEn: 'Cardamom', nameMl: 'ഏലം'),
  CropOption(id: 'Banana', nameEn: 'Banana (Nendran)', nameMl: 'നേന്ത്രവാഴ'),
  CropOption(id: 'Paddy', nameEn: 'Paddy / Rice', nameMl: 'നെല്ല്'),
  CropOption(id: 'Arecanut', nameEn: 'Arecanut', nameMl: 'അടക്ക'),
  CropOption(id: 'Nutmeg', nameEn: 'Nutmeg', nameMl: 'ജാതിക്ക'),
  CropOption(id: 'Ginger', nameEn: 'Ginger', nameMl: 'ഇഞ്ചി'),
  CropOption(id: 'Tapioca', nameEn: 'Tapioca', nameMl: 'കപ്പ'),
];

class FormOption {
  final String id;
  final String nameEn;
  final String nameMl;

  const FormOption({required this.id, required this.nameEn, required this.nameMl});
}

const List<FormOption> soilOptionsList = [
  FormOption(id: 'Laterite', nameEn: 'Laterite Soil', nameMl: 'വെട്ടുകൽ മണ്ണ്'),
  FormOption(id: 'Red Loam', nameEn: 'Red Loam Soil', nameMl: 'ചെമ്മണ്ണ്'),
  FormOption(id: 'Coastal Sandy', nameEn: 'Coastal Sandy Soil', nameMl: 'തീരദേശ മണൽമണ്ണ്'),
  FormOption(id: 'Clayey Loam', nameEn: 'Clayey Loam Soil', nameMl: 'കരിമണ്ണ് / എക്കൽമണ്ണ്'),
];

const List<FormOption> irrigationOptionsList = [
  FormOption(id: 'Drip & Open Well', nameEn: 'Drip & Open Well', nameMl: 'തുള്ളി നന & കിണർ'),
  FormOption(id: 'Sprinkler Irrigation', nameEn: 'Sprinkler Irrigation', nameMl: 'സ്പ്രിങ്ക്ളർ'),
  FormOption(id: 'Rainfed', nameEn: 'Rainfed', nameMl: 'മഴാശ്രയം'),
  FormOption(id: 'Borewell & Canal', nameEn: 'Borewell & Canal', nameMl: 'ബോർവെൽ / കനാൽ'),
];

class FarmSetupScreen extends ConsumerStatefulWidget {
  const FarmSetupScreen({super.key});

  @override
  ConsumerState<FarmSetupScreen> createState() => _FarmSetupScreenState();
}

class _FarmSetupScreenState extends ConsumerState<FarmSetupScreen> {
  String _selectedDistrict = 'Idukki';
  final _landSizeController = TextEditingController(text: '2.5');
  String _selectedSoil = 'Laterite';
  String _selectedIrrigation = 'Drip & Open Well';
  final List<String> _selectedCropIds = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadExistingData();
    });
  }

  void _loadExistingData() {
    final farmState = ref.read(farmProfileProvider);
    final user = ref.read(authProvider).user;
    final profile = farmState.profile ?? user?['farmer_profile'];

    if (profile != null) {
      final district = profile['district']?.toString();
      if (district != null && district.isNotEmpty) {
        final matchDistrict = keralaDistrictsList.firstWhere(
          (d) => d.nameEn.toLowerCase() == district.toLowerCase(),
          orElse: () => keralaDistrictsList.first,
        );
        _selectedDistrict = matchDistrict.nameEn;
      }

      if (profile['total_land_acres'] != null) {
        _landSizeController.text = profile['total_land_acres'].toString();
      }

      if (profile['soil_type'] != null) {
        final soil = profile['soil_type'].toString();
        final matchSoil = soilOptionsList.firstWhere(
          (s) => s.id.toLowerCase() == soil.toLowerCase() ||
                 s.nameEn.toLowerCase().contains(soil.toLowerCase()) ||
                 soil.toLowerCase().contains(s.id.toLowerCase()),
          orElse: () => soilOptionsList[0],
        );
        _selectedSoil = matchSoil.id;
      }

      if (profile['irrigation_type'] != null) {
        final irr = profile['irrigation_type'].toString();
        final matchIrr = irrigationOptionsList.firstWhere(
          (i) => i.id.toLowerCase() == irr.toLowerCase() ||
                 i.nameEn.toLowerCase().contains(irr.toLowerCase()) ||
                 irr.toLowerCase().contains(i.id.toLowerCase()),
          orElse: () => irrigationOptionsList[0],
        );
        _selectedIrrigation = matchIrr.id;
      }
    }

    if (farmState.crops.isNotEmpty) {
      _selectedCropIds.clear();
      for (final crop in farmState.crops) {
        final cropName = (crop['crop_name_en'] ?? '').toString();
        final match = availableCropsList.firstWhere(
          (c) => c.id.toLowerCase() == cropName.toLowerCase() ||
                 c.nameEn.toLowerCase().contains(cropName.toLowerCase()),
          orElse: () => const CropOption(id: '', nameEn: '', nameMl: ''),
        );
        if (match.id.isNotEmpty && !_selectedCropIds.contains(match.id)) {
          _selectedCropIds.add(match.id);
        }
      }
    } else if (_selectedCropIds.isEmpty) {
      _selectedCropIds.addAll(['Coconut', 'Black Pepper']);
    }

    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _landSizeController.dispose();
    super.dispose();
  }

  void _saveFarmProfile() async {
    final landSize = double.tryParse(_landSizeController.text.trim()) ?? 2.0;
    final isMl = ref.read(localeProvider) == AppLang.ml;

    final cropsData = _selectedCropIds.map((cropId) {
      final cropOpt = availableCropsList.firstWhere(
        (c) => c.id == cropId,
        orElse: () => CropOption(id: cropId, nameEn: cropId, nameMl: cropId),
      );
      return {
        'crop_name_en': cropOpt.nameEn,
        'crop_name_ml': cropOpt.nameMl,
        'area_acres': 1.0,
        'growth_stage': 'Vegetative',
      };
    }).toList();

    final success = await ref.read(farmProfileProvider.notifier).saveCompleteFarmSetup(
      profileData: {
        'district': _selectedDistrict,
        'total_land_acres': landSize,
        'soil_type': _selectedSoil,
        'irrigation_type': _selectedIrrigation,
      },
      cropsData: cropsData,
    );

    if (success) {
      ref.invalidate(dashboardDataProvider);
      ref.invalidate(weatherDetailsProvider);
      ref.invalidate(selectedWeatherDistrictProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isMl
                  ? 'കൃഷിയിടവും വിളകളും വിജയകരമായി സേവ് ചെയ്തു!'
                  : 'Farm profile and crops saved successfully!',
            ),
            backgroundColor: AppColors.primary,
          ),
        );
        context.go('/home');
      }
    } else {
      if (mounted) {
        final errorMsg = ref.read(farmProfileProvider).error ?? 'Failed to save farm profile. Please try again.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            backgroundColor: AppColors.error,
          ),
        );
      }
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
                // Info Header Card
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
                  value: _selectedDistrict,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.location_on_outlined, color: AppColors.primary),
                  ),
                  items: keralaDistrictsList.map((d) {
                    return DropdownMenuItem(
                      value: d.nameEn,
                      child: Text(
                        isMl ? d.nameMl : d.nameEn,
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
                  value: _selectedSoil,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.grass, color: AppColors.primary),
                  ),
                  items: soilOptionsList.map((s) => DropdownMenuItem(
                    value: s.id,
                    child: Text(isMl ? s.nameMl : s.nameEn, overflow: TextOverflow.ellipsis),
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
                  value: _selectedIrrigation,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.water_drop_outlined, color: AppColors.primary),
                  ),
                  items: irrigationOptionsList.map((i) => DropdownMenuItem(
                    value: i.id,
                    child: Text(isMl ? i.nameMl : i.nameEn, overflow: TextOverflow.ellipsis),
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
                  children: availableCropsList.map((crop) {
                    final isSelected = _selectedCropIds.contains(crop.id);
                    return FilterChip(
                      selected: isSelected,
                      label: Text(isMl ? crop.nameMl : crop.nameEn),
                      selectedColor: AppColors.primaryContainer,
                      checkmarkColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color: isSelected ? AppColors.primary : AppColors.textSecondary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedCropIds.add(crop.id);
                          } else {
                            _selectedCropIds.remove(crop.id);
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
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            ),
                            const SizedBox(width: 10),
                            Text(isMl ? 'സേവ് ചെയ്യുന്നു...' : 'Saving Farm Profile...'),
                          ],
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
