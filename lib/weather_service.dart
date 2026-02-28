import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String _baseUrl = 'https://aviationweather.gov/api/data';

  // Fetch METAR data
  static Future<Map<String, dynamic>?> fetchMetar(String icao) async {
    try {
      final url = Uri.parse('$_baseUrl/metar?ids=$icao&format=json');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        if (data.isNotEmpty) return data[0];
      }
    } catch (e) {
      print('METAR error: $e');
    }
    return null;
  }

  // Fetch TAF data
  static Future<Map<String, dynamic>?> fetchTaf(String icao) async {
    try {
      final url = Uri.parse('$_baseUrl/taf?ids=$icao&format=json');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        if (data.isNotEmpty) return data[0];
      }
    } catch (e) {
      print('TAF error: $e');
    }
    return null;
  }
}
