import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../widgets/custom_widgets.dart';
import '../models/models.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final order = ModalRoute.of(context)!.settings.arguments as Order;

    return Scaffold(
      backgroundColor: AppColors.successLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const OrderSuccessAnimation(size: 150),
              const SizedBox(height: AppSpacing.xl),
              // Title - Figma: "Your order is confirmed!", Poppins 600, 24px
              const Text(
                'Your order is confirmed!',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              // Subtitle - Figma: "Now you can sit back and relax!", Poppins 300, 14px
              const Text(
                'Now you can sit back and relax!',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxl),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.backgroundLight,
                  borderRadius: AppBorderRadius.roundedLg,
                ),
                child: Column(
                  children: [
                    _buildDetailRow('Order ID', '#${order.id}'),
                    const Divider(),
                    _buildDetailRow('Pizza', order.pizzaName),
                    const Divider(),
                    _buildDetailRow('Size', order.pizzaSize ?? 'N/A'),
                    const Divider(),
                    _buildDetailRow('Total', order.formattedTotal, isTotal: true),
                  ],
                ),
              ),
              const Spacer(),
              PrimaryButton(
                text: 'Back home',
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/pizzas',
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal ? AppTypography.labelLarge : AppTypography.bodyMedium,
          ),
          Text(
            value,
            style: isTotal
                ? AppTypography.h5.copyWith(color: AppColors.primary)
                : AppTypography.labelMedium,
          ),
        ],
      ),
    );
  }
}
