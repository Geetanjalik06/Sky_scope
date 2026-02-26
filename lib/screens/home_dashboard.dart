import 'package:flutter/material.dart';
import 'airport_weather.dart';
import 'smart_interpretation.dart';
import 'metar_decoder.dart';
import 'taf_decoder.dart';
import 'wind_calculator.dart';

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1C2D),
      body: SafeArea(
        child: Column(
          children: [
            /// ================= MAIN CONTENT =================
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// HEADER
                    Row(
                      children: [
                        const Text(
                          'Sky Scope',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          height: 34,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Row(
                            children: [
                              Text(
                                'Search ICAO (e.g. VABB)',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                              SizedBox(width: 6),
                              Icon(Icons.search, size: 18),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 22),

                    /// CURRENT AIRPORT
                    Row(
                      children: const [
                        Icon(Icons.flight_takeoff,
                            color: Colors.white70, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Current Airport',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    /// AIRPORT CARD
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AirportWeatherScreen(),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A2B3C),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Text(
                                  'Mumbai / VABB',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Spacer(),
                                Icon(Icons.cloud, color: Colors.white70),
                                SizedBox(width: 10),
                                Icon(Icons.air, color: Colors.white70),
                              ],
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Wind 120/10 kts, Vis 8 km, SCT030',
                              style: TextStyle(color: Colors.white70),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Last updated: 1 minute ago',
                              style: TextStyle(
                                color: Colors.white38,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    /// CTA
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SmartInterpretationScreen(),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle, color: Colors.white),
                            SizedBox(width: 10),
                            Text(
                              'Good for training',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(Icons.flight_takeoff, color: Colors.white),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// WHY IT’S GOOD
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF152636),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _TrainingCheckItem(
                              text: 'Wind within student solo limits'),
                          _TrainingCheckItem(
                              text: 'Visibility above VFR minimums'),
                          _TrainingCheckItem(
                              text: 'No thunderstorms or CB clouds'),
                          _TrainingCheckItem(
                              text: 'Suitable for circuit practice'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// TRAINING LIMITS
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF142A3A),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Student Solo Limits',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 12),
                          _LimitItem(label: 'Max wind', value: '15 kt'),
                          _LimitItem(label: 'Max crosswind', value: '7 kt'),
                          _LimitItem(label: 'Min visibility', value: '5 km'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// ================= BOTTOM NAV =================
            Container(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 14),
              decoration: const BoxDecoration(
                color: Color(0xFF0F2233),
                border: Border(top: BorderSide(color: Colors.white12)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const MetarDecoderScreen()),
                    ),
                    child: const _BottomNavItem(
                        icon: Icons.person, label: 'METAR'),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const TafDecoderScreen()),
                    ),
                    child: const _BottomNavItem(
                        icon: Icons.wb_sunny, label: 'TAF'),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const WindCalculatorScreen()),
                    ),
                    child: const _BottomNavItem(icon: Icons.air, label: 'Wind'),
                  ),
                  const _BottomNavItem(
                      icon: Icons.person_outline,
                      label: 'Profile',
                      active: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ================= SUPPORT WIDGETS =================

class _TrainingCheckItem extends StatelessWidget {
  final String text;
  const _TrainingCheckItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style: const TextStyle(color: Colors.white70, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}

class _LimitItem extends StatelessWidget {
  final String label;
  final String value;
  const _LimitItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(label,
                style: const TextStyle(color: Colors.white70, fontSize: 13)),
          ),
          const Icon(Icons.check_circle, color: Colors.green, size: 16),
          const SizedBox(width: 6),
          Text(value,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const _BottomNavItem(
      {required this.icon, required this.label, this.active = false});

  @override
  Widget build(BuildContext context) {
    final color = active ? Colors.green : Colors.white54;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 6),
        Text(label,
            style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: active ? FontWeight.w600 : FontWeight.normal)),
      ],
    );
  }
}
