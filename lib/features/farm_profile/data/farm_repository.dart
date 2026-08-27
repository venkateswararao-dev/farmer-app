import 'package:dio/dio.dart';
import '../../../core/constants/api_endpoints.dart';

class FarmRepository {
  final Dio dio;

  FarmRepository(this.dio);

  Future<Map<String, dynamic>> getProfile() async {
    final response = await dio.get(ApiEndpoints.farmProfile);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> upsertProfile(Map<String, dynamic> data) async {
    final response = await dio.post(ApiEndpoints.farmProfile, data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<List<dynamic>> getCropsCatalog() async {
    final response = await dio.get(ApiEndpoints.cropsCatalog);
    return response.data as List<dynamic>;
  }

  Future<List<dynamic>> getFarmerCrops() async {
    final response = await dio.get(ApiEndpoints.crops);
    return response.data as List<dynamic>;
  }

  Future<Map<String, dynamic>> addCrop(Map<String, dynamic> cropData) async {
    final response = await dio.post(ApiEndpoints.crops, data: cropData);
    return response.data as Map<String, dynamic>;
  }
}
