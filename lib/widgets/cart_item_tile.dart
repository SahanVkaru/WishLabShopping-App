import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../models/cart_item.dart';
import '../providers/cart_provider.dart';
import '../utils/formatters.dart';
import '../constants/app_styles.dart';

class CartItemTile extends StatelessWidget {
  final String productId;
  final CartItem cartItem;

  const CartItemTile({
    Key? key,
    required this.productId,
    required this.cartItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dismissible(
      key: ValueKey(productId),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 32),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorScheme.error.withValues(alpha: 0.8),
              colorScheme.error,
            ],
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete_outline, color: Colors.white, size: 28),
            SizedBox(height: 4),
            Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Remove Item'),
            content: Text(
              'Remove "${cartItem.product.name}" from your cart?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  'Remove',
                  style: TextStyle(color: colorScheme.error),
                ),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        Provider.of<CartProvider>(context, listen: false).removeItem(productId);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: isDark ? [] : AppStyles.subtleShadow,
          border: isDark
              ? Border.all(color: colorScheme.outline.withValues(alpha: 0.3))
              : null,
        ),
        child: Row(
          children: [
            // Product Image
            Container(
              width: 80,
              height: 100,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                  imageUrl: cartItem.product.image,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colorScheme.primary,
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(
                    Icons.broken_image,
                    color: colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    cartItem.product.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    cartItem.product.category,
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    Formatters.formatCurrency(cartItem.product.price),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            // Quantity Controls
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Check icon
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.check,
                    size: 14,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 24),
                // Quantity controls with proper touch targets
                Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _QuantityButton(
                        icon: Icons.remove,
                        onTap: () {
                          Provider.of<CartProvider>(context, listen: false)
                              .updateQuantity(productId, cartItem.quantity - 1);
                        },
                        colorScheme: colorScheme,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          '${cartItem.quantity}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                      _QuantityButton(
                        icon: Icons.add,
                        onTap: () {
                          Provider.of<CartProvider>(context, listen: false)
                              .updateQuantity(productId, cartItem.quantity + 1);
                        },
                        colorScheme: colorScheme,
                        isPrimary: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final ColorScheme colorScheme;
  final bool isPrimary;

  const _QuantityButton({
    required this.icon,
    required this.onTap,
    required this.colorScheme,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Icon(
            icon,
            size: 16,
            color: isPrimary
                ? colorScheme.primary
                : colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}
