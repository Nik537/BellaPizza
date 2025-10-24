import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../widgets/custom_widgets.dart';
import '../services/supabase_service.dart';
import '../models/models.dart';

class PizzasScreen extends StatelessWidget {
  const PizzasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = context.read<SupabaseService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pizzas'),
        backgroundColor: AppColors.backgroundLight,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.confirmation_number),
            onPressed: () {
              // TODO: Orders history
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await service.signOut();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/');
              }
            },
          ),
        ],
      ),
      backgroundColor: AppColors.background,
      body: FutureBuilder<List<Pizza>>(
        future: service.getAllPizzas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingIndicator(message: 'Loading pizzas...');
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final pizzas = snapshot.data ?? [];

          if (pizzas.isEmpty) {
            return const Center(
              child: Text('No pizzas available'),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 149 / 200,
              crossAxisSpacing: AppSpacing.gridSpacing,
              mainAxisSpacing: AppSpacing.gridSpacing,
            ),
            itemCount: pizzas.length,
            itemBuilder: (context, index) {
              final pizza = pizzas[index];
              return PizzaCard(
                pizza: pizza,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/pizza-details',
                    arguments: pizza,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
