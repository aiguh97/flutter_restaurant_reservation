import 'package:flutter/material.dart';
import '../../../core/components/spaces.dart';
import '../../../core/constants/colors.dart';

class ProductSkeleton extends StatelessWidget {
  const ProductSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.grey.withOpacity(0.3),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
          ),
          const SpaceHeight(8.0),
          // Title placeholder
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              height: 16,
              width: double.infinity,
              color: AppColors.grey.withOpacity(0.3),
            ),
          ),
          const SpaceHeight(4.0),
          // Subtitle placeholder (price)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              height: 14,
              width: 80,
              color: AppColors.grey.withOpacity(0.3),
            ),
          ),
          const SpaceHeight(8.0),
        ],
      ),
    );
  }
}
