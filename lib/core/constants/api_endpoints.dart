class ApiEndpoints {
  // Local network IP for mobile device testing
  static const String baseUrl = 'http://10.198.171.29:3000';

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
