import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/category_chip.dart';
import '../widgets/search_bar.dart';
import '../widgets/custom_bottom_nav.dart';
import '../widgets/quick_menu_button.dart';
import '../widgets/empty_state.dart';
import '../widgets/shimmer_loading.dart';
import '../utils/routes.dart';
import '../constants/app_styles.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                if (productProvider.isLoading) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 100),
                    child: Column(
                      children: [
                        _buildHeader(context, colorScheme, isDark),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 8.0),
                          child: CustomSearchBar(),
                        ),
                        const SizedBox(height: 16),
                        ShimmerLoading.productGrid(itemCount: 4),
                      ],
                    ),
                  );
                }

                return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // Header
                    SliverToBoxAdapter(
                      child: _buildHeader(context, colorScheme, isDark),
                    ),

                    // Search Bar
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                        child: CustomSearchBar(),
                      ),
                    ),

                    // Promo Banner
                    SliverToBoxAdapter(
                      child: _buildPromoBanner(context, colorScheme),
                    ),

                    // Section Header
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Categories',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'See All',
                                style: TextStyle(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Category Chips
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 42,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          itemCount: productProvider.categories.length,
                          itemBuilder: (context, index) {
                            final category = productProvider.categories[index];
                            return CategoryChip(
                              label: category,
                              isSelected:
                                  productProvider.selectedCategory == category,
                              onTap: () =>
                                  productProvider.setSelectedCategory(category),
                            );
                          },
                        ),
                      ),
                    ),

                    // Products Section Header
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 24, right: 24, top: 20, bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Popular Products',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: colorScheme.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${productProvider.products.length} items',
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
                    ),

                    // Product Grid or Empty
                    if (productProvider.products.isEmpty)
                      const SliverFillRemaining(
                        child: EmptyState(
                          icon: Icons.search_off,
                          title: 'No products found',
                          message: 'Try adjusting your search or category.',
                        ),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.only(
                            left: 24, right: 24, bottom: 100),
                        sliver: SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.62,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final product = productProvider.products[index];
                              return AnimationConfiguration.staggeredGrid(
                                position: index,
                                duration: const Duration(milliseconds: 400),
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
                            childCount: productProvider.products.length,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(child: CustomBottomNav(currentIndex: 0)),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context, ColorScheme colorScheme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const QuickMenuButton(),
          Column(
            children: [
              Text(
                'Hello Zaskia 👋',
                style: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Jakarta, INA',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
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
    );
  }

  Widget _buildPromoBanner(BuildContext context, ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary,
            colorScheme.primary.withValues(alpha: 0.75),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '🔥 Limited Time',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Big Sale',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Get the trendy fashion at a\ndiscount of up to 50%',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Shop Now',
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Decorative element
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shopping_bag_rounded,
              size: 40,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
