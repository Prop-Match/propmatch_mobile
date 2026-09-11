import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../theme/app_colors.dart';
import '../constants/app_constants.dart';

class MatchScoreBadge extends StatelessWidget {
  final num score;
  final bool showLabel;
  final VoidCallback? onTap;

  const MatchScoreBadge({
    super.key,
    required this.score,
    this.showLabel = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final int rounded = score.round();
    Color badgeColor;
    Color textColor;
    Color bg;

    if (rounded >= 75) {
      badgeColor = AppColors.matchHigh;
      textColor = const Color(0xFF065F46);
      bg = const Color(0xFFD1FAE5);
    } else if (rounded >= 50) {
      badgeColor = AppColors.matchMedium;
      textColor = const Color(0xFF92400E);
      bg = const Color(0xFFFEF3C7);
    } else {
      badgeColor = AppColors.matchLow;
      textColor = const Color(0xFF374151);
      bg = const Color(0xFFF3F4F6);
    }

    final widget = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppConstants.radiusSm),
        border: Border.all(color: badgeColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            LucideIcons.sparkles,
            size: 14,
            color: badgeColor,
          ),
          const SizedBox(width: 4),
          Text(
            showLabel ? 'تطابق $rounded%' : '$rounded%',
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.radiusSm),
        child: widget,
      );
    }

    return widget;
  }
}
