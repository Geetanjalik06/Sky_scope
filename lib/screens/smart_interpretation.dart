import 'package:flutter/material.dart';

class SmartInterpretationScreen extends StatelessWidget {
  const SmartInterpretationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1C2D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1C2D),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Smart Interpretation',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ================= VERDICT CARD =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF66BB6A),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white, size: 34),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Text(
                      'Good for\ncircuit training',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white),
                    ),
                    child:
                        const Icon(Icons.flight_takeoff, color: Colors.white),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// ================= TRAINING MODES =================
            Row(
              children: const [
                _ModeCard(
                  title: 'Circuit training',
                  status: 'Allowed',
                  description: 'Cloud base is high',
                  color: Colors.green,
                ),
                SizedBox(width: 10),
                _ModeCard(
                  title: 'Solo flight',
                  status: 'Caution',
                  description: 'Wind gusts near limit',
                  color: Colors.orange,
                ),
                SizedBox(width: 10),
                _ModeCard(
                  title: 'Dual flight',
                  status: 'Allowed',
                  description: 'Instructor recommended',
                  color: Colors.green,
                ),
              ],
            ),

            const SizedBox(height: 24),

            /// ================= WEATHER REASONS =================
            const Text(
              'Weather-Based Reasons',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'The conditions are explained in simple English.',
              style: TextStyle(color: Colors.white70),
            ),

            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF152636),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _ReasonRow('Cloud base', '3000 ft SCT'),
                  _ReasonRow('Visibility', '8 km (Good)'),
                  _ReasonRow('Wind', '15 kts G25 kts'),
                  _ReasonRow('Trend', 'Visibility improving'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// ================= WHAT TO EXPECT =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A2B3C),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What to Expect Next',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Winds are expected to remain gusty for the next few hours. '
                    'Monitor conditions for changes.',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ================= TRAINING MODE CARD =================
class _ModeCard extends StatelessWidget {
  final String title;
  final String status;
  final String description;
  final Color color;

  const _ModeCard({
    required this.title,
    required this.status,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(
                  status == 'Allowed' ? Icons.check_circle : Icons.warning,
                  color: color,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  status,
                  style: TextStyle(color: color),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              description,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

/// ================= WEATHER REASON ROW =================
class _ReasonRow extends StatelessWidget {
  final String label;
  final String value;

  const _ReasonRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white70),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
