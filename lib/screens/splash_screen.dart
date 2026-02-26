import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Navigate to Home after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFB9DDEE), // light sky blue
              Color(0xFFFFFFFF), // white
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            // Logo
            Icon(
              Icons.radar,
              size: 80,
              color: Colors.white,
            ),

            SizedBox(height: 20),

            // App Name
            Text(
              "Sky Scope",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0A3D62),
                letterSpacing: 1.2,
              ),
            ),

            SizedBox(height: 12),

            // Tagline
            Text(
              "Weather made simple for student pilots",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF1E6091),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
