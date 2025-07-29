import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onViewAll;
  final String? viewAllText;

  const SectionHeader({
    super.key,
    required this.title,
    this.onViewAll,
    this.viewAllText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMedium,
        vertical: AppSizes.paddingSmall,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyles.heading3,
          ),
          if (onViewAll != null)
            TextButton(
              onPressed: onViewAll,
              child: Text(
                viewAllText ?? 'View All',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
} 