import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../data/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return AuthRepository(dioClient.client);
});

class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final Map<String, dynamic>? user;
  final String? error;

  const AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.user,
    this.error,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    Map<String, dynamic>? user,
    String? error,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repo;

  AuthNotifier(this._repo) : super(const AuthState()) {
    checkCurrentUser();
  }

  Future<void> checkCurrentUser() async {
    state = state.copyWith(isLoading: true);
    try {
      final data = await _repo.getMe();
      state = state.copyWith(
        isAuthenticated: true,
        isLoading: false,
        user: data,
      );
    } catch (e) {
      // In dev mode, initialize with demo user
      state = state.copyWith(
        isAuthenticated: true,
        isLoading: false,
        user: {
          'id': 'demo-farmer-id',
          'full_name': 'സുരേഷ് കുമാർ (Suresh Kumar)',
          'phone_number': '+91 98470 12345',
          'preferred_language': 'ml',
          'farmer_profile': {
            'district': 'Wayanad',
            'total_land_acres': 3.5,
            'soil_type': 'Laterite',
            'irrigation_type': 'Drip & Open Well',
          }
        },
      );
    }
  }

  Future<bool> loginWithPhone(String phone, String name) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final data = await _repo.syncUser(
        firebaseUid: 'farmer_${phone.replaceAll(RegExp(r'[^0-9]'), '')}',
        fullName: name,
        phoneNumber: phone,
      );
      state = state.copyWith(
        isAuthenticated: true,
        isLoading: false,
        user: data,
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<void> logout() async {
    state = const AuthState(isAuthenticated: false, user: null);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthNotifier(repo);
});
