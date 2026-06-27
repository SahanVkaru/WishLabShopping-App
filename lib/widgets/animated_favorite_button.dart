import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// An animated heart/favorite button with scale burst effect.
class AnimatedFavoriteButton extends StatefulWidget {
  final bool isFavorite;
  final VoidCallback onToggle;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;

  const AnimatedFavoriteButton({
    Key? key,
    required this.isFavorite,
    required this.onToggle,
    this.size = 20,
    this.activeColor,
    this.inactiveColor,
  }) : super(key: key);

  @override
  State<AnimatedFavoriteButton> createState() => _AnimatedFavoriteButtonState();
}

class _AnimatedFavoriteButtonState extends State<AnimatedFavoriteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.4).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.4, end: 1.0).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 50,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    HapticFeedback.lightImpact();
    _controller.forward(from: 0);
    widget.onToggle();
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = widget.activeColor ?? Theme.of(context).colorScheme.primary;
    final inactiveColor = widget.inactiveColor ??
        Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3);

    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: Icon(
            widget.isFavorite ? Icons.favorite : Icons.favorite_border,
            key: ValueKey(widget.isFavorite),
            color: widget.isFavorite ? activeColor : inactiveColor,
            size: widget.size,
          ),
        ),
      ),
    );
  }
}
