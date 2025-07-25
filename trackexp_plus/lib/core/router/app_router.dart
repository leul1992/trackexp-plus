import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trackexp_plus/features/auth/presentation/screens/login_screen.dart';
import 'package:trackexp_plus/features/dashboard/presentation/screens/dashboard_screen.dart';


class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      // Placeholder routes for other features
      GoRoute(
        path: '/handle',
        builder: (context, state) => const Placeholder(), // HandleSetupScreen
      ),
      GoRoute(
        path: '/add-expense',
        builder: (context, state) => const Placeholder(), // AddExpenseScreen
      ),
    ],
  );
}
