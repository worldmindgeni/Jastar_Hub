import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:jastar_hub_community/core/theme/app_colors.dart';
import 'package:jastar_hub_community/core/constants/app_constants.dart';

/// Beautiful shimmer loading placeholders for various content types.
class ShimmerLoader extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerLoader({
    super.key,
    this.width = double.infinity,
    this.height = 20,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor:
          isDark ? AppColors.shimmerBaseDark : AppColors.shimmerBaseLight,
      highlightColor: isDark
          ? AppColors.shimmerHighlightDark
          : AppColors.shimmerHighlightLight,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  /// Shimmer placeholder for event cards (horizontal scroll).
  static Widget eventCard({bool isDark = false}) {
    return Shimmer.fromColors(
      baseColor:
          isDark ? AppColors.shimmerBaseDark : AppColors.shimmerBaseLight,
      highlightColor: isDark
          ? AppColors.shimmerHighlightDark
          : AppColors.shimmerHighlightLight,
      child: Container(
        width: AppConstants.eventCardWidth,
        height: AppConstants.eventCardHeight,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusLg),
        ),
      ),
    );
  }

  /// Row of shimmer event cards for horizontal carousel.
  static Widget eventCardRow({int count = 3, bool isDark = false}) {
    return SizedBox(
      height: AppConstants.eventCardHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: count,
        itemBuilder: (context, index) => eventCard(isDark: isDark),
      ),
    );
  }

  /// Shimmer placeholder for list items.
  static Widget listItem({bool isDark = false}) {
    return Shimmer.fromColors(
      baseColor:
          isDark ? AppColors.shimmerBaseDark : AppColors.shimmerBaseLight,
      highlightColor: isDark
          ? AppColors.shimmerHighlightDark
          : AppColors.shimmerHighlightLight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 120,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
