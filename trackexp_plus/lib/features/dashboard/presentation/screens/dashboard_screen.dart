import 'package:flutter/material.dart';
import 'package:trackexp_plus/core/constants/colors.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Text(
          'Dashboard Screen (Placeholder)',
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
    );
  }
}
