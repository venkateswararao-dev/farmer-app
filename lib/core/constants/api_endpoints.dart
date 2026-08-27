class ApiEndpoints {
  // Production Live Render API URL
  static const String baseUrl = 'https://farmer-api-z5vp.onrender.com';

  static const String authSync = '/auth/sync';
  static const String authMe = '/auth/me';
  static const String authLanguage = '/auth/language';

  static const String farmProfile = '/farm-profile';
  static const String crops = '/crops';
  static const String cropsCatalog = '/crops/catalog';

  static const String weather = '/weather';
  static const String marketPrices = '/market-prices';

  static const String aiChat = '/ai/chat';
  static const String aiChatSessions = '/ai/chat/sessions';
  static const String aiDiseaseDiagnose = '/ai/disease-detection/diagnose';
  static const String aiDiseaseHistory = '/ai/disease-detection/history';
  static const String aiRecommendations = '/ai/recommendations';
}
