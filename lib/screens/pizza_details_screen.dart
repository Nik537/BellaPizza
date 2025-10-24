import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../widgets/custom_widgets.dart';
import '../widgets/slide_to_order_widget.dart';
import '../services/supabase_service.dart';
import '../models/models.dart';

class PizzaDetailsScreen extends StatefulWidget {
  const PizzaDetailsScreen({super.key});

  @override
  State<PizzaDetailsScreen> createState() => _PizzaDetailsScreenState();
}

class _PizzaDetailsScreenState extends State<PizzaDetailsScreen> {
  PizzaSize _selectedSize = PizzaSize.medium;
  List<AddOn> _selectedAddOns = [];
  List<AddOn> _availableAddOns = [];
  bool _isLoadingAddOns = true;
  bool _isOrdering = false;

  @override
  void initState() {
    super.initState();
    _loadAddOns();
  }

  Future<void> _loadAddOns() async {
    try {
      final service = context.read<SupabaseService>();
      final addOns = await service.getAllAddOns();
      setState(() {
        _availableAddOns = addOns;
        _isLoadingAddOns = false;
      });
    } catch (e) {
      setState(() => _isLoadingAddOns = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load add-ons: $e')),
        );
      }
    }
  }

  int _calculateTotal(Pizza pizza) {
    int total = pizza.price;
    for (var addOn in _selectedAddOns) {
      total += addOn.price;
    }
    return total;
  }

  void _toggleAddOn(AddOn addOn) {
    setState(() {
      if (_selectedAddOns.contains(addOn)) {
        _selectedAddOns.remove(addOn);
      } else {
        _selectedAddOns.add(addOn);
      }
    });
  }

  Future<void> _createOrder(Pizza pizza) async {
    if (_isOrdering) return;
    
    setState(() => _isOrdering = true);

    try {
      final service = context.read<SupabaseService>();
      final order = await service.createOrder(
        pizzaName: pizza.name ?? 'Unknown',
        pizzaPrice: pizza.price,
        pizzaSize: _selectedSize.displayName,
        addOns: _selectedAddOns,
      );

      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          '/order-success',
          arguments: order,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Order failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isOrdering = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pizza = ModalRoute.of(context)!.settings.arguments as Pizza;

    return Scaffold(
      appBar: AppBar(
        title: Text(pizza.name ?? 'Pizza'),
        backgroundColor: AppColors.backgroundLight,
      ),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pizza Image
            if (pizza.hasImage)
              Container(
                width: double.infinity,
                height: 300,
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Image.network(
                  pizza.imageUrl!,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.local_pizza,
                      size: 150,
                      color: AppColors.divider,
                    );
                  },
                ),
              ),

            // Pizza Info
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pizza.name ?? 'Unknown Pizza',
                    style: AppTypography.h3,
                  ),
                  if (pizza.description != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      pizza.description!,
                      style: AppTypography.bodyMedium,
                    ),
                  ],
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    pizza.formattedPrice,
                    style: AppTypography.h5.copyWith(color: AppColors.primary),
                  ),
                ],
              ),
            ),

            // Size Selector
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Size', style: AppTypography.h5),
                  const SizedBox(height: AppSpacing.sm),
                  SizeSelectorTabs(
                    selectedSize: _selectedSize,
                    onSizeChanged: (size) => setState(() => _selectedSize = size),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Add-ons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Add-ons', style: AppTypography.h5),
                  const SizedBox(height: AppSpacing.sm),
                  if (_isLoadingAddOns)
                    const Center(child: CircularProgressIndicator())
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _availableAddOns.length,
                      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, index) {
                        final addOn = _availableAddOns[index];
                        return AddOnCard(
                          addOn: addOn,
                          isSelected: _selectedAddOns.contains(addOn),
                          onTap: () => _toggleAddOn(addOn),
                        );
                      },
                    ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Total Price
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total', style: AppTypography.h5),
                  Text(
                    '\$${(_calculateTotal(pizza) / 100).toStringAsFixed(2)}',
                    style: AppTypography.h5.copyWith(color: AppColors.primary),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Slide to Order Widget
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: SlideToOrderWidget(
                text: 'Slide to Order',
                onOrderConfirmed: () => _createOrder(pizza),
                enabled: !_isOrdering,
              ),
            ),

            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}
