import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:propmatch_mobile/core/theme/app_colors.dart';
import 'package:propmatch_mobile/core/constants/app_constants.dart';
import 'package:propmatch_mobile/core/widgets/app_button.dart';

class MatchScoreBreakdownDialog extends StatelessWidget {
  final num overallScore;
  final Map<String, dynamic>? breakdown;

  const MatchScoreBreakdownDialog({
    super.key,
    required this.overallScore,
    this.breakdown,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(LucideIcons.sparkles, color: AppColors.accent, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'تفاصيل التطابق الذكي',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        'نسبة التوافق الكلية: ${overallScore.round()}%',
                        style: const TextStyle(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingMd),
            const Text(
              'يقوم نموذج PropMatch AI بمطابقة متطلباتك مع مواصفات العقار بناءً على العوامل التالية:',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppConstants.paddingMd),
            _buildFactorRow(
              icon: LucideIcons.coins,
              title: 'توافق الميزانية',
              subtitle: 'السعر يقع ضمن نطاق ميزانيتك المحددة',
              score: 95,
              context: context,
            ),
            _buildFactorRow(
              icon: LucideIcons.map_pin,
              title: 'الموقع والحي السكني',
              subtitle: 'ضمن المناطق الجغرافية المفضلة لديك بالمنصورة',
              score: 90,
              context: context,
            ),
            _buildFactorRow(
              icon: LucideIcons.bed_double,
              title: 'عدد الغرف والمساحة',
              subtitle: 'مطابق تماماً للعدد المطلوب',
              score: 85,
              context: context,
            ),
            _buildFactorRow(
              icon: LucideIcons.armchair,
              title: 'حالة الفرش والتجهيز',
              subtitle: 'مفروش ومجهز بالخدمات الأساسية',
              score: 80,
              context: context,
            ),
            _buildFactorRow(
              icon: LucideIcons.sparkles,
              title: 'نمط المعيشة والخدمات القريبة',
              subtitle: 'قريب من الجامعة والمرافق الحيوية',
              score: 88,
              context: context,
            ),
            const SizedBox(height: AppConstants.paddingLg),
            AppButton(
              text: 'فهمت ذلك',
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFactorRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required int score,
    required BuildContext context,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '$score%',
              style: const TextStyle(
                color: AppColors.success,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
