import 'package:flutter_test/flutter_test.dart';
import 'package:propmatch_mobile/core/constants/api_endpoints.dart';

void main() {
  group('ApiEndpoints Backend Contract Verification', () {
    test('Chat and Matches endpoints match NestJS @Controller("matches")', () {
      expect(ApiEndpoints.matchConnections, equals('/matches'));
      expect(ApiEndpoints.messages, equals('/matches'));
    });

    test('Tenant request endpoints match NestJS @Controller("tenant/requests")', () {
      expect(ApiEndpoints.tenantRequests, equals('/tenant/requests'));
      expect(ApiEndpoints.myTenantRequests, equals('/tenant/requests'));
      expect(ApiEndpoints.allTenantRequests, equals('/tenant-requests'));
    });

    test('Offers endpoints match NestJS OffersController & TenantOffersController', () {
      expect(ApiEndpoints.reverseMarketplace, equals('/landlord/requests'));
      expect(ApiEndpoints.landlordOffers, equals('/landlord/offers'));
      expect(ApiEndpoints.ownerOffers, equals('/tenant/offers'));
      expect(ApiEndpoints.tenantOffers, equals('/tenant/listing-offers'));
      expect(ApiEndpoints.landlordListingOffers, equals('/landlord/listing-offers'));
    });

    test('Favorites endpoint matches NestJS @Controller("tenant/favorites")', () {
      expect(ApiEndpoints.favorites, equals('/tenant/favorites'));
    });

    test('Properties and search endpoints match backend routes', () {
      expect(ApiEndpoints.properties, equals('/properties'));
      expect(ApiEndpoints.landlordProperties, equals('/landlord/properties'));
      expect(ApiEndpoints.searchProperties, equals('/properties/search'));
      expect(ApiEndpoints.hybridSearch, equals('/properties/search/semantic'));
      expect(
        ApiEndpoints.optimizeDescriptionStream,
        equals('/landlord/properties/draft/optimize-description/stream'),
      );
    });

    test('Verification and Quota endpoints match backend routes', () {
      expect(ApiEndpoints.ekyc, equals('/verification'));
      expect(ApiEndpoints.ekycStatus, equals('/verification/me'));
      expect(ApiEndpoints.ekycSubmit, equals('/verification/submit'));
      expect(ApiEndpoints.myQuota, equals('/quota'));
    });

    test('Legal and Support endpoints match backend routes', () {
      expect(ApiEndpoints.legalChat, equals('/legal-chat'));
      expect(ApiEndpoints.legalChatStream, equals('/legal-chat/stream'));
      expect(ApiEndpoints.customerSupport, equals('/support/tickets'));
      expect(ApiEndpoints.customerSupportStream, equals('/support/ai-chat/stream'));
    });
  });
}
