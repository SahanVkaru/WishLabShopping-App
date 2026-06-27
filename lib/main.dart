import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/wishlist_provider.dart';
import 'providers/order_provider.dart';

import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/wishlist_screen.dart';
import 'screens/checkout_screen.dart';

import 'models/product.dart';
import 'utils/routes.dart';
import 'constants/app_styles.dart';
import 'constants/app_animations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: const WishShopLabApp(),
    ),
  );
}

class WishShopLabApp extends StatelessWidget {
  const WishShopLabApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'WishShopLab',
          debugShowCheckedModeBanner: false,
          theme: AppStyles.lightTheme,
          darkTheme: AppStyles.darkTheme,
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          initialRoute: AppRoutes.splash,
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case AppRoutes.splash:
                return AppAnimations.fadeSlideRoute(
                  const SplashScreen(),
                  settings: settings,
                );
              case AppRoutes.onboarding:
                return AppAnimations.fadeSlideRoute(
                  const OnboardingScreen(),
                  settings: settings,
                );
              case AppRoutes.login:
                return AppAnimations.fadeSlideRoute(
                  const LoginScreen(),
                  settings: settings,
                );
              case AppRoutes.home:
                return AppAnimations.fadeSlideRoute(
                  const HomeScreen(),
                  settings: settings,
                );
              case AppRoutes.cart:
                return AppAnimations.fadeSlideRoute(
                  const CartScreen(),
                  settings: settings,
                );
              case AppRoutes.profile:
                return AppAnimations.fadeSlideRoute(
                  const ProfileScreen(),
                  settings: settings,
                );
              case AppRoutes.wishlist:
                return AppAnimations.fadeSlideRoute(
                  const WishlistScreen(),
                  settings: settings,
                );
              case AppRoutes.checkout:
                return AppAnimations.fadeSlideRoute(
                  const CheckoutScreen(),
                  settings: settings,
                );
              case AppRoutes.productDetail:
                if (settings.arguments is Product) {
                  final product = settings.arguments as Product;
                  return AppAnimations.scaleRoute(
                    ProductDetailScreen(product: product),
                    settings: settings,
                  );
                }
                return _errorRoute();
              default:
                return _errorRoute();
            }
          },
        );
      },
    );
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: const Center(child: Text('Page not found')),
        );
      },
    );
  }
}
