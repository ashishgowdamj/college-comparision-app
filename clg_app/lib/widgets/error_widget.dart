import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class CustomErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const CustomErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: AppSizes.iconSizeLarge,
            color: AppColors.error,
          ),
          SizedBox(height: AppSizes.paddingMedium),
          Text(
            message,
            style: AppTextStyles.body1,
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            SizedBox(height: AppSizes.paddingMedium),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: Text('Retry'),
            ),
          ],
        ],
      ),
    );
  }
} 