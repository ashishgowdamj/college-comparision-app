import 'package:flutter/material.dart';

class CollegeImage extends StatelessWidget {
  final String? imageUrl;
  final double? height;
  final double? width;
  final double? borderRadius;
  final BoxFit? fit;

  const CollegeImage({
    Key? key,
    this.imageUrl,
    this.height,
    this.width,
    this.borderRadius,
    this.fit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 120,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius ?? 8),
        color: Colors.grey[200],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius ?? 8),
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? Image.network(
                imageUrl!,
                fit: fit ?? BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholder();
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _buildPlaceholder();
                },
              )
            : _buildPlaceholder(),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[300],
      child: Icon(
        Icons.school,
        size: 40,
        color: Colors.grey[600],
      ),
    );
  }
} 