import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../data/farm_repository.dart';

final farmRepositoryProvider = Provider<FarmRepository>((ref) {
  final dio = ref.watch(dioClientProvider).client;
  return FarmRepository(dio);
});

class FarmProfileState {
  final bool isLoading;
  final Map<String, dynamic>? profile;
  final List<dynamic> crops;
  final List<dynamic> catalog;
  final String? error;

  const FarmProfileState({
    this.isLoading = false,
    this.profile,
    this.crops = const [],
    this.catalog = const [],
    this.error,
  });

  FarmProfileState copyWith({
    bool? isLoading,
    Map<String, dynamic>? profile,
    List<dynamic>? crops,
    List<dynamic>? catalog,
    String? error,
  }) {
    return FarmProfileState(
      isLoading: isLoading ?? this.isLoading,
      profile: profile ?? this.profile,
      crops: crops ?? this.crops,
      catalog: catalog ?? this.catalog,
      error: error,
    );
  }
}

class FarmProfileNotifier extends StateNotifier<FarmProfileState> {
  final FarmRepository _repo;

  FarmProfileNotifier(this._repo) : super(const FarmProfileState()) {
    loadFarmData();
  }

  Future<void> loadFarmData() async {
    state = state.copyWith(isLoading: true);
    try {
      final catalog = await _repo.getCropsCatalog();
      final profile = await _repo.getProfile();
      final crops = await _repo.getFarmerCrops();

      state = state.copyWith(
        isLoading: false,
        profile: profile,
        crops: crops,
        catalog: catalog,
      );
    } catch (e) {
      // Fallback demo data
      state = state.copyWith(
        isLoading: false,
        profile: {
          'district': 'Wayanad',
          'total_land_acres': 3.5,
          'soil_type': 'Laterite (വെട്ടുകൽ മണ്ണ്)',
          'irrigation_type': 'Drip & Open Well',
        },
        crops: [
          {'id': '1', 'crop_name_en': 'Coconut', 'crop_name_ml': 'തെങ്ങ്', 'area_acres': 1.5, 'health_status': 'Healthy'},
          {'id': '2', 'crop_name_en': 'Black Pepper', 'crop_name_ml': 'കുരുമുളക്', 'area_acres': 1.0, 'health_status': 'Healthy'},
          {'id': '3', 'crop_name_en': 'Rubber', 'crop_name_ml': 'റബ്ബർ', 'area_acres': 1.0, 'health_status': 'Good'},
        ],
      );
    }
  }

  Future<bool> saveProfile(Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true);
    try {
      final updated = await _repo.upsertProfile(data);
      state = state.copyWith(isLoading: false, profile: updated);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> addCrop(Map<String, dynamic> cropData) async {
    try {
      final newCrop = await _repo.addCrop(cropData);
      state = state.copyWith(crops: [...state.crops, newCrop]);
      return true;
    } catch (e) {
      return false;
    }
  }
}

final farmProfileProvider = StateNotifierProvider<FarmProfileNotifier, FarmProfileState>((ref) {
  final repo = ref.watch(farmRepositoryProvider);
  return FarmProfileNotifier(repo);
});
