import 'dart:convert';
import 'package:http/http.dart' as http;

class VPICApiService {
  final String baseUrl = 'https://vpic.nhtsa.dot.gov/api/vehicles';

  Future<List<Map<String, dynamic>>> getModelsForMake(String make) async {
    final url = Uri.parse('$baseUrl/GetModelsForMake/$make?format=json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['Results']);
    } else {
      throw Exception('Failed to fetch models: ${response.body}');
    }
  }

  Future<List<Map<String, dynamic>>> getVehicleTypesForMake(String make) async {
    final url = Uri.parse('$baseUrl/GetVehicleTypesForMake/$make?format=json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['Results']);
    } else {
      throw Exception('Failed to fetch vehicle types: ${response.body}');
    }
  }
}
