import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Exact from Figma
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/splash_background.png',
              fit: BoxFit.cover,
            ),
          ),

          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  // Spacer to push content down
                  const Spacer(flex: 3),

                  // Bella Pizza Logo
                  // Logo dimensions from Figma: 273x257
                  SizedBox(
                    width: 273,
                    height: 257,
                    child: Center(
                      child: Image.asset(
                        'assets/images/bella_pizza_logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  const Spacer(flex: 2),

              // Tagline - Exact from Figma
              // Position: (24, 761), Size: 337x38
              // Font: Poppins 400, 14px, CENTER, rgba(33, 33, 33)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Get started with Bella Pizza. Experience a variety of choices and fast delivery to your doorstep.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textDark, // rgba(33, 33, 33)
                    height: 1.4,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Buttons - Exact from Figma
              // Position: (16, 816), Size: 357x110
              // Button 1: "Create account" - 357x50, bg rgba(189, 9, 42)
              // Button 2: "Login" - 357x50, spacing 10px
              SizedBox(
                width: 357,
                child: Column(
                  children: [
                    // Create Account Button (Primary - Red)
                    SizedBox(
                      width: 357,
                      height: 50, // Exact from Figma (not 52)
                      child: ElevatedButton(
                        onPressed: () => Navigator.pushNamed(context, '/signup'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary, // rgba(189, 9, 42)
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(120),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Create account',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10), // Exact spacing from Figma

                    // Login Button (Secondary - Outlined)
                    SizedBox(
                      width: 357,
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pushNamed(context, '/login'),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.textDark, // rgba(33, 33, 33)
                          side: BorderSide(
                            color: AppColors.textDark.withOpacity(0.2),
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(120),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textDark,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

                  const SizedBox(height: 20), // Bottom spacing
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
