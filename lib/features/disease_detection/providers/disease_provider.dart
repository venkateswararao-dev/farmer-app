import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/constants/api_endpoints.dart';

String _parseToString(dynamic value) {
  if (value == null) return '';
  if (value is List) {
    return value.map((e) => e.toString()).join('\n');
  }
  return value.toString();
}

double _parseDouble(dynamic val, [double fallback = 92.0]) {
  if (val == null) return fallback;
  if (val is num) return val.toDouble();
  if (val is String) {
    return double.tryParse(val) ?? fallback;
  }
  return fallback;
}

class DiseaseDiagnosisResult {
  final String id;
  final String detectedCrop;
  final String diseaseNameEn;
  final String diseaseNameMl;
  final double confidence;
  final String severity;
  final String symptomsEn;
  final String symptomsMl;
  final String organicRemedyEn;
  final String organicRemedyMl;
  final String chemicalRemedyEn;
  final String chemicalRemedyMl;
  final String preventionTipsEn;
  final String preventionTipsMl;

  DiseaseDiagnosisResult({
    required this.id,
    required this.detectedCrop,
    required this.diseaseNameEn,
    required this.diseaseNameMl,
    required this.confidence,
    required this.severity,
    required this.symptomsEn,
    required this.symptomsMl,
    required this.organicRemedyEn,
    required this.organicRemedyMl,
    required this.chemicalRemedyEn,
    required this.chemicalRemedyMl,
    required this.preventionTipsEn,
    required this.preventionTipsMl,
  });

  factory DiseaseDiagnosisResult.fromJson(Map<String, dynamic> json) {
    return DiseaseDiagnosisResult(
      id: json['id']?.toString() ?? 'diag-${DateTime.now().millisecondsSinceEpoch}',
      detectedCrop: _parseToString(json['detected_crop']).isNotEmpty ? _parseToString(json['detected_crop']) : 'Crop',
      diseaseNameEn: _parseToString(json['disease_name_en']).isNotEmpty ? _parseToString(json['disease_name_en']) : 'Identified Plant Condition',
      diseaseNameMl: _parseToString(json['disease_name_ml']).isNotEmpty ? _parseToString(json['disease_name_ml']) : 'കണ്ടെത്തിയ രോഗാവസ്ഥ',
      confidence: _parseDouble(json['confidence_score'], 92.0),
      severity: json['severity']?.toString() ?? 'MEDIUM',
      symptomsEn: _parseToString(json['symptoms_en']),
      symptomsMl: _parseToString(json['symptoms_ml']),
      organicRemedyEn: _parseToString(json['organic_remedy_en']),
      organicRemedyMl: _parseToString(json['organic_remedy_ml']),
      chemicalRemedyEn: _parseToString(json['chemical_remedy_en']),
      chemicalRemedyMl: _parseToString(json['chemical_remedy_ml']),
      preventionTipsEn: _parseToString(json['prevention_tips_en']),
      preventionTipsMl: _parseToString(json['prevention_tips_ml']),
    );
  }
}

class DiseaseDetectionState {
  final bool isScanning;
  final File? selectedImageFile;
  final DiseaseDiagnosisResult? result;
  final String? error;

  const DiseaseDetectionState({
    this.isScanning = false,
    this.selectedImageFile,
    this.result,
    this.error,
  });

  DiseaseDetectionState copyWith({
    bool? isScanning,
    File? selectedImageFile,
    DiseaseDiagnosisResult? result,
    String? error,
  }) {
    return DiseaseDetectionState(
      isScanning: isScanning ?? this.isScanning,
      selectedImageFile: selectedImageFile ?? this.selectedImageFile,
      result: result ?? this.result,
      error: error,
    );
  }
}

class DiseaseDetectionNotifier extends StateNotifier<DiseaseDetectionState> {
  final DioClient _dioClient;

  DiseaseDetectionNotifier(this._dioClient) : super(const DiseaseDetectionState());

  Future<void> pickAndScanImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, maxWidth: 1024, maxHeight: 1024, imageQuality: 85);

    if (picked == null) return;

    final file = File(picked.path);
    state = state.copyWith(
      isScanning: true,
      selectedImageFile: file,
      error: null,
    );

    try {
      final bytes = await file.readAsBytes();
      final base64Image = base64Encode(bytes);

      final response = await _dioClient.client.post(
        ApiEndpoints.aiDiseaseDiagnose,
        data: {
          'image': 'data:image/jpeg;base64,$base64Image',
        },
      );

      final result = DiseaseDiagnosisResult.fromJson(response.data);
      state = state.copyWith(
        isScanning: false,
        result: result,
      );
    } catch (e) {
      state = state.copyWith(
        isScanning: false,
        error: 'Disease scan error: $e',
      );
    }
  }

  void reset() {
    state = const DiseaseDetectionState();
  }
}

final diseaseDetectionProvider = StateNotifierProvider<DiseaseDetectionNotifier, DiseaseDetectionState>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return DiseaseDetectionNotifier(dioClient);
});
