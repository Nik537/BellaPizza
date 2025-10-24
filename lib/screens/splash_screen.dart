import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../widgets/custom_widgets.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.local_pizza,
                size: 120,
                color: AppColors.primary,
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                'Calda Pizza',
                style: AppTypography.h1.copyWith(color: AppColors.primary),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Get started with Bella Pizza.\nExperience a variety of choices and\nfast delivery to your doorstep.',
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl * 2),
              PrimaryButton(
                text: 'Login',
                onPressed: () => Navigator.pushNamed(context, '/login'),
              ),
              const SizedBox(height: AppSpacing.md),
              SecondaryButton(
                text: 'Create Account',
                onPressed: () => Navigator.pushNamed(context, '/signup'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
