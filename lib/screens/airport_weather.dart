import 'package:flutter/material.dart';
import '../weather_service.dart';
import 'metar_decoder.dart';
import 'taf_decoder.dart';

class AirportWeatherScreen extends StatefulWidget {
  final String icao;
  final String airportName;

  const AirportWeatherScreen({
    super.key,
    required this.icao,
    required this.airportName,
  });

  @override
  State<AirportWeatherScreen> createState() => _AirportWeatherScreenState();
}

class _AirportWeatherScreenState extends State<AirportWeatherScreen> {
  Map<String, dynamic>? _metar;
  Map<String, dynamic>? _taf;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final metar = await WeatherService.fetchMetar(widget.icao);
      final taf = await WeatherService.fetchTaf(widget.icao);

      setState(() {
        _metar = metar;
        _taf = taf;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load weather data';
        _loading = false;
      });
    }
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
        title: Text(
          '${widget.airportName} - ${widget.icao}',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _fetchData,
          ),
        ],
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.green),
            )
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline,
                          color: Colors.red, size: 48),
                      const SizedBox(height: 12),
                      Text(_error!,
                          style: const TextStyle(color: Colors.white70)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchData,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// ===== CURRENT WEATHER =====
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
                              children: [
                                _WeatherStat(
                                  icon: Icons.air,
                                  label: 'Wind',
                                  value: _metar != null
                                      ? '${_metar!['wdir'] ?? '-'}°/${_metar!['wspd'] ?? '-'}kt'
                                      : '-',
                                ),
                                _WeatherStat(
                                  icon: Icons.visibility,
                                  label: 'Visibility',
                                  value: _metar != null
                                      ? '${_metar!['visib'] ?? '-'} sm'
                                      : '-',
                                ),
                                _WeatherStat(
                                  icon: Icons.cloud,
                                  label: 'Clouds',
                                  value: _metar != null &&
                                          _metar!['clouds'] != null &&
                                          (_metar!['clouds'] as List).isNotEmpty
                                      ? '${(_metar!['clouds'] as List)[0]['cover']}${(_metar!['clouds'] as List)[0]['base']}'
                                      : 'CLR',
                                ),
                                _WeatherStat(
                                  icon: Icons.thermostat,
                                  label: 'Temp/QNH',
                                  value: _metar != null
                                      ? '${_metar!['temp'] ?? '-'}°/${_metar!['altim'] ?? '-'}'
                                      : '-',
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _metar?['rawOb'] ?? 'No METAR data available',
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      /// ===== RAW METAR =====
                      const Text(
                        'Raw METAR',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A2B3C),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _metar?['rawOb'] ?? 'No data available',
                          style: const TextStyle(
                            color: Colors.green,
                            fontFamily: 'monospace',
                            fontSize: 13,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      /// ===== RAW TAF =====
                      const Text(
                        'Raw TAF',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A2B3C),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _taf?['rawTAF'] ?? 'No TAF data available',
                          style: const TextStyle(
                            color: Colors.blue,
                            fontFamily: 'monospace',
                            fontSize: 13,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      /// ===== ACTION BUTTONS =====
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _ActionButton(
                            label: 'Decode METAR',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => MetarDecoderScreen(
                                    rawMetar: _metar?['rawOb'],
                                  ),
                                ),
                              );
                            },
                          ),
                          _ActionButton(
                            label: 'Decode TAF',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => TafDecoderScreen(
                                    rawTaf: _taf?['rawTAF'],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
    );
  }
}

/// ===== WEATHER STAT =====
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

/// ===== ACTION BUTTON =====
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
