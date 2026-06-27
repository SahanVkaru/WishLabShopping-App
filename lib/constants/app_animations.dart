import 'package:flutter/material.dart';

/// Centralized animation constants for consistent motion throughout the app.
class AppAnimations {
  // ─── Durations ───
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 350);
  static const Duration slow = Duration(milliseconds: 600);
  static const Duration splash = Duration(milliseconds: 800);
  static const Duration pageTransition = Duration(milliseconds: 400);

  // ─── Curves ───
  static const Curve defaultCurve = Curves.easeOutQuart;
  static const Curve bounceCurve = Curves.elasticOut;
  static const Curve springCurve = Curves.easeOutBack;
  static const Curve enterCurve = Curves.easeOutCubic;
  static const Curve exitCurve = Curves.easeInCubic;

  // ─── Scale Values ───
  static const double pressedScale = 0.95;
  static const double hoverScale = 1.03;

  // ─── Stagger Delays ───
  static const Duration staggerDelay = Duration(milliseconds: 60);

  /// Creates a slide + fade page route transition.
  static Route<T> fadeSlideRoute<T>(Widget page, {RouteSettings? settings}) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: pageTransition,
      reverseTransitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: defaultCurve,
          reverseCurve: exitCurve,
        );
        return FadeTransition(
          opacity: curvedAnimation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.05),
              end: Offset.zero,
            ).animate(curvedAnimation),
            child: child,
          ),
        );
      },
    );
  }

  /// Creates a scale + fade page route transition (for detail pages).
  static Route<T> scaleRoute<T>(Widget page, {RouteSettings? settings}) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: pageTransition,
      reverseTransitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: defaultCurve,
          reverseCurve: exitCurve,
        );
        return FadeTransition(
          opacity: curvedAnimation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.92, end: 1.0).animate(curvedAnimation),
            child: child,
          ),
        );
      },
    );
  }
}
