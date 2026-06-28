import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_item_tile.dart';
import '../widgets/empty_state.dart';
import '../widgets/custom_bottom_nav.dart';
import '../utils/formatters.dart';
import '../constants/app_styles.dart';
import '../constants/app_colors.dart';
import '../utils/routes.dart';
import '../widgets/quick_menu_button.dart';
import '../widgets/order_details_sheet.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  void _checkout(BuildContext context, CartProvider cart) {
    Navigator.pushNamed(context, AppRoutes.checkout);
  }

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
                      Text(
                        'My Cart',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: colorScheme.onSurface,
                        ),
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
                // Cart items
                Expanded(
                  child: Consumer<CartProvider>(
                    builder: (context, cart, child) {
                      if (cart.itemCount == 0) {
                        return EmptyState(
                          icon: Icons.shopping_cart_outlined,
                          title: 'Your cart is empty',
                          message:
                              'Looks like you haven\'t added anything yet.',
                          buttonText: 'Start Shopping',
                          onButtonPressed: () {
                            Navigator.pushReplacementNamed(
                                context, AppRoutes.home);
                          },
                        );
                      }

                      return AnimationLimiter(
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(bottom: 260),
                          itemCount: cart.items.length,
                          itemBuilder: (context, index) {
                            final productId = cart.items.keys.toList()[index];
                            final cartItem = cart.items.values.toList()[index];
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 375),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: CartItemTile(
                                    productId: productId,
                                    cartItem: cartItem,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Checkout Bottom Bar
          Consumer<CartProvider>(
            builder: (context, cart, child) {
              if (cart.itemCount == 0) return const SizedBox.shrink();
              return Positioned(
                bottom: 100,
                left: 24,
                right: 24,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: isDark ? [] : AppStyles.mediumShadow,
                    border: isDark
                        ? Border.all(
                            color: colorScheme.outline.withValues(alpha: 0.3))
                        : null,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Order summary
                      _SummaryRow(
                        label: 'Subtotal',
                        value: Formatters.formatCurrency(cart.totalAmount),
                        colorScheme: colorScheme,
                      ),
                      const SizedBox(height: 8),
                      _SummaryRow(
                        label: 'Shipping',
                        value: 'Free',
                        colorScheme: colorScheme,
                        isHighlight: true,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Divider(
                          color: colorScheme.outline.withValues(alpha: 0.2),
                          height: 1,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: TextStyle(
                              color: colorScheme.onSurface,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            Formatters.formatCurrency(cart.totalAmount),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _checkout(context, cart),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.button,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding:
                                const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.lock_outline, size: 18),
                              SizedBox(width: 8),
                              Text(
                                'Checkout',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(child: CustomBottomNav(currentIndex: 1)),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final ColorScheme colorScheme;
  final bool isHighlight;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.colorScheme,
    this.isHighlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: colorScheme.onSurface.withValues(alpha: 0.5),
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: isHighlight
                ? const Color(0xFF2ECC71)
                : colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
