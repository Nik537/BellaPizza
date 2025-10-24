// Slide to Order Widget - Custom Implementation
// NO EXTERNAL LIBRARIES - Pure Flutter/Dart implementation
//
// This widget creates a swipeable button that must be dragged to the end
// to confirm an action (like placing an order). It provides excellent UX
// by preventing accidental taps while giving satisfying visual feedback.
//
// USAGE IN FLUTTERFLOW:
// 1. Add this as a Custom Widget
// 2. Set the required parameters in FlutterFlow's UI
// 3. Connect the onOrderConfirmed callback to your order logic

import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Slide to Order Widget
/// A custom swipeable button that requires the user to slide to confirm an action
class SlideToOrderWidget extends StatefulWidget {
  /// Text to display in the slider
  final String text;

  /// Icon to show in the sliding button (use icon name like 'arrow_forward', 'shopping_cart', etc.)
  final String iconName;

  /// Callback when the slide is completed
  final Future Function() onOrderConfirmed;

  /// Width of the widget (null = full width)
  final double? width;

  /// Height of the widget
  final double height;

  /// Background color of the track
  final Color backgroundColor;

  /// Color of the sliding button
  final Color buttonColor;

  /// Text color
  final Color textColor;

  /// Icon color
  final Color iconColor;

  /// Border radius
  final double borderRadius;

  /// Whether the widget is enabled
  final bool enabled;

  /// Duration of the reset animation in milliseconds
  final int resetDurationMs;

  /// Haptic feedback enabled
  final bool hapticFeedback;

  const SlideToOrderWidget({
    super.key,
    this.text = 'Slide to Order',
    this.iconName = 'arrow_forward',
    required this.onOrderConfirmed,
    this.width,
    this.height = 52.0,
    this.backgroundColor = const Color(0xFFBD092A), // Primary red
    this.buttonColor = Colors.white,
    this.textColor = Colors.white,
    this.iconColor = const Color(0xFFBD092A),
    this.borderRadius = 120.0,
    this.enabled = true,
    this.resetDurationMs = 300,
    this.hapticFeedback = true,
  });

  @override
  State<SlideToOrderWidget> createState() => _SlideToOrderWidgetState();
}

class _SlideToOrderWidgetState extends State<SlideToOrderWidget>
    with SingleTickerProviderStateMixin {
  // Drag position (0.0 to 1.0)
  double _dragPosition = 0.0;

  // Whether the slide is completed
  bool _isCompleted = false;

  // Whether currently dragging
  bool _isDragging = false;

  // Animation controller for reset animation
  late AnimationController _resetController;
  late Animation<double> _resetAnimation;

  @override
  void initState() {
    super.initState();
    _resetController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.resetDurationMs),
    );

    _resetAnimation = Tween<double>(
      begin: 0.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _resetController,
        curve: Curves.easeOut,
      ),
    )..addListener(() {
        setState(() {
          _dragPosition = _resetAnimation.value;
        });
      });
  }

  @override
  void dispose() {
    _resetController.dispose();
    super.dispose();
  }

  /// Reset the slider to initial position
  void _reset() {
    _resetAnimation = Tween<double>(
      begin: _dragPosition,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _resetController,
        curve: Curves.easeOut,
      ),
    );

    _resetController
      ..reset()
      ..forward();

    setState(() {
      _isDragging = false;
      _isCompleted = false;
    });
  }

  /// Handle horizontal drag update
  void _onHorizontalDragUpdate(DragUpdateDetails details, double maxDragDistance) {
    if (!widget.enabled || _isCompleted) return;

    setState(() {
      _isDragging = true;
      // Calculate new position
      double newPosition = _dragPosition + (details.delta.dx / maxDragDistance);
      // Clamp between 0.0 and 1.0
      _dragPosition = math.max(0.0, math.min(1.0, newPosition));
    });
  }

  /// Handle drag end
  void _onHorizontalDragEnd(DragEndDetails details) {
    if (!widget.enabled || _isCompleted) return;

    // If dragged more than 85%, consider it complete
    if (_dragPosition >= 0.85) {
      setState(() {
        _dragPosition = 1.0;
        _isCompleted = true;
      });

      // Trigger haptic feedback if enabled
      if (widget.hapticFeedback) {
        // Note: For full haptic feedback support, you'd need to add
        // the flutter vibration plugin, but we're avoiding external dependencies
        // HapticFeedback.mediumImpact();
      }

      // Call the callback
      Future.delayed(const Duration(milliseconds: 100), () {
        widget.onOrderConfirmed();
      });
    } else {
      // Reset to start
      _reset();
    }
  }

  /// Convert icon name string to IconData
  IconData _getIconData(String name) {
    switch (name.toLowerCase()) {
      case 'arrow_forward':
        return Icons.arrow_forward;
      case 'shopping_cart':
        return Icons.shopping_cart;
      case 'shopping_bag':
        return Icons.shopping_bag;
      case 'check':
        return Icons.check;
      case 'arrow_right':
        return Icons.arrow_right;
      case 'arrow_right_alt':
        return Icons.arrow_right_alt;
      case 'chevron_right':
        return Icons.chevron_right;
      case 'send':
        return Icons.send;
      case 'done':
        return Icons.done;
      case 'double_arrow':
        return Icons.double_arrow;
      case 'east':
        return Icons.east;
      case 'navigate_next':
        return Icons.navigate_next;
      default:
        return Icons.arrow_forward;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate button size (slightly smaller than track height)
          final buttonSize = widget.height - 8.0;

          // Max distance the button can travel
          final maxDragDistance = constraints.maxWidth - buttonSize - 8.0;

          // Current button position
          final buttonPosition = 4.0 + (_dragPosition * maxDragDistance);

          // Calculate text opacity (fade out as button moves)
          final textOpacity = _isCompleted ? 0.0 : (1.0 - (_dragPosition * 1.5)).clamp(0.0, 1.0);

          return Stack(
            children: [
              // Background text
              Center(
                child: AnimatedOpacity(
                  opacity: textOpacity,
                  duration: const Duration(milliseconds: 150),
                  child: Text(
                    widget.text,
                    style: TextStyle(
                      color: widget.textColor,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),

              // Progress indicator (fill from left)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: buttonPosition + buttonSize,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            widget.buttonColor.withOpacity(0.1),
                            widget.buttonColor.withOpacity(0.05),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Sliding button
              AnimatedPositioned(
                duration: _isDragging
                    ? Duration.zero
                    : const Duration(milliseconds: 100),
                curve: Curves.easeOut,
                left: buttonPosition,
                top: 4.0,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) =>
                      _onHorizontalDragUpdate(details, maxDragDistance),
                  onHorizontalDragEnd: _onHorizontalDragEnd,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: buttonSize,
                    height: buttonSize,
                    decoration: BoxDecoration(
                      color: widget.buttonColor,
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          offset: const Offset(0, 2),
                          blurRadius: 8,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Center(
                      child: AnimatedRotation(
                        turns: _dragPosition * 0.5, // Rotate as it slides
                        duration: const Duration(milliseconds: 100),
                        child: Icon(
                          _isCompleted ? Icons.check : _getIconData(widget.iconName),
                          color: widget.iconColor,
                          size: 20.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Success checkmark overlay
              if (_isCompleted)
                Positioned.fill(
                  child: Center(
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 300),
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: Icon(
                            Icons.check_circle,
                            color: widget.buttonColor,
                            size: 32.0,
                          ),
                        );
                      },
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

/// Example usage:
///
/// SlideToOrderWidget(
///   text: 'Slide to Order',
///   iconName: 'arrow_forward',  // Use string instead of IconData
///   onOrderConfirmed: () {
///     // Handle order confirmation
///     print('Order confirmed!');
///   },
///   backgroundColor: Color(0xFFBD092A),
///   buttonColor: Colors.white,
///   textColor: Colors.white,
///   iconColor: Color(0xFFBD092A),
///   height: 52.0,
///   borderRadius: 120.0,
/// )
///
/// Available icon names:
/// - 'arrow_forward' (default)
/// - 'shopping_cart'
/// - 'shopping_bag'
/// - 'check'
/// - 'arrow_right'
/// - 'arrow_right_alt'
/// - 'chevron_right'
/// - 'send'
/// - 'done'
/// - 'double_arrow'
/// - 'east'
/// - 'navigate_next'
