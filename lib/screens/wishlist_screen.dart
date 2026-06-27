import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../providers/product_provider.dart';
import '../providers/wishlist_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/custom_bottom_nav.dart';
import '../widgets/empty_state.dart';
import '../utils/routes.dart';
import '../constants/app_styles.dart';
import '../widgets/quick_menu_button.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const QuickMenuButton(),
                      Row(
                        children: [
                          Icon(
                            Icons.favorite_rounded,
                            color: colorScheme.primary,
                            size: 22,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Wishlist',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () => Navigator.pushReplacementNamed(context, AppRoutes.profile),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: colorScheme.primary.withValues(alpha: 0.3),
                              width: 2,
                            ),
                          ),
                          child: const CircleAvatar(
                            radius: 20,
                            backgroundImage:
                                NetworkImage('https://i.pravatar.cc/150?img=5'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Wishlist Content
                Expanded(
                  child: Consumer2<WishlistProvider, ProductProvider>(
                    builder: (context, wishlist, products, child) {
                      final favoriteProducts = products.allProducts
                          .where(
                              (p) => wishlist.isFavorite(p.id))
                          .toList();

                      if (favoriteProducts.isEmpty) {
                        return const EmptyState(
                          icon: Icons.favorite_outline,
                          title: 'No favorites yet',
                          message:
                              'Tap the heart icon on any product to save it here.',
                        );
                      }

                      // Items count badge
                      return Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Your Favorites',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: colorScheme.primary
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '${favoriteProducts.length} items',
                                    style: TextStyle(
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: AnimationLimiter(
                              child: GridView.builder(
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.only(
                                  left: 24,
                                  right: 24,
                                  bottom: 100,
                                ),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.62,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                ),
                                itemCount: favoriteProducts.length,
                                itemBuilder: (context, index) {
                                  final product = favoriteProducts[index];
                                  return AnimationConfiguration
                                      .staggeredGrid(
                                    position: index,
                                    duration:
                                        const Duration(milliseconds: 400),
                                    columnCount: 2,
                                    child: ScaleAnimation(
                                      scale: 0.9,
                                      child: FadeInAnimation(
                                        child: ProductCard(
                                          product: product,
                                          onTap: () {
                                            Navigator.pushNamed(
                                              context,
                                              AppRoutes.productDetail,
                                              arguments: product,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(child: CustomBottomNav(currentIndex: 2)),
          ),
        ],
      ),
    );
  }
}
