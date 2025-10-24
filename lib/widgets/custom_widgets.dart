// Additional Custom Widgets for Calda Pizza Ordering App
// These widgets help achieve pixel-perfect UI matching the Figma design

import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../models/models.dart';

// ============================================================================
// PIZZA CARD WIDGET
// ============================================================================

/// Pizza Card Widget
/// Displays a pizza with image, name, and price
/// Size: 149x200 from Figma design
class PizzaCard extends StatelessWidget {
  final Pizza pizza;
  final VoidCallback onTap;
  final bool isSelected;

  const PizzaCard({
    super.key,
    required this.pizza,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppDimensions.pizzaCardWidth,
        height: AppDimensions.pizzaCardHeight,
        decoration: BoxDecoration(
          color: AppColors.backgroundLight,
          borderRadius: AppBorderRadius.roundedLg,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: isSelected
              ? [AppShadows.medium]
              : [AppShadows.light],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Pizza image
            if (pizza.hasImage)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.network(
                    pizza.imageUrl!,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.local_pizza,
                        size: 64,
                        color: AppColors.divider,
                      );
                    },
                  ),
                ),
              )
            else
              const Expanded(
                child: Icon(
                  Icons.local_pizza,
                  size: 64,
                  color: AppColors.divider,
                ),
              ),

            // Pizza details
            Container(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Pizza name
                  Text(
                    pizza.name ?? 'Unknown',
                    style: AppTypography.labelMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Pizza price
                  Text(
                    pizza.formattedPrice,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// ADD-ON CARD WIDGET
// ============================================================================

/// Add-On Selection Card
/// Displays an add-on with image, name, price, and selection state
class AddOnCard extends StatelessWidget {
  final AddOn addOn;
  final bool isSelected;
  final VoidCallback onTap;

  const AddOnCard({
    super.key,
    required this.addOn,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : AppColors.backgroundLight,
          borderRadius: AppBorderRadius.roundedLg,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Row(
          children: [
            // Add-on image
            Container(
              width: AppDimensions.addOnSize,
              height: AppDimensions.addOnSize,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: AppBorderRadius.roundedMd,
              ),
              child: ClipRRect(
                borderRadius: AppBorderRadius.roundedMd,
                child: Image.network(
                  addOn.imgUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.fastfood,
                      size: 20,
                      color: AppColors.divider,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Add-on details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    addOn.name,
                    style: AppTypography.labelMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    addOn.formattedPrice,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),

            // Selection indicator
            if (isSelected)
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  size: 16,
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// SIZE SELECTOR WIDGET
// ============================================================================

/// Pizza Size Selector Tabs
/// Allows selection between Small, Medium, Large
class SizeSelectorTabs extends StatelessWidget {
  final PizzaSize selectedSize;
  final ValueChanged<PizzaSize> onSizeChanged;

  const SizeSelectorTabs({
    super.key,
    required this.selectedSize,
    required this.onSizeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimensions.tabHeight,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: AppBorderRadius.roundedLg,
      ),
      child: Row(
        children: PizzaSize.values.map((size) {
          final isSelected = size == selectedSize;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSizeChanged(size),
              child: Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.backgroundLight
                      : Colors.transparent,
                  borderRadius: AppBorderRadius.roundedMd,
                  boxShadow: isSelected ? [AppShadows.light] : null,
                ),
                child: Center(
                  child: Text(
                    size.displayName,
                    style: AppTypography.labelMedium.copyWith(
                      color: isSelected
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ============================================================================
// PRIMARY BUTTON WIDGET
// ============================================================================

/// Primary Action Button
/// Red button with rounded corners matching design
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final double height;
  final IconData? icon;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.width,
    this.height = AppDimensions.buttonHeight,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textLight,
          shape: RoundedRectangleBorder(
            borderRadius: AppBorderRadius.circular,
          ),
          elevation: 0,
          disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: AppTypography.buttonText,
                  ),
                ],
              ),
      ),
    );
  }
}

// ============================================================================
// SECONDARY BUTTON WIDGET
// ============================================================================

/// Secondary Action Button
/// White/outlined button for secondary actions
class SecondaryButton extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final double? width;
  final double height;

  const SecondaryButton({
    super.key,
    this.text,
    this.icon,
    this.onPressed,
    this.width,
    this.height = AppDimensions.buttonHeight,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.backgroundLight,
          foregroundColor: AppColors.primary,
          side: BorderSide(
            color: AppColors.primary.withOpacity(0.1),
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppBorderRadius.circular,
          ),
          elevation: 0,
        ),
        child: icon != null && text == null
            ? Icon(icon, size: 20)
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    if (text != null) const SizedBox(width: 8),
                  ],
                  if (text != null)
                    Text(
                      text!,
                      style: AppTypography.buttonText.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}

// ============================================================================
// CUSTOM INPUT FIELD
// ============================================================================

/// Custom Text Input Field
/// Styled input field matching the Figma design
class CustomTextField extends StatelessWidget {
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final int maxLines;

  const CustomTextField({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.suffixIcon,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelMedium,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          maxLines: maxLines,
          style: AppTypography.bodyMedium,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: AppColors.backgroundLight,
            border: OutlineInputBorder(
              borderRadius: AppBorderRadius.roundedLg,
              borderSide: const BorderSide(color: AppColors.divider),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppBorderRadius.roundedLg,
              borderSide: const BorderSide(color: AppColors.divider),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppBorderRadius.roundedLg,
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: AppBorderRadius.roundedLg,
              borderSide: const BorderSide(color: Colors.red),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// ORDER SUCCESS ANIMATION
// ============================================================================

/// Order Success Widget
/// Displays a success checkmark with animation
class OrderSuccessAnimation extends StatefulWidget {
  final double size;

  const OrderSuccessAnimation({
    super.key,
    this.size = 100.0,
  });

  @override
  State<OrderSuccessAnimation> createState() => _OrderSuccessAnimationState();
}

class _OrderSuccessAnimationState extends State<OrderSuccessAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: AppColors.successLight,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.successMedium,
                width: 3,
              ),
            ),
            child: Icon(
              Icons.check,
              size: widget.size * 0.5,
              color: AppColors.primary,
            ),
          ),
        );
      },
    );
  }
}

// ============================================================================
// LOADING INDICATOR
// ============================================================================

/// Custom Loading Indicator
/// Shows a loading spinner with optional text
class LoadingIndicator extends StatelessWidget {
  final String? message;

  const LoadingIndicator({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
