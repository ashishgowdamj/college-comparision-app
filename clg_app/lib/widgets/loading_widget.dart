import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class LoadingWidget extends StatelessWidget {
  final String? message;

  const LoadingWidget({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppColors.primary,
          ),
          if (message != null) ...[
            SizedBox(height: AppSizes.paddingMedium),
            Text(
              message!,
              style: AppTextStyles.body2,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
} 