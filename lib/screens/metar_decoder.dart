import 'package:flutter/material.dart';

/// ===================== INDIAN AIRPORTS =====================
const Map<String, String> indianAirports = {
  'VIDP': 'Delhi – Indira Gandhi Intl',
  'VABB': 'Mumbai – Chhatrapati Shivaji Maharaj Intl',
  'VOBL': 'Bengaluru – Kempegowda Intl',
  'VOMM': 'Chennai Intl',
  'VECC': 'Kolkata – Netaji Subhas Chandra Bose Intl',
};

/// ===================== DATA MODEL =====================
class MetarData {
  String station = '';
  String stationName = 'Unknown Airport';
  String time = '';
  int windDir = -1;
  int windSpeed = 0;
  int windGust = 0;
  int visibility = 0;
  List<String> weather = [];
  String cloud = '';
  int temperature = 0;
  int dewPoint = 0;
  int qnh = 0;
}

/// ===================== METAR PARSER =====================
class MetarParser {
  static MetarData parse(String raw) {
    final data = MetarData();
    final tokens = raw.trim().split(RegExp(r'\s+'));

    for (final token in tokens) {
      if (token == 'METAR' ||
          token == 'SPECI' ||
          token == 'AUTO' ||
          token == 'NOSIG') {
        continue;
      }

      if (RegExp(r'^[A-Z]{4}$').hasMatch(token)) {
        data.station = token;
        data.stationName = indianAirports[token] ?? 'Unknown Airport';
      } else if (RegExp(r'^\d{6}Z$').hasMatch(token)) {
        data.time = token;
      } else if (RegExp(r'^(VRB|\d{3})\d{2}(G\d{2})?KT$').hasMatch(token)) {
        final windPart = token.replaceAll('KT', '');
        if (windPart.startsWith('VRB')) {
          data.windDir = -1;
          data.windSpeed = int.parse(windPart.substring(3, 5));
        } else {
          data.windDir = int.parse(windPart.substring(0, 3));
          data.windSpeed = int.parse(windPart.substring(3, 5));
        }
        if (windPart.contains('G')) {
          data.windGust = int.parse(windPart.split('G')[1]);
        }
      } else if (token == 'CAVOK') {
        data.visibility = 10000;
      } else if (RegExp(r'^\d{4}$').hasMatch(token)) {
        data.visibility = int.parse(token);
      } else if (RegExp(r'^[-+]?RA$').hasMatch(token) ||
          token == 'TS' ||
          token == 'FG' ||
          token == 'BR' ||
          token == 'FU') {
        data.weather.add(token);
      } else if (token.startsWith('FEW') ||
          token.startsWith('SCT') ||
          token.startsWith('BKN') ||
          token.startsWith('OVC') ||
          token == 'NSC') {
        data.cloud = token;
      } else if (RegExp(r'^M?\d{2}/M?\d{2}$').hasMatch(token)) {
        final parts = token.split('/');
        data.temperature = int.parse(parts[0].replaceAll('M', '-'));
        data.dewPoint = int.parse(parts[1].replaceAll('M', '-'));
      } else if (token.startsWith('Q')) {
        data.qnh = int.tryParse(token.substring(1)) ?? 0;
      }
    }

    return data;
  }
}

/// ===================== UI =====================
class MetarDecoderScreen extends StatefulWidget {
  final String? rawMetar; // optional — passed from AirportWeatherScreen

  const MetarDecoderScreen({super.key, this.rawMetar});

  @override
  State<MetarDecoderScreen> createState() => _MetarDecoderScreenState();
}

class _MetarDecoderScreenState extends State<MetarDecoderScreen> {
  final TextEditingController _controller = TextEditingController();
  MetarData? decoded;

  @override
  void initState() {
    super.initState();
    // If raw METAR was passed, auto fill and decode
    if (widget.rawMetar != null && widget.rawMetar!.isNotEmpty) {
      _controller.text = widget.rawMetar!;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        decodeMetar();
      });
    }
  }

  void decodeMetar() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      decoded = MetarParser.parse(_controller.text.trim());
    });
  }

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
        title:
            const Text('METAR Decoder', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// INPUT FIELD
            TextField(
              controller: _controller,
              maxLines: 2,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Paste METAR here',
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: const Color(0xFF1A2B3C),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.play_arrow, color: Colors.green),
                  onPressed: decodeMetar,
                ),
              ),
            ),

            const SizedBox(height: 20),

            if (decoded != null) ...[
              _sectionCard(
                icon: Icons.access_time,
                title: "Date & Time (UTC)",
                content:
                    "${decoded!.station} — ${decoded!.stationName}\nTime: ${decoded!.time}",
              ),
              _sectionCard(
                icon: Icons.air,
                title: "Wind",
                content: decoded!.windDir == -1
                    ? "Variable at ${decoded!.windSpeed} kt"
                    : "${decoded!.windDir}° at ${decoded!.windSpeed} kt"
                        "${decoded!.windGust > 0 ? ' (G${decoded!.windGust})' : ''}",
              ),
              _sectionCard(
                icon: Icons.visibility,
                title: "Visibility",
                content:
                    "${decoded!.visibility} meters (${(decoded!.visibility / 1000).toStringAsFixed(1)} km)",
                highlight: decoded!.visibility < 5000,
              ),
              _sectionCard(
                icon: Icons.cloud,
                title: "Weather Phenomenon",
                content: decoded!.weather.isEmpty
                    ? "No significant weather"
                    : decoded!.weather.join(", "),
              ),
              _sectionCard(
                icon: Icons.thermostat,
                title: "Temperature / Dew Point",
                content:
                    "${decoded!.temperature}°C / ${decoded!.dewPoint}°C\nQNH ${decoded!.qnh} hPa",
              ),
              _trainingCard(decoded!),
            ]
          ],
        ),
      ),
    );
  }

  Widget _sectionCard({
    required IconData icon,
    required String title,
    required String content,
    bool highlight = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF152636),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: highlight ? Colors.orange : Colors.white70),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Text(
                  content,
                  style: TextStyle(
                    color: highlight ? Colors.orange : Colors.white70,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _trainingCard(MetarData m) {
    bool notSuitable =
        m.visibility < 5000 || m.windSpeed > 15 || m.weather.contains('FG');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: notSuitable
            ? Colors.orange.withOpacity(0.2)
            : Colors.green.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        notSuitable
            ? "⚠ Final Training Interpretation\nNot suitable for student solo training.\nDual / IFR operations only."
            : "✅ Final Training Interpretation\nSuitable for student solo training.",
        style: TextStyle(
          color: notSuitable ? Colors.orange : Colors.green,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
