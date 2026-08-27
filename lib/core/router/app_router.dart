import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/farm_profile/presentation/farm_setup_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/ai_assistant/presentation/ai_assistant_screen.dart';
import '../../features/disease_detection/presentation/leaf_scanner_screen.dart';
import '../../features/weather/presentation/weather_screen.dart';
import '../../features/market_prices/presentation/market_prices_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../shared/widgets/app_bottom_nav.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/farm-setup',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const FarmSetupScreen(),
      ),
      GoRoute(
        path: '/profile',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ProfileScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => ScaffoldWithNavBar(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/ai-assistant',
            builder: (context, state) => const AiAssistantScreen(),
          ),
          GoRoute(
            path: '/disease-detection',
            builder: (context, state) => const LeafScannerScreen(),
          ),
          GoRoute(
            path: '/weather',
            builder: (context, state) => const WeatherScreen(),
          ),
          GoRoute(
            path: '/market-prices',
            builder: (context, state) => const MarketPricesScreen(),
          ),
        ],
      ),
    ],
  );
});
