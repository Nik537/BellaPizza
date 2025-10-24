#!/bin/bash

# Create all 6 screen files for the Flutter app

echo "Creating screen files..."

# 1. Splash Screen
cat > lib/screens/splash_screen.dart << 'EOF'
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
EOF

# 2. Login Screen
cat > lib/screens/login_screen.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../widgets/custom_widgets.dart';
import '../services/supabase_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final service = context.read<SupabaseService>();
      await service.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/pizzas');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: AppColors.backgroundLight,
      ),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPaddingHorizontal),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              CustomTextField(
                label: 'Email',
                hintText: 'Enter your email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Email is required';
                  if (!v.contains('@')) return 'Invalid email';
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(
                label: 'Password',
                hintText: 'Enter your password',
                controller: _passwordController,
                obscureText: true,
                validator: (v) => v?.isEmpty ?? true ? 'Password is required' : null,
              ),
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(
                text: 'Login',
                onPressed: _handleLogin,
                isLoading: _isLoading,
              ),
              const SizedBox(height: AppSpacing.md),
              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/signup'),
                child: const Text("Don't have an account? Sign up"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
EOF

# 3. Signup Screen  
cat > lib/screens/signup_screen.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../widgets/custom_widgets.dart';
import '../services/supabase_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final service = context.read<SupabaseService>();
      await service.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        username: _usernameController.text.trim(),
      );

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/pizzas');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign up failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: AppColors.backgroundLight,
      ),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPaddingHorizontal),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              CustomTextField(
                label: 'Username',
                hintText: 'Choose a username',
                controller: _usernameController,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Username is required';
                  if (v.length < 3) return 'Username must be at least 3 characters';
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(
                label: 'Email',
                hintText: 'Enter your email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Email is required';
                  if (!v.contains('@')) return 'Invalid email';
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(
                label: 'Password',
                hintText: 'Create a password',
                controller: _passwordController,
                obscureText: true,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Password is required';
                  if (v.length < 6) return 'Password must be at least 6 characters';
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(
                text: 'Create Account',
                onPressed: _handleSignUp,
                isLoading: _isLoading,
              ),
              const SizedBox(height: AppSpacing.md),
              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                child: const Text('Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
EOF

echo "3 screens created (splash, login, signup)"
echo "Creating remaining 3 screens..."

