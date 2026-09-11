import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../theme/app_colors.dart';
import '../constants/app_constants.dart';

class OwnershipDisclaimerWidget extends StatelessWidget {
  final bool compact;

  const OwnershipDisclaimerWidget({
    super.key,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(compact ? AppConstants.paddingSm : AppConstants.paddingMd),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppConstants.radiusSm),
        border: Border.all(color: AppColors.info.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            LucideIcons.info,
            size: 18,
            color: AppColors.info,
          ),
          const SizedBox(width: AppConstants.paddingSm),
          Expanded(
            child: Text(
              'توثيق الهوية يثبت شخصية المستخدم فقط، ولا يثبت ملكية العقار القانونية.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.primaryLight,
                    height: 1.4,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
