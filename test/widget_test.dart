import 'package:flutter_test/flutter_test.dart';
import 'package:farmers_mobile_app/core/localization/en_strings.dart';
import 'package:farmers_mobile_app/core/localization/ml_strings.dart';
import 'package:farmers_mobile_app/core/constants/kerala_districts.dart';

void main() {
  group('Farmers App Core Unit & Localization Tests', () {
    test('Kerala Districts catalog has all 14 districts', () {
      expect(keralaDistrictsList.length, 14);
      final wayanad = keralaDistrictsList.firstWhere((d) => d.id == 'wayanad');
      expect(wayanad.nameMl, 'വയനാട്');
      expect(wayanad.primaryCrops.contains('Coffee'), true);
    });

    test('Malayalam and English localization strings parity', () {
      expect(EnStrings.home, 'Home');
      expect(MlStrings.home, 'ഹോം');
      expect(MlStrings.aiTitle, 'കൃഷി മിത്ര AI');
      expect(EnStrings.aiTitle, 'Krishi Mithra AI');
    });
  });
}
