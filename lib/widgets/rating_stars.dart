import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final double size;

  const RatingStars({
    Key? key,
    required this.rating,
    this.size = 16.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          return Icon(Icons.star, color: AppColors.starRating, size: size);
        } else if (index == rating.floor() && rating % 1 != 0) {
          return Icon(Icons.star_half, color: AppColors.starRating, size: size);
        } else {
          return Icon(Icons.star_border, color: AppColors.starRating, size: size);
        }
      }),
    );
  }
}
