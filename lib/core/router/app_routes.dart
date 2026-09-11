class AppRoutes {
  // Auth & Onboarding
  static const String login = '/login';
  static const String roleSelect = '/role-select';
  static const String register = '/register';
  static const String otpVerification = '/otp-verification';
  static const String forgotPassword = '/forgot-password';

  // Tenant Routes
  static const String tenant = '/tenant';
  static const String tenantPostRequest = '/tenant/post-request';
  static const String tenantProperty = '/tenant/property/:id';
  static String tenantPropertyDetail(String id) => '/tenant/property/$id';

  // Landlord Routes
  static const String landlord = '/landlord';
  static const String landlordAddProperty = '/landlord/add-property';
  static const String landlordLeads = '/landlord/leads';
  static const String paymentsPlans = '/payments/plans';

  // Deep Link / Public Property
  static const String propertyDeepLink = '/properties/:id';
  static String propertyDetail(String id) => '/properties/$id';

  // Chat & Matching
  static const String chat = '/chat/:id';
  static String chatRoom(String id) => '/chat/$id';

  // Shared Features
  static const String ekyc = '/ekyc';
  static const String legalAssistant = '/legal-assistant';
  static const String notifications = '/notifications';
  static const String profile = '/profile';
}
