import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class PredictHQService {
  static const String _baseUrl = 'https://api.predicthq.com/v1/events/';
  static const String _apiKey = 'HAdymEDZ0SJTAJng2Saz3d1sR8MugPPp8otevVxX';

  Future<List<Map<String, dynamic>>> getEvents({
    required LatLng location,
    double radius = 20, // km
    String? category,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = {
        'location_around.origin': '${location.latitude},${location.longitude}',
        'location_around.radius': '${radius}km',
        'sort': 'rank',
        'limit': '100',
      };

      if (category != null) {
        queryParams['category'] = category;
      }

      if (startDate != null) {
        queryParams['start.gte'] = startDate.toIso8601String();
      }

      if (endDate != null) {
        queryParams['start.lte'] = endDate.toIso8601String();
      }

      final response = await http.get(
        Uri.parse(_baseUrl).replace(queryParameters: queryParams),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['results']);
      } else {
        throw Exception('Failed to load events: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching events: $e');
      return [];
    }
  }

  String getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'concerts':
      case 'music':
        return '🎵';
      case 'sports':
        return '⚽';
      case 'conferences':
        return '🎤';
      case 'expos':
        return '🎪';
      case 'festivals':
        return '🎉';
      case 'performing-arts':
        return '🎭';
      default:
        return '📅';
    }
  }
} 