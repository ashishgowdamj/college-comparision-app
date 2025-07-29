import 'package:flutter/material.dart';
import '../models/college.dart';
import '../constants/app_constants.dart';
import 'college_image.dart';

class CollegeCard extends StatelessWidget {
  final College college;
  final VoidCallback? onTap;
  final VoidCallback? onBookmark;
  final bool isBookmarked;
  final bool showRemoveButton;
  final VoidCallback? onRemove;

  const CollegeCard({
    super.key,
    required this.college,
    this.onTap,
    this.onBookmark,
    this.isBookmarked = false,
    this.showRemoveButton = false,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        child: Container(
          width: 160,
          height: 120,
          padding: EdgeInsets.all(AppSizes.paddingSmall),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CollegeImage(
                    imageUrl: college.imageUrl,
                    height: 50,
                    width: 50,
                    borderRadius: AppSizes.radiusSmall,
                  ),
                  SizedBox(width: AppSizes.paddingSmall),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          college.name,
                          style: AppTextStyles.body2.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${college.city} • ${college.type}',
                          style: AppTextStyles.caption,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  if (showRemoveButton && onRemove != null)
                    IconButton(
                      icon: Icon(Icons.close, size: 16),
                      onPressed: onRemove,
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    )
                  else if (onBookmark != null)
                    IconButton(
                      icon: Icon(
                        isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                        size: 16,
                        color: isBookmarked ? AppColors.primary : null,
                      ),
                      onPressed: onBookmark,
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                ],
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Rank: ${college.rank}',
                    style: AppTextStyles.caption,
                  ),
                  Text(
                    '₹${college.fees}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
} 