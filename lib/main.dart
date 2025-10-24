import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';

import 'constants/app_constants.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/pizzas_screen.dart';
import 'screens/pizza_details_screen.dart';
import 'screens/order_success_screen.dart';
import 'services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: Replace with your Supabase credentials
  await Supabase.initialize(
    url: 'https://etswbohasxwaqnbrhtfg.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImV0c3dib2hhc3h3YXFuYnJodGZnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjEzMDQ0MzgsImV4cCI6MjA3Njg4MDQzOH0.bfOzMMijyp5MyLH--r_QSJ_kP00P8tn2e5w05yOfa4w',
  );

  runApp(const CaldaPizzaApp());
}

class CaldaPizzaApp extends StatelessWidget {
  const CaldaPizzaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<SupabaseService>(
          create: (_) => SupabaseService(),
        ),
      ],
      child: MaterialApp(
        title: 'Calda Pizza',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignUpScreen(),
          '/pizzas': (context) => const PizzasScreen(),
          '/pizza-details': (context) => const PizzaDetailsScreen(),
          '/order-success': (context) => const OrderSuccessScreen(),
        },
      ),
    );
  }
}
