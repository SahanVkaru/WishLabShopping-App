import 'dart:ui';
import 'package:flutter/material.dart';

class GlassmorphicRippleButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry borderRadius;

  const GlassmorphicRippleButton({
    super.key,
    required this.child,
    this.onPressed,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
  });

  @override
  State<GlassmorphicRippleButton> createState() =>
      _GlassmorphicRippleButtonState();
}

class _GlassmorphicRippleButtonState extends State<GlassmorphicRippleButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    // Determine the current scale based on interaction state
    final double scale = _isPressed ? 0.95 : (_isHovered ? 1.05 : 1.0);
    
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;

    final Color textColor = _isHovered
        ? Colors.white
        : (isDark ? Colors.white.withValues(alpha: 0.8) : Colors.black.withValues(alpha: 0.7));

    return AnimatedScale(
      scale: scale,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: widget.borderRadius,
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.4),
                    blurRadius: 15,
                    spreadRadius: 2,
                    offset: const Offset(0, 5),
                  )
                ]
              : [],
        ),
        child: ClipRRect(
          borderRadius: widget.borderRadius,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Base Glass background
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.1)
                          : Colors.white.withValues(alpha: 0.4),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.15)
                            : Colors.white.withValues(alpha: 0.6),
                        width: 1,
                      ),
                      borderRadius: widget.borderRadius,
                    ),
                  ),
                ),
                
                // Hover Gradient Overlay (uses primary gradient)
                Positioned.fill(
                  child: AnimatedOpacity(
                    opacity: _isHovered ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            colorScheme.primary,
                            colorScheme.secondary,
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: widget.borderRadius,
                      ),
                    ),
                  ),
                ),
                
                // Material with InkWell for built-in ripple effect
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: widget.onPressed,
                    onHover: (value) => setState(() => _isHovered = value),
                    onHighlightChanged: (value) => setState(() => _isPressed = value),
                    splashColor: Colors.white.withValues(alpha: 0.4),
                    highlightColor: Colors.transparent,
                    borderRadius: widget.borderRadius as BorderRadius,
                    child: Padding(
                      padding: widget.padding,
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        child: widget.child,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
