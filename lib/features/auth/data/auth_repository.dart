import 'package:dio/dio.dart';
import '../../../core/constants/api_endpoints.dart';

class AuthRepository {
  final Dio dio;

  AuthRepository(this.dio);

  Future<Map<String, dynamic>> syncUser({
    required String firebaseUid,
    required String fullName,
    String? email,
    String? phoneNumber,
    String? preferredLanguage,
  }) async {
    final response = await dio.post(
      ApiEndpoints.authSync,
      data: {
        'firebase_uid': firebaseUid,
        'full_name': fullName,
        'email': email,
        'phone_number': phoneNumber,
        'preferred_language': preferredLanguage ?? 'ml',
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getMe() async {
    final response = await dio.get(ApiEndpoints.authMe);
    return response.data as Map<String, dynamic>;
  }

  Future<void> updateLanguage(String lang) async {
    await dio.patch(
      ApiEndpoints.authLanguage,
      data: {'language': lang},
    );
  }
}
