import 'package:flutter/material.dart';

/// ===================== MODELS =====================
class TafSection {
  String type;
  String timeWindow = '';
  int windDir = 0;
  int windSpeed = 0;
  int windGust = 0;
  int visibility = 0;
  List<String> weather = [];
  String cloud = '';
  bool hasCB = false;

  TafSection({required this.type});
}

class TafData {
  String station = '';
  String issueTime = '';
  String validity = '';
  List<TafSection> sections = [];
}

/// ===================== TAF PARSER =====================
class TafParser {
  static TafData parse(String raw) {
    final data = TafData();
    final tokens = raw.replaceAll('\n', ' ').split(' ');
    int i = 0;

    if (tokens[i] == 'TAF') i++;
    data.station = tokens[i++];
    data.issueTime = tokens[i++];
    data.validity = tokens[i++];

    TafSection current = TafSection(type: 'BASE');

    while (i < tokens.length) {
      final t = tokens[i];

      if (_isChangeGroup(t)) {
        data.sections.add(current);
        current = TafSection(type: t);
        i++;

        if (i < tokens.length && RegExp(r'\d{4}/\d{4}').hasMatch(tokens[i])) {
          current.timeWindow = tokens[i++];
        }
        continue;
      }

      _parseToken(t, current);
      i++;
    }

    data.sections.add(current);
    return data;
  }

  static bool _isChangeGroup(String t) =>
      t == 'TEMPO' || t == 'BECMG' || t.startsWith('FM');

  static void _parseToken(String t, TafSection s) {
    if (RegExp(r'\d{3}\d{2}(G\d{2})?KT').hasMatch(t)) {
      s.windDir = int.parse(t.substring(0, 3));
      s.windSpeed = int.parse(t.substring(3, 5));
      if (t.contains('G')) {
        s.windGust = int.parse(t.split('G')[1].replaceAll('KT', ''));
      }
      return;
    }

    if (RegExp(r'^\d{4}$').hasMatch(t)) {
      s.visibility = int.parse(t);
      return;
    }

    if (['RA', 'SHRA', '+SHRA', 'TS', 'BR', 'FG', 'NSW'].contains(t)) {
      s.weather.add(t);
      return;
    }

    if (t.startsWith('FEW') ||
        t.startsWith('SCT') ||
        t.startsWith('BKN') ||
        t.startsWith('OVC')) {
      s.cloud = t;
      if (t.contains('CB')) s.hasCB = true;
    }
  }
}

/// ===================== UI =====================
class TafDecoderScreen extends StatefulWidget {
  final String? rawTaf; // optional — passed from AirportWeatherScreen

  const TafDecoderScreen({super.key, this.rawTaf});

  @override
  State<TafDecoderScreen> createState() => _TafDecoderScreenState();
}

class _TafDecoderScreenState extends State<TafDecoderScreen> {
  final TextEditingController _controller = TextEditingController();
  TafData? taf;

  @override
  void initState() {
    super.initState();
    // If raw TAF was passed, auto fill and decode
    if (widget.rawTaf != null && widget.rawTaf!.isNotEmpty) {
      _controller.text = widget.rawTaf!;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        decodeTaf();
      });
    }
  }

  void decodeTaf() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      taf = TafParser.parse(_controller.text.trim());
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
        title: const Text('TAF Decoder', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// INPUT
            TextField(
              controller: _controller,
              maxLines: 4,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Paste or type TAF here',
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: const Color(0xFF1A2B3C),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.play_arrow, color: Colors.green),
                  onPressed: decodeTaf,
                ),
              ),
            ),

            const SizedBox(height: 20),

            if (taf != null) ...[
              _card(
                Icons.access_time,
                "Date & Validity (UTC)",
                "${taf!.station}\nIssued: ${taf!.issueTime}\nValid: ${taf!.validity}",
              ),
              const SizedBox(height: 16),
              ...taf!.sections.map((s) => Column(
                    children: [
                      _card(
                        Icons.air,
                        "${s.type} ${s.timeWindow}",
                        "Wind: ${s.windDir}° at ${s.windSpeed} kt"
                            "${s.windGust > 0 ? " (G${s.windGust})" : ""}",
                      ),
                      const SizedBox(height: 12),
                      _card(
                        Icons.visibility,
                        "Visibility",
                        "${s.visibility} meters",
                      ),
                      const SizedBox(height: 12),
                      _card(
                        Icons.cloud,
                        "Weather & Clouds",
                        "Weather: ${s.weather.isEmpty ? "No significant weather" : s.weather.join(", ")}\n"
                            "Clouds: ${s.cloud.isEmpty ? "Not specified" : s.cloud}"
                            "${s.hasCB ? " (CB present)" : ""}",
                      ),
                      const SizedBox(height: 20),
                    ],
                  )),
            ]
          ],
        ),
      ),
    );
  }

  Widget _card(IconData icon, String title, String content) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF152636),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white70),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Text(content,
                    style: const TextStyle(color: Colors.white70, height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
