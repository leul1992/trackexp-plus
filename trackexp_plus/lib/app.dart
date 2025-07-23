import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import 'features/auth/presentation/screens/login_screen.dart';
// import 'features/dashboard/presentation/screens/dashboard_screen.dart';

class TrackExpApp extends StatelessWidget {
  const TrackExpApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: '/login',
      routes: [
        GoRoute(
          path: '/login',
          // builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/handle_prompt',
          // builder: (context, state) => const HandlePromptScreen(),
        ),
        // GoRoute(
        //   path: '/dashboard',
        //   builder: (context, state) => const DashboardScreen(),
        // ),
        // Add routes for other screens (expense, settings, etc.) in later steps
      ],
      redirect: (context, state) async {
        // final hiveService = HiveService();
        // await hiveService.init();
        // final user = await hiveService.getUser(1); // Example ID
        // if (user == null && state.matchedLocation != '/login') {
        //   return '/login';
        // }
        return null;
      },
    );

    return MaterialApp.router(
      title: 'TrackExp+',
      // theme: AppTheme.lightTheme,
      // darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}