import 'package:equatable/equatable.dart';

class CommercialProductEntity extends Equatable {
  final String paymentType;
  final int priceEgp;
  final bool enabled;
  final String billing;
  final String kind;
  final String? planType;
  final String? entitlementType;
  final int? quantity;
  final int? validityDays;
  final int? durationDays;

  const CommercialProductEntity({
    required this.paymentType,
    required this.priceEgp,
    required this.enabled,
    required this.billing,
    required this.kind,
    this.planType,
    this.entitlementType,
    this.quantity,
    this.validityDays,
    this.durationDays,
  });

  factory CommercialProductEntity.fromJson(Map<String, dynamic> json) {
    return CommercialProductEntity(
      paymentType: json['paymentType'] as String? ?? '',
      priceEgp: json['priceEgp'] as int? ?? 0,
      enabled: json['enabled'] as bool? ?? true,
      billing: json['billing'] as String? ?? 'ONE_TIME',
      kind: json['kind'] as String? ?? 'ENTITLEMENT',
      planType: json['planType'] as String?,
      entitlementType: json['entitlementType'] as String?,
      quantity: json['quantity'] as int?,
      validityDays: json['validityDays'] as int?,
      durationDays: json['durationDays'] as int?,
    );
  }

  String get titleArabic {
    switch (paymentType) {
      case 'OWNER_PLUS_MONTHLY':
        return 'باقة المالك المتقدم (شهري)';
      case 'OWNER_PLUS_YEARLY':
        return 'باقة المالك المتقدم (سنوي)';
      case 'PREMIUM_MONTHLY':
        return 'باقة المالك المميز (شهري)';
      case 'PREMIUM_YEARLY':
        return 'باقة المالك المميز (سنوي)';
      case 'EXTRA_LISTING_60D':
        return 'عقار نشط إضافي (60 يوم)';
      case 'OFFERS_10_60D':
        return 'باقة 10 عروض للمطابقات (60 يوم)';
      case 'BOOST_7D':
        return 'تمييز إعلان (7 أيام)';
      case 'BOOST_14D':
        return 'تمييز إعلان (14 يوم)';
      case 'BOOST_30D':
        return 'تمييز إعلان (30 يوم)';
      case 'AI_USES_10_90D':
        return '10 استخدامات لتحسين الذكاء الاصطناعي (90 يوم)';
      default:
        return paymentType;
    }
  }

  String get descriptionArabic {
    switch (paymentType) {
      case 'OWNER_PLUS_MONTHLY':
      case 'OWNER_PLUS_YEARLY':
        return '3 عقارات نشطة، 30 عرض شهرياً، 10 استخدامات للذكاء الاصطناعي، ورصيد تمييز شهري.';
      case 'PREMIUM_MONTHLY':
      case 'PREMIUM_YEARLY':
        return '10 عقارات نشطة، 100 عرض شهرياً، 30 استخدام للذكاء الاصطناعي، ورصيدان للتمييز شهرياً.';
      case 'EXTRA_LISTING_60D':
        return 'أضف عقاراً نشطاً إضافياً لقائمتك صالح لمدة شهرين.';
      case 'OFFERS_10_60D':
        return 'أرسل 10 عروض إضافية للطلبات السكنية المطابقة لصالح لمدة 60 يوماً.';
      case 'BOOST_7D':
        return 'ظهور متميز لعقارك في أعلى نتائج البحث والمطابقة لمدة أسبوع.';
      case 'BOOST_14D':
        return 'ظهور متميز لعقارك في أعلى نتائج البحث والمطابقة لمدة أسبوعين.';
      case 'BOOST_30D':
        return 'أقصى ظهور لعقارك في صدارة البحث والمطابقات لمدة شهر كامل.';
      case 'AI_USES_10_90D':
        return 'تحسين صياغة وتوصيف العقار بالذكاء الاصطناعي لجذب مستأجرين أسرع.';
      default:
        return '';
    }
  }

  @override
  List<Object?> get props => [
        paymentType,
        priceEgp,
        enabled,
        billing,
        kind,
        planType,
        entitlementType,
        quantity,
        validityDays,
        durationDays,
      ];
}

class PlanAllowancesEntity extends Equatable {
  final int activeListings;
  final int offers;
  final int aiUses;
  final int boostCredits;
  final int boostDurationDays;

  const PlanAllowancesEntity({
    required this.activeListings,
    required this.offers,
    required this.aiUses,
    required this.boostCredits,
    required this.boostDurationDays,
  });

  factory PlanAllowancesEntity.fromJson(Map<String, dynamic> json) {
    return PlanAllowancesEntity(
      activeListings: json['activeListings'] as int? ?? 0,
      offers: json['offers'] as int? ?? 0,
      aiUses: json['aiUses'] as int? ?? 0,
      boostCredits: json['boostCredits'] as int? ?? 0,
      boostDurationDays: json['boostDurationDays'] as int? ?? 7,
    );
  }

  @override
  List<Object?> get props => [activeListings, offers, aiUses, boostCredits, boostDurationDays];
}

class CommercialCatalogEntity extends Equatable {
  final Map<String, PlanAllowancesEntity> plans;
  final List<CommercialProductEntity> products;

  const CommercialCatalogEntity({
    required this.plans,
    required this.products,
  });

  factory CommercialCatalogEntity.fromJson(Map<String, dynamic> json) {
    final rawPlans = json['plans'] as Map<String, dynamic>? ?? {};
    final plansMap = rawPlans.map(
      (k, v) => MapEntry(k, PlanAllowancesEntity.fromJson(v as Map<String, dynamic>)),
    );

    final rawProducts = json['products'] as Map<String, dynamic>? ?? {};
    final productList = rawProducts.values
        .map((p) => CommercialProductEntity.fromJson(p as Map<String, dynamic>))
        .where((p) => p.enabled)
        .toList();

    return CommercialCatalogEntity(
      plans: plansMap,
      products: productList,
    );
  }

  @override
  List<Object?> get props => [plans, products];
}

class CheckoutResultEntity extends Equatable {
  final String providerOrderId;
  final int amount;
  final String currency;
  final String paymentType;
  final String checkoutUrl;

  const CheckoutResultEntity({
    required this.providerOrderId,
    required this.amount,
    required this.currency,
    required this.paymentType,
    required this.checkoutUrl,
  });

  factory CheckoutResultEntity.fromJson(Map<String, dynamic> json) {
    return CheckoutResultEntity(
      providerOrderId: json['providerOrderId'] as String? ?? '',
      amount: json['amount'] as int? ?? 0,
      currency: json['currency'] as String? ?? 'EGP',
      paymentType: json['paymentType'] as String? ?? '',
      checkoutUrl: json['checkoutUrl'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [providerOrderId, amount, currency, paymentType, checkoutUrl];
}
