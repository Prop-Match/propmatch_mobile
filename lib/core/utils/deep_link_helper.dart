import 'package:share_plus/share_plus.dart';
import 'package:propmatch_mobile/core/utils/formatters.dart';
import 'package:propmatch_mobile/features/tenant/domain/entities/property_entity.dart';
import 'package:propmatch_mobile/features/tenant/domain/entities/tenant_request_entity.dart';

class DeepLinkHelper {
  static const String baseUrl = 'https://propmatch.technative.me';

  static String getPropertyUrl(String id) => '$baseUrl/properties/$id';
  static String getTenantRequestUrl(String id) => '$baseUrl/tenant-requests/$id';

  static Future<void> shareProperty(PropertyEntity property) async {
    final url = getPropertyUrl(property.id);
    final text = '🏠 ${property.title}\n'
        '📍 ${property.district}، المنصورة\n'
        '💰 ${Formatters.formatCurrency(property.rentAmount)} شهرياً\n'
        '✨ ${property.bedrooms} غرف نوم • ${property.isFurnished ? "مفروش" : "غير مفروش"}\n\n'
        'شاهد تفاصيل العقار وتواصل مباشرة عبر منصة بروب ماتش:\n$url';

    await Share.share(text, subject: property.title);
  }

  static Future<void> shareTenantRequest(TenantRequestEntity request) async {
    final url = getTenantRequestUrl(request.id);
    final text = '🔍 طلب سكن في المنصورة:\n'
        '📍 المناطق المفضلة: ${request.preferredLocations}\n'
        '💰 الميزانية: ${Formatters.formatCurrency(request.minBudget)} - ${Formatters.formatCurrency(request.maxBudget)}\n'
        '🛏️ ${request.requiredBedrooms} غرف • ${request.needsFurnished ? "مفروش" : "غير مفروش"}\n\n'
        'قدّم عرضك المباشر للمستأجر عبر منصة بروب ماتش:\n$url';

    await Share.share(text, subject: 'طلب سكن في المنصورة');
  }
}
