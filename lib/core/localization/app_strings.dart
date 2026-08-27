import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_locale.dart';
import 'en_strings.dart';
import 'ml_strings.dart';

class AppStrings {
  final AppLang lang;

  AppStrings(this.lang);

  bool get isMl => lang == AppLang.ml;

  String get home => isMl ? MlStrings.home : EnStrings.home;
  String get aiAssistant => isMl ? MlStrings.aiAssistant : EnStrings.aiAssistant;
  String get cropDoctor => isMl ? MlStrings.cropDoctor : EnStrings.cropDoctor;
  String get weather => isMl ? MlStrings.weather : EnStrings.weather;
  String get marketPrices => isMl ? MlStrings.marketPrices : EnStrings.marketPrices;
  String get profile => isMl ? MlStrings.profile : EnStrings.profile;

  String get greeting => isMl ? MlStrings.greeting : EnStrings.greeting;
  String get weatherOverview => isMl ? MlStrings.weatherOverview : EnStrings.weatherOverview;
  String get humidity => isMl ? MlStrings.humidity : EnStrings.humidity;
  String get wind => isMl ? MlStrings.wind : EnStrings.wind;
  String get rainChance => isMl ? MlStrings.rainChance : EnStrings.rainChance;
  String get quickActions => isMl ? MlStrings.quickActions : EnStrings.quickActions;
  String get scanCropLeaf => isMl ? MlStrings.scanCropLeaf : EnStrings.scanCropLeaf;
  String get voiceAdvisory => isMl ? MlStrings.voiceAdvisory : EnStrings.voiceAdvisory;
  String get checkPrices => isMl ? MlStrings.checkPrices : EnStrings.checkPrices;
  String get dailyRecommendations => isMl ? MlStrings.dailyRecommendations : EnStrings.dailyRecommendations;
  String get myCrops => isMl ? MlStrings.myCrops : EnStrings.myCrops;
  String get addCrop => isMl ? MlStrings.addCrop : EnStrings.addCrop;
  String get recentDiagnoses => isMl ? MlStrings.recentDiagnoses : EnStrings.recentDiagnoses;
  String get viewAll => isMl ? MlStrings.viewAll : EnStrings.viewAll;

  String get aiTitle => isMl ? MlStrings.aiTitle : EnStrings.aiTitle;
  String get aiSubtitle => isMl ? MlStrings.aiSubtitle : EnStrings.aiSubtitle;
  String get askSomething => isMl ? MlStrings.askSomething : EnStrings.askSomething;
  String get speakNow => isMl ? MlStrings.speakNow : EnStrings.speakNow;
  String get tapToSpeak => isMl ? MlStrings.tapToSpeak : EnStrings.tapToSpeak;
  String get sampleQueries => isMl ? MlStrings.sampleQueries : EnStrings.sampleQueries;
  String get q1 => isMl ? MlStrings.q1 : EnStrings.q1;
  String get q2 => isMl ? MlStrings.q2 : EnStrings.q2;
  String get q3 => isMl ? MlStrings.q3 : EnStrings.q3;

  String get scanLeafTitle => isMl ? MlStrings.scanLeafTitle : EnStrings.scanLeafTitle;
  String get scanLeafSubtitle => isMl ? MlStrings.scanLeafSubtitle : EnStrings.scanLeafSubtitle;
  String get takePhoto => isMl ? MlStrings.takePhoto : EnStrings.takePhoto;
  String get pickFromGallery => isMl ? MlStrings.pickFromGallery : EnStrings.pickFromGallery;
  String get analyzingImage => isMl ? MlStrings.analyzingImage : EnStrings.analyzingImage;
  String get diagnosisResult => isMl ? MlStrings.diagnosisResult : EnStrings.diagnosisResult;
  String get detectedCrop => isMl ? MlStrings.detectedCrop : EnStrings.detectedCrop;
  String get diseaseName => isMl ? MlStrings.diseaseName : EnStrings.diseaseName;
  String get confidence => isMl ? MlStrings.confidence : EnStrings.confidence;
  String get severity => isMl ? MlStrings.severity : EnStrings.severity;
  String get symptoms => isMl ? MlStrings.symptoms : EnStrings.symptoms;
  String get organicRemedy => isMl ? MlStrings.organicRemedy : EnStrings.organicRemedy;
  String get chemicalRemedy => isMl ? MlStrings.chemicalRemedy : EnStrings.chemicalRemedy;
  String get preventionTips => isMl ? MlStrings.preventionTips : EnStrings.preventionTips;
  String get saveDiagnosis => isMl ? MlStrings.saveDiagnosis : EnStrings.saveDiagnosis;

  String get mandiRatesTitle => isMl ? MlStrings.mandiRatesTitle : EnStrings.mandiRatesTitle;
  String get searchCommodity => isMl ? MlStrings.searchCommodity : EnStrings.searchCommodity;
  String get allCategories => isMl ? MlStrings.allCategories : EnStrings.allCategories;
  String get plantation => isMl ? MlStrings.plantation : EnStrings.plantation;
  String get spices => isMl ? MlStrings.spices : EnStrings.spices;
  String get grains => isMl ? MlStrings.grains : EnStrings.grains;
  String get fruits => isMl ? MlStrings.fruits : EnStrings.fruits;
  String get modalPrice => isMl ? MlStrings.modalPrice : EnStrings.modalPrice;
  String get minMax => isMl ? MlStrings.minMax : EnStrings.minMax;
  String get todayTrend => isMl ? MlStrings.todayTrend : EnStrings.todayTrend;

  String get farmSetupTitle => isMl ? MlStrings.farmSetupTitle : EnStrings.farmSetupTitle;
  String get district => isMl ? MlStrings.district : EnStrings.district;
  String get selectDistrict => isMl ? MlStrings.selectDistrict : EnStrings.selectDistrict;
  String get landSize => isMl ? MlStrings.landSize : EnStrings.landSize;
  String get soilType => isMl ? MlStrings.soilType : EnStrings.soilType;
  String get irrigationType => isMl ? MlStrings.irrigationType : EnStrings.irrigationType;
  String get selectCrops => isMl ? MlStrings.selectCrops : EnStrings.selectCrops;
  String get saveProfile => isMl ? MlStrings.saveProfile : EnStrings.saveProfile;
  String get language => isMl ? MlStrings.language : EnStrings.language;
  String get switchLanguage => isMl ? MlStrings.switchLanguage : EnStrings.switchLanguage;
}

final stringsProvider = Provider<AppStrings>((ref) {
  final lang = ref.watch(localeProvider);
  return AppStrings(lang);
});
