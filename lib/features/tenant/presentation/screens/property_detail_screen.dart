import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:propmatch_mobile/core/theme/app_colors.dart';
import 'package:propmatch_mobile/core/constants/app_constants.dart';
import 'package:propmatch_mobile/core/utils/formatters.dart';
import 'package:propmatch_mobile/core/utils/deep_link_helper.dart';
import 'package:propmatch_mobile/core/widgets/app_button.dart';
import 'package:propmatch_mobile/core/widgets/match_score_badge.dart';
import 'package:propmatch_mobile/core/widgets/ownership_disclaimer_widget.dart';
import '../../domain/entities/property_entity.dart';
import '../../domain/repositories/tenant_repository.dart';
import '../widgets/match_score_breakdown_dialog.dart';
import '../widgets/send_direct_offer_sheet.dart';

class PropertyDetailScreen extends StatefulWidget {
  final PropertyEntity property;

  const PropertyDetailScreen({
    super.key,
    required this.property,
  });

  @override
  State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  int _currentImageIndex = 0;

  void _showMatchBreakdown() {
    if (widget.property.matchScore != null) {
      showDialog(
        context: context,
        builder: (ctx) => MatchScoreBreakdownDialog(
          overallScore: widget.property.matchScore!,
          breakdown: widget.property.matchBreakdown,
        ),
      );
    }
  }

  void _openOfferSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SendDirectOfferSheet(
        property: widget.property,
        onSubmit: (price, msg) async {
          final repo = context.read<TenantRepository>();
          final result = await repo.sendDirectOffer(
            propertyId: widget.property.id,
            proposedPrice: price,
            message: msg,
          );
          if (result.isSuccess && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم إرسال عرضك للمالك بنجاح'),
                backgroundColor: AppColors.success,
              ),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final property = widget.property;
    final images = property.images.isNotEmpty ? property.images : [property.coverImageUrl ?? ''];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Image Carousel AppBar
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            actions: [
              IconButton(
                icon: const Icon(LucideIcons.share_2),
                onPressed: () => DeepLinkHelper.shareProperty(widget.property),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  PageView.builder(
                    itemCount: images.length,
                    onPageChanged: (index) {
                      setState(() => _currentImageIndex = index);
                    },
                    itemBuilder: (context, index) {
                      final url = images[index];
                      if (url.isEmpty) {
                        return Container(
                          color: AppColors.borderLight,
                          child: const Icon(LucideIcons.house, size: 64, color: AppColors.textMuted),
                        );
                      }
                      return CachedNetworkImage(
                        imageUrl: url,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => const Icon(LucideIcons.image),
                      );
                    },
                  ),
                  if (images.length > 1)
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          images.length,
                          (i) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: _currentImageIndex == i ? 16 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: _currentImageIndex == i ? Colors.white : Colors.white54,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Property Details Body
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          property.title,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            Formatters.formatCurrency(property.rentAmount),
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            'شهرياً',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Location
                  Row(
                    children: [
                      const Icon(LucideIcons.map_pin, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 6),
                      Text(
                        '${property.district}، ${property.cityName ?? "المنصورة"}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Match Score Card
                  if (property.matchScore != null) ...[
                    InkWell(
                      onTap: _showMatchBreakdown,
                      borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                      child: Container(
                        padding: const EdgeInsets.all(AppConstants.paddingMd),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                          border: Border.all(color: AppColors.success.withValues(alpha: 0.25)),
                        ),
                        child: Row(
                          children: [
                            MatchScoreBadge(score: property.matchScore!),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'مطابقة ذكية ممتازة مع متطلباتك',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                  Text(
                                    'اضغط للاطلاع على أسباب وتفاصيل المطابقة',
                                    style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(LucideIcons.chevron_left, size: 18, color: AppColors.textSecondary),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Specs Grid
                  Text(
                    'مواصفات العقار',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _buildSpecTile(LucideIcons.bed_double, '${property.bedrooms} غرف نوم'),
                      _buildSpecTile(LucideIcons.bath, '${property.bathrooms} حمامات'),
                      _buildSpecTile(LucideIcons.maximize_2, Formatters.formatArea(property.areaM2)),
                      _buildSpecTile(LucideIcons.armchair, property.isFurnished ? 'مفروش بالكامل' : 'غير مفروش'),
                      if (property.hasElevator)
                        _buildSpecTile(LucideIcons.circle_arrow_up, 'يوجد مصعد'),
                      if (property.hasParking)
                        _buildSpecTile(LucideIcons.car, 'موقف سيارات'),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Description
                  Text(
                    'وصف العقار',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    property.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6),
                  ),
                  const SizedBox(height: 24),

                  // Landlord Info & Ownership Disclaimer
                  Text(
                    'المالك ومعلومات التواصل',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(AppConstants.paddingMd),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.primaryLight,
                          radius: 22,
                          child: const Icon(LucideIcons.user, color: Colors.white, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    property.ownerName ?? 'مالك العقار',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                  if (property.isOwnerVerified) ...[
                                    const SizedBox(width: 4),
                                    const Icon(LucideIcons.circle_check, color: AppColors.accent, size: 16),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                property.contactRevealed
                                    ? (property.ownerPhone ?? 'رقم الاتصال متاح')
                                    : 'بيانات الاتصال تظهر بعد قبول الطرفين للمطابقة',
                                style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const OwnershipDisclaimerWidget(),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(AppConstants.paddingMd),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: [
            Expanded(
              child: AppButton(
                text: 'تقديم عرض سعر مباشر',
                icon: const Icon(LucideIcons.tag, size: 18, color: Colors.white),
                onPressed: _openOfferSheet,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecTile(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppConstants.radiusSm),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.accent),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
