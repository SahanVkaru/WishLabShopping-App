import 'dart:math';
import 'package:flutter/material.dart';
import '../utils/routes.dart';
import '../constants/app_styles.dart';
import '../widgets/glassmorphic_ripple_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  late AnimationController _staggerController;
  late AnimationController _orbController;

  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();

    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _orbController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    // Create staggered animations for 6 elements
    _fadeAnimations = List.generate(6, (index) {
      final start = index * 0.12;
      final end = (start + 0.35).clamp(0.0, 1.0);
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _staggerController,
          curve: Interval(start, end, curve: Curves.easeOutCubic),
        ),
      );
    });

    _slideAnimations = List.generate(6, (index) {
      final start = index * 0.12;
      final end = (start + 0.35).clamp(0.0, 1.0);
      return Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _staggerController,
          curve: Interval(start, end, curve: Curves.easeOutCubic),
        ),
      );
    });

    _staggerController.forward();
  }

  @override
  void dispose() {
    _staggerController.dispose();
    _orbController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }

  Widget _buildStaggeredChild(int index, Widget child) {
    return FadeTransition(
      opacity: _fadeAnimations[index],
      child: SlideTransition(
        position: _slideAnimations[index],
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Animated gradient orbs
          AnimatedBuilder(
            animation: _orbController,
            builder: (context, child) {
              return CustomPaint(
                painter: _OrbPainter(
                  progress: _orbController.value,
                  color1: colorScheme.primary.withValues(alpha: 0.15),
                  color2: colorScheme.secondary.withValues(alpha: 0.1),
                ),
                size: Size.infinite,
              );
            },
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppStyles.paddingLarge),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo
                    _buildStaggeredChild(
                      0,
                      Container(
                        width: 90,
                        height: 90,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              colorScheme.primary,
                              colorScheme.primary.withValues(alpha: 0.7),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.primary.withValues(alpha: 0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/Intro/logo.jpg',
                            width: 64,
                            height: 64,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => const Icon(
                              Icons.shopping_bag_rounded,
                              size: 44,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Title
                    _buildStaggeredChild(
                      1,
                      Text(
                        'Welcome Back',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildStaggeredChild(
                      1,
                      Text(
                        'Sign in to continue shopping',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Form
                    _buildStaggeredChild(
                      2,
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!value.contains('@')) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: Icon(
                                  Icons.lock_outline,
                                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Forgot password
                    _buildStaggeredChild(
                      3,
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Login button
                    _buildStaggeredChild(
                      4,
                      GlassmorphicRippleButton(
                        onPressed: _login,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        borderRadius: BorderRadius.circular(AppStyles.borderRadiusLarge),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Sign In',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward_rounded, size: 20),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Divider
                    _buildStaggeredChild(
                      5,
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: colorScheme.outline.withValues(alpha: 0.3),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'or continue with',
                              style: TextStyle(
                                color: colorScheme.onSurface.withValues(alpha: 0.4),
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: colorScheme.outline.withValues(alpha: 0.3),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Social login buttons
                    _buildStaggeredChild(
                      5,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _SocialButton(
                            icon: Icons.g_mobiledata_rounded,
                            label: 'Google',
                            onTap: () {},
                            colorScheme: colorScheme,
                            isDark: isDark,
                          ),
                          const SizedBox(width: 16),
                          _SocialButton(
                            icon: Icons.apple_rounded,
                            label: 'Apple',
                            onTap: () {},
                            colorScheme: colorScheme,
                            isDark: isDark,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Sign up link
                    _buildStaggeredChild(
                      5,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: TextStyle(
                              color: colorScheme.onSurface.withValues(alpha: 0.5),
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final ColorScheme colorScheme;
  final bool isDark;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.colorScheme,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.3),
              width: 1,
            ),
            boxShadow: isDark ? [] : AppStyles.subtleShadow,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 24, color: colorScheme.onSurface),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Paints animated gradient orbs in the background.
class _OrbPainter extends CustomPainter {
  final double progress;
  final Color color1;
  final Color color2;

  _OrbPainter({
    required this.progress,
    required this.color1,
    required this.color2,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = color1
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 80);

    final paint2 = Paint()
      ..color = color2
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 100);

    // Orb 1 - moves in a circle
    final x1 = size.width * 0.3 + cos(progress * 2 * pi) * size.width * 0.15;
    final y1 = size.height * 0.25 + sin(progress * 2 * pi) * size.height * 0.1;
    canvas.drawCircle(Offset(x1, y1), 120, paint1);

    // Orb 2 - moves in opposite direction
    final x2 =
        size.width * 0.7 + cos(progress * 2 * pi + pi) * size.width * 0.12;
    final y2 =
        size.height * 0.65 + sin(progress * 2 * pi + pi) * size.height * 0.08;
    canvas.drawCircle(Offset(x2, y2), 100, paint2);
  }

  @override
  bool shouldRepaint(covariant _OrbPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
