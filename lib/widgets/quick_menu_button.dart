import 'package:flutter/material.dart';
import '../utils/routes.dart';
import '../constants/app_styles.dart';

class QuickMenuButton extends StatelessWidget {
  const QuickMenuButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopupMenuButton<String>(
      color: colorScheme.surface,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      offset: const Offset(0, 48),
      onSelected: (value) {
        if (value == 'home') {
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        } else if (value == 'wishlist') {
          Navigator.pushReplacementNamed(context, AppRoutes.wishlist);
        } else if (value == 'cart') {
          Navigator.pushReplacementNamed(context, AppRoutes.cart);
        } else if (value == 'profile') {
          Navigator.pushReplacementNamed(context, AppRoutes.profile);
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'home',
          child: Row(
            children: [
              Icon(Icons.home_rounded, color: colorScheme.primary, size: 20),
              const SizedBox(width: 12),
              const Text('Home', style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'wishlist',
          child: Row(
            children: [
              Icon(Icons.favorite_rounded, color: colorScheme.primary, size: 20),
              const SizedBox(width: 12),
              const Text('My Wishlist', style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'cart',
          child: Row(
            children: [
              Icon(Icons.shopping_bag_rounded, color: colorScheme.primary, size: 20),
              const SizedBox(width: 12),
              const Text('My Cart', style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'profile',
          child: Row(
            children: [
              Icon(Icons.person_rounded, color: colorScheme.primary, size: 20),
              const SizedBox(width: 12),
              const Text('My Profile', style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          boxShadow: isDark ? [] : AppStyles.subtleShadow,
          border: isDark
              ? Border.all(color: colorScheme.outline.withValues(alpha: 0.3))
              : null,
        ),
        child: Icon(Icons.grid_view_rounded, color: colorScheme.primary, size: 20),
      ),
    );
  }
}
