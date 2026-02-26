import 'package:flutter/material.dart';

class AirportWeatherScreen extends StatelessWidget {
  const AirportWeatherScreen({super.key});

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
          'Mumbai - VABB',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.refresh, color: Colors.white),
              SizedBox(height: 2),
              Text(
                'Last updated: 2 min ago',
                style: TextStyle(fontSize: 10, color: Colors.white54),
              ),
            ],
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ================= CURRENT WEATHER =================
            const Text(
              'Current Weather',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A2B3C),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      _WeatherStat(
                        icon: Icons.wb_sunny,
                        label: 'Wind',
                        value: '120\n120/10kts',
                      ),
                      _WeatherStat(
                        icon: Icons.visibility,
                        label: 'Visibility',
                        value: '8km',
                      ),
                      _WeatherStat(
                        icon: Icons.cloud,
                        label: 'Clouds',
                        value: 'SCT030',
                      ),
                      _WeatherStat(
                        icon: Icons.thermostat,
                        label: 'Temp/QNH',
                        value: '28°C/1012',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Clear skies with light wind from the East. Good visibility.',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// ================= FORECAST =================
            const Text(
              'Forecast',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: const [
                _ForecastCard(
                  title: 'FM 1000Z',
                  description: 'Wind 120/10kts, Vis >8km\nNSW',
                  status: ForecastStatus.good,
                ),
                SizedBox(width: 10),
                _ForecastCard(
                  title: 'TEMPO 1400Z',
                  description: 'Wind 140/15G25KT,\nTSRA',
                  status: ForecastStatus.warning,
                ),
                SizedBox(width: 10),
                _ForecastCard(
                  title: 'Visibility Deterioration',
                  description: 'Wind 160/12KT,\n2km BRA',
                  status: ForecastStatus.danger,
                ),
              ],
            ),

            const SizedBox(height: 24),

            /// ================= ACTION BUTTONS =================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ActionButton(
                  label: 'Decode METAR',
                  onTap: () {},
                ),
                _ActionButton(
                  label: 'Decode TAF',
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 24),

            /// ================= RAW SECTIONS =================
            _ExpandableSection(title: 'Raw METAR'),
            const SizedBox(height: 8),
            _ExpandableSection(title: 'Raw TAF'),
          ],
        ),
      ),
    );
  }
}

/// ================= WEATHER STAT =================
class _WeatherStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _WeatherStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(color: Colors.white54)),
        const SizedBox(height: 4),
        Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}

/// ================= FORECAST CARD =================
enum ForecastStatus { good, warning, danger }

class _ForecastCard extends StatelessWidget {
  final String title;
  final String description;
  final ForecastStatus status;

  const _ForecastCard({
    required this.title,
    required this.description,
    required this.status,
  });

  Color get bgColor {
    switch (status) {
      case ForecastStatus.good:
        return const Color(0xFFE8F5E9);
      case ForecastStatus.warning:
        return const Color(0xFFFFF3E0);
      case ForecastStatus.danger:
        return const Color(0xFFFFEBEE);
    }
  }

  Color get textColor {
    switch (status) {
      case ForecastStatus.good:
        return Colors.green;
      case ForecastStatus.warning:
        return Colors.orange;
      case ForecastStatus.danger:
        return Colors.red;
    }
  }

  IconData get icon {
    switch (status) {
      case ForecastStatus.good:
        return Icons.check_circle;
      case ForecastStatus.warning:
        return Icons.flash_on;
      case ForecastStatus.danger:
        return Icons.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: textColor, size: 18),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(color: textColor, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

/// ================= ACTION BUTTON =================
class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _ActionButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.white30),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}

/// ================= EXPANDABLE SECTION =================
class _ExpandableSection extends StatelessWidget {
  final String title;

  const _ExpandableSection({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2B3C),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Icon(Icons.expand_more, color: Colors.white70),
        ],
      ),
    );
  }
}
