class ApiEndpoints {
  // Base URLs
  static const String defaultBaseUrl = 'https://propmatch.technative.me/api';

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String me = '/auth/me';
  static const String forgotPassword = '/auth/forgot-password';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resendEmailVerification = '/auth/resend-email-verification';
  static const String verifyEmail = '/auth/verify-email';
  static const String resetPassword = '/auth/reset-password';
  static const String requestReactivation = '/auth/request-reactivation';

  // Properties (Forward Marketplace)
  static const String properties = '/properties';
  static const String landlordProperties = '/landlord/properties';
  static const String searchProperties = '/properties/search';
  static const String hybridSearch = '/properties/search/semantic';
  static const String optimizeDescriptionStream =
      '/landlord/properties/draft/optimize-description/stream';

  // Tenant Requests (Reverse Marketplace)
  static const String tenantRequests = '/tenant/requests';
  static const String myTenantRequests = '/tenant/requests';
  static const String allTenantRequests = '/tenant-requests';
  static const String reverseMarketplace =
      '/landlord/requests'; // Landlord discovery of tenant requests

  // Offers
  static const String landlordOffers = '/landlord/offers'; // Landlord -> TenantRequest
  static const String ownerOffers = '/tenant/offers'; // Tenant received offers
  static const String tenantOffers =
      '/tenant/listing-offers'; // Tenant -> Property listing
  static const String tenantOfferCounter = '/tenant/listing-offers/{id}/accept';
  static const String landlordListingOffers = '/landlord/listing-offers';

  // Favorites
  static const String favorites = '/tenant/favorites';

  // Match Connections & Messaging
  static const String matchConnections = '/matches';
  static const String messages = '/matches';

  // eKYC Verification
  static const String ekyc = '/verification';
  static const String ekycStatus = '/verification/me';
  static const String ekycSubmit = '/verification/submit';

  // Lease Contracts
  static const String leaseContracts = '/contracts';
  static const String matchContract = '/matches/{matchConnectionId}/contract';

  // AI Legal Assistant
  static const String legalChat = '/legal-chat';
  static const String legalChatStream = '/legal-chat/stream';

  // Support Bot & Tickets
  static const String customerSupport = '/support/tickets';
  static const String customerSupportStream = '/support/ai-chat/stream';

  // Payments & Monetization
  static const String paymentsCheckout = '/payments/checkout';
  static const String myQuota = '/quota';
  static const String productConfigs = '/commercial-config/catalog';
  static const String planConfigs = '/commercial-config/catalog';

  // Profile & Reviews
  static const String userProfile = '/users/profile';
  static const String propertyReviews = '/reviews';
  static const String userReviews = '/reviews/user';
  static const String notifications = '/notifications';
  static const String regions = '/regions';
}

