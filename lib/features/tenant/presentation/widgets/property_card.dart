import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:propmatch_mobile/core/theme/app_colors.dart';
import 'package:propmatch_mobile/core/constants/app_constants.dart';
import 'package:propmatch_mobile/core/utils/formatters.dart';
import 'package:propmatch_mobile/core/utils/deep_link_helper.dart';
import 'package:propmatch_mobile/core/widgets/match_score_badge.dart';
import '../../domain/entities/property_entity.dart';

class PropertyCard extends StatelessWidget {
  final PropertyEntity property;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;

  const PropertyCard({
    super.key,
    required this.property,
    this.onTap,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        side: BorderSide(
          color: property.isBoosted
              ? AppColors.warning.withValues(alpha: 0.5)
              : AppColors.border,
          width: property.isBoosted ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Stack
            Stack(
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  color: AppColors.borderLight,
                  child: property.coverImageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: property.coverImageUrl!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: AppColors.borderLight,
                            child: const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                          errorWidget: (context, url, error) => const Center(
                            child: Icon(LucideIcons.image, size: 40, color: AppColors.textMuted),
                          ),
                        )
                      : const Center(
                          child: Icon(LucideIcons.house, size: 48, color: AppColors.textMuted),
                        ),
                ),
                // Top Left: Boosted & Match Score
                Positioned(
                  top: 12,
                  right: 12,
                  child: Row(
                    children: [
                      if (property.isBoosted) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.warning,
                            borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(LucideIcons.zap, size: 12, color: Colors.white),
                              SizedBox(width: 4),
                              Text(
                                'مميز',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                      ],
                      if (property.matchScore != null)
                        MatchScoreBadge(score: property.matchScore!),
                    ],
                  ),
                ),
                // Top Right: Share & Favorite Buttons
                Positioned(
                  top: 12,
                  left: 12,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () => DeepLinkHelper.shareProperty(property),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            LucideIcons.share_2,
                            color: AppColors.textSecondary,
                            size: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: onFavoriteTap,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            property.isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: property.isFavorite ? AppColors.error : AppColors.textSecondary,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Card Body
            Padding(
              padding: const EdgeInsets.all(AppConstants.paddingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  const SizedBox(height: 6),
                  Text(
                    property.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(LucideIcons.map_pin, size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${property.district}${property.cityName != null ? "، ${property.cityName}" : ""}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 8),

                  // Specs Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSpecItem(
                        icon: LucideIcons.bed_double,
                        label: '${property.bedrooms} غرف',
                        context: context,
                      ),
                      _buildSpecItem(
                        icon: LucideIcons.bath,
                        label: '${property.bathrooms} حمام',
                        context: context,
                      ),
                      _buildSpecItem(
                        icon: LucideIcons.maximize_2,
                        label: Formatters.formatArea(property.areaM2),
                        context: context,
                      ),
                      _buildSpecItem(
                        icon: LucideIcons.armchair,
                        label: property.isFurnished ? 'مفروش' : 'غير مفروش',
                        context: context,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecItem({
    required IconData icon,
    required String label,
    required BuildContext context,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textMuted),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
        ),
      ],
    );
  }
}
