import 'package:flutter/material.dart';

// Splash
import 'screens/splash_screen.dart';

// Main App Screens
import 'screens/home_dashboard.dart';
import 'screens/metar_decoder.dart';
import 'screens/taf_decoder.dart';
import 'screens/smart_interpretation.dart';
import 'screens/wind_calculator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SkyScopeApp());
}

class SkyScopeApp extends StatelessWidget {
  const SkyScopeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sky Scope',
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Colors.transparent,
      ),

      /// App starts at Splash
      initialRoute: '/',

      routes: {
        /// Splash Screen
        '/': (context) => const SplashScreen(),

        /// Main Dashboard (After Splash)
        '/home': (context) => const HomeDashboard(),

        /// Decoders — open empty for manual input from home nav
        '/metar-decoder': (context) => const MetarDecoderScreen(),
        '/taf-decoder': (context) => const TafDecoderScreen(),

        /// Wind & Smart Logic
        '/wind-calculator': (context) => const WindCalculatorScreen(),
        '/smart-interpretation': (context) => const SmartInterpretationScreen(),
      },
    );
  }
}
