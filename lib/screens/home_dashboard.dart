import 'package:flutter/material.dart';
import 'airport_weather.dart';
import 'smart_interpretation.dart';
import 'metar_decoder.dart';
import 'taf_decoder.dart';
import 'wind_calculator.dart';

// Mock airport data - replace with real API later
const List<Map<String, String>> kAirports = [
  {'name': 'Mumbai', 'icao': 'VABB'},
  {'name': 'Delhi', 'icao': 'VIDP'},
  {'name': 'Bangalore', 'icao': 'VOBL'},
  {'name': 'Chennai', 'icao': 'VOMM'},
  {'name': 'Hyderabad', 'icao': 'VOHS'},
  {'name': 'Kolkata', 'icao': 'VECC'},
  {'name': 'Pune', 'icao': 'VAPO'},
  {'name': 'Ahmedabad', 'icao': 'VAAH'},
];

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _filteredAirports = [];
  Map<String, String>? _selectedAirport;
  bool _showDropdown = false;
  int _currentNavIndex = 0;

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredAirports = [];
        _showDropdown = false;
      });
      return;
    }

    final results = kAirports.where((airport) {
      return airport['name']!.toLowerCase().contains(query.toLowerCase()) ||
          airport['icao']!.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      _filteredAirports = results;
      _showDropdown = results.isNotEmpty;
    });
  }

  void _selectAirport(Map<String, String> airport) {
    setState(() {
      _selectedAirport = airport;
      _showDropdown = false;
      _searchController.clear();
    });
  }

  Widget _buildSearchOnly() {
    return Column(
      children: [
        /// HEADER
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
          child: Row(
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

              /// SEARCH BAR
              Expanded(
                child: Container(
                  height: 38,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: _onSearchChanged,
                          style: const TextStyle(
                              fontSize: 13, color: Colors.black87),
                          decoration: const InputDecoration(
                            hintText: 'Search ICAO (e.g. VABB)',
                            hintStyle:
                                TextStyle(fontSize: 12, color: Colors.black45),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      const Icon(Icons.search, size: 18, color: Colors.black54),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        /// DROPDOWN RESULTS
        if (_showDropdown)
          Container(
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            decoration: BoxDecoration(
              color: const Color(0xFF1A2B3C),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white12),
            ),
            child: Column(
              children: _filteredAirports.map((airport) {
                return ListTile(
                  leading:
                      const Icon(Icons.flight_takeoff, color: Colors.white70),
                  title: Text(
                    '${airport['name']} / ${airport['icao']}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () => _selectAirport(airport),
                );
              }).toList(),
            ),
          ),

        /// EMPTY STATE
        if (!_showDropdown && _selectedAirport == null)
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.flight, color: Colors.white24, size: 64),
                  SizedBox(height: 16),
                  Text(
                    'Search for an airport\nto get started',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white38, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDashboard() {
    final airport = _selectedAirport!;
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// HEADER WITH SEARCH
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
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedAirport = null;
                          });
                        },
                        child: Container(
                          height: 34,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            children: [
                              Text(
                                '${airport['name']} / ${airport['icao']}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                              const Spacer(),
                              const Icon(Icons.search,
                                  size: 18, color: Colors.black54),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 22),

                /// CURRENT AIRPORT LABEL
                Row(
                  children: const [
                    Icon(Icons.flight_takeoff, color: Colors.white70, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Current Airport',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                /// AIRPORT CARD — navigates to AirportWeatherScreen with ICAO
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AirportWeatherScreen(
                          icao: _selectedAirport!['icao']!,
                          airportName: _selectedAirport!['name']!,
                        ),
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
                          children: [
                            Text(
                              '${airport['name']} / ${airport['icao']}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            const Icon(Icons.cloud, color: Colors.white70),
                            const SizedBox(width: 10),
                            const Icon(Icons.air, color: Colors.white70),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Tap to view live weather',
                          style: TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Click to load real data',
                          style: TextStyle(color: Colors.white38, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                /// GOOD FOR TRAINING BUTTON
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

                /// TRAINING CHECK LIST
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
                      _TrainingCheckItem(text: 'Visibility above VFR minimums'),
                      _TrainingCheckItem(text: 'No thunderstorms or CB clouds'),
                      _TrainingCheckItem(text: 'Suitable for circuit practice'),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                /// STUDENT SOLO LIMITS
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

        /// BOTTOM NAV
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
                onTap: () {
                  setState(() => _currentNavIndex = 0);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const MetarDecoderScreen()),
                  );
                },
                child: _BottomNavItem(
                    icon: Icons.text_snippet_outlined,
                    label: 'METAR',
                    active: _currentNavIndex == 0),
              ),
              GestureDetector(
                onTap: () {
                  setState(() => _currentNavIndex = 1);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TafDecoderScreen()),
                  );
                },
                child: _BottomNavItem(
                    icon: Icons.wb_sunny_outlined,
                    label: 'TAF',
                    active: _currentNavIndex == 1),
              ),
              GestureDetector(
                onTap: () {
                  setState(() => _currentNavIndex = 2);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const WindCalculatorScreen()),
                  );
                },
                child: _BottomNavItem(
                    icon: Icons.air,
                    label: 'Wind',
                    active: _currentNavIndex == 2),
              ),
              GestureDetector(
                onTap: () => setState(() => _currentNavIndex = 3),
                child: _BottomNavItem(
                    icon: Icons.person_outline,
                    label: 'Profile',
                    active: _currentNavIndex == 3),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1C2D),
      body: SafeArea(
        child:
            _selectedAirport == null ? _buildSearchOnly() : _buildDashboard(),
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
