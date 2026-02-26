import 'dart:math';
import 'package:flutter/material.dart';

class WindCalculatorScreen extends StatefulWidget {
  const WindCalculatorScreen({super.key});

  @override
  State<WindCalculatorScreen> createState() => _WindCalculatorScreenState();
}

class _WindCalculatorScreenState extends State<WindCalculatorScreen> {
  final TextEditingController runwayController = TextEditingController();
  final TextEditingController windDirController = TextEditingController();
  final TextEditingController windSpeedController = TextEditingController();

  double headwind = 0;
  double crosswind = 0;
  double tailwind = 0;

  bool isSafe = true;

  // ================= CALCULATION LOGIC (UNCHANGED) =================
  void calculate() {
    final runway = double.tryParse(runwayController.text) ?? 0;
    final windDir = double.tryParse(windDirController.text) ?? 0;
    final windSpeed = double.tryParse(windSpeedController.text) ?? 0;

    final runwayHeading = runway * 10;
    final angle = (windDir - runwayHeading) * pi / 180;

    headwind = windSpeed * cos(angle);
    crosswind = windSpeed * sin(angle);

    tailwind = headwind < 0 ? headwind.abs() : 0;
    headwind = headwind > 0 ? headwind : 0;

    isSafe = crosswind.abs() <= 7 && tailwind <= 5;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0B1C2D),
              Color(0xFF0E2438),
              Color(0xFF071522),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// HEADER
                Row(
                  children: const [
                    BackButton(color: Colors.white),
                    SizedBox(width: 12),
                    Text(
                      "Wind Component\nCalculator",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                /// INPUT CARD
                _glassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Input",
                        style: TextStyle(
                            color: Colors.white70, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                              child: _inputField(
                                  runwayController, "Runway (e.g. 09)")),
                          const SizedBox(width: 12),
                          Expanded(
                              child: _inputField(
                                  windDirController, "Wind Direction (°)")),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _inputField(windSpeedController, "Wind Speed (kts)"),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: calculate,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4CAF50),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                          child: const Text("Calculate"),
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                /// RESULTS CARD
                _glassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Results",
                        style: TextStyle(
                            color: Colors.white70, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _meter("Headwind", headwind),
                          _meter("Crosswind", crosswind.abs()),
                          _meter("Tailwind", tailwind),
                        ],
                      ),

                      const SizedBox(height: 25),

                      /// SAFE / UNSAFE STATUS
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSafe
                              ? const Color(0xFF4CAF50)
                              : Colors.redAccent,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          children: [
                            Text(
                              isSafe ? "✔ Safe" : "⚠ Unsafe",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isSafe
                                  ? "Conditions are within student pilot limits"
                                  : "Crosswind or tailwind exceeds student limits",
                              style: const TextStyle(color: Colors.white70),
                            )
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      /// RUNWAY ICON
                      Center(
                        child: Icon(
                          Icons.flight_takeoff,
                          size: 90,
                          color: Colors.white.withOpacity(0.2),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= NAVY CARD =================
  Widget _glassCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF142A3A), // Navy blue instead of gray
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: child,
    );
  }

  // ================= INPUT FIELD =================
  Widget _inputField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: const Color(0xFF1A3448), // Deep blue input
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _meter(String label, double value) {
    return Column(
      children: [
        SizedBox(
          width: 90,
          height: 90,
          child: CustomPaint(
            painter: GaugePainter(value),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "${value.toStringAsFixed(0)} kts",
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(color: Colors.white54)),
      ],
    );
  }
}

class GaugePainter extends CustomPainter {
  final double value;
  GaugePainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final base = Paint()
      ..color = const Color(0xFF1F3A4F) // Navy arc instead of gray
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawArc(rect, pi, pi, false, base);

    final needle = Paint()
      ..color = Colors.white
      ..strokeWidth = 3;

    final angle = pi + (value / 30) * pi;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final end = Offset(
      center.dx + radius * cos(angle),
      center.dy + radius * sin(angle),
    );

    canvas.drawLine(center, end, needle);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
