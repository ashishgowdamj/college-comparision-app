import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/college.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.0.139:5001'; // Your computer's IP address

  // Get all colleges with pagination
  static Future<List<College>> getColleges({int page = 1, int limit = 20}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/colleges?page=$page&limit=$limit'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> collegesData = data['data'];
        
        return collegesData.map((json) => College.fromMap(json, json['id'])).toList();
      } else {
        throw Exception('Failed to load colleges: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load colleges: $e');
    }
  }

  // Get college by ID
  static Future<College> getCollegeById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/colleges/$id'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return College.fromMap(data, data['id']);
      } else {
        throw Exception('Failed to load college: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load college: $e');
    }
  }

  // Get all branches/courses
  static Future<List<String>> getBranches() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/branches'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> branchesData = data['data'];
        
        return branchesData.map((branch) => branch.toString()).toList();
      } else {
        throw Exception('Failed to load branches: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load branches: $e');
    }
  }

  // Search colleges with filters
  static Future<List<College>> searchColleges({
    String? branch,
    String? city,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
      };
      
      if (branch != null) queryParams['branch'] = branch;
      if (city != null) queryParams['city'] = city;

      final uri = Uri.parse('$baseUrl/colleges').replace(queryParameters: queryParams);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> collegesData = data['data'];
        
        return collegesData.map((json) => College.fromMap(json, json['id'])).toList();
      } else {
        throw Exception('Failed to search colleges: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to search colleges: $e');
    }
  }

  // Get trending colleges
  static Future<Map<String, List<College>>> getTrendingColleges() async {
    try {
      print('Making request to: $baseUrl/comparison/trending');
      final response = await http.get(
        Uri.parse('$baseUrl/comparison/trending'),
      ).timeout(Duration(seconds: 10));

      print('Response status: ${response.statusCode}');
      print('Response body length: ${response.body.length}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final Map<String, dynamic> trendingData = data['data'];
        
        print('Trending data keys: ${trendingData.keys}');
        print('Top ranked length: ${trendingData['topRanked']?.length}');
        
        final result = {
          'topRanked': (trendingData['topRanked'] as List)
              .map((json) => College.fromMap(json, json['id']))
              .toList(),
          'topRated': (trendingData['topRated'] as List)
              .map((json) => College.fromMap(json, json['id']))
              .toList(),
          'mostExpensive': (trendingData['mostExpensive'] as List)
              .map((json) => College.fromMap(json, json['id']))
              .toList(),
        };
        
        print('Successfully parsed trending data');
        return result;
      } else {
        print('HTTP Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load trending colleges: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getTrendingColleges: $e');
      throw Exception('Failed to load trending colleges: $e');
    }
  }

  // Get real-time dashboard data
  static Future<Map<String, dynamic>> getRealTimeDashboard() async {
    try {
      print('Making request to: $baseUrl/realtime/dashboard');
      final response = await http.get(
        Uri.parse('$baseUrl/realtime/dashboard'),
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['data'];
      } else {
        throw Exception('Failed to load real-time dashboard: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getRealTimeDashboard: $e');
      throw Exception('Failed to load real-time dashboard: $e');
    }
  }

  // Get real-time college data
  static Future<Map<String, dynamic>> getRealTimeCollegeData(String collegeName) async {
    try {
      print('Making request to: $baseUrl/realtime/college/$collegeName');
      final response = await http.get(
        Uri.parse('$baseUrl/realtime/college/$collegeName'),
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['data'];
      } else {
        throw Exception('Failed to load real-time college data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getRealTimeCollegeData: $e');
      throw Exception('Failed to load real-time college data: $e');
    }
  }

  // Get live NIRF rankings
  static Future<List<Map<String, dynamic>>> getLiveNIRFRankings() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/realtime/rankings/nirf'),
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['data']['rankings']);
      } else {
        throw Exception('Failed to load NIRF rankings: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getLiveNIRFRankings: $e');
      throw Exception('Failed to load NIRF rankings: $e');
    }
  }

  // Get live admission deadlines
  static Future<Map<String, dynamic>> getLiveAdmissionDeadlines() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/realtime/admissions/deadlines'),
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['data'];
      } else {
        throw Exception('Failed to load admission deadlines: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getLiveAdmissionDeadlines: $e');
      throw Exception('Failed to load admission deadlines: $e');
    }
  }

  // Get live news
  static Future<List<Map<String, dynamic>>> getLiveNews() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/realtime/news'),
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['data']['news']);
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getLiveNews: $e');
      throw Exception('Failed to load news: $e');
    }
  }

  // Compare colleges
  static Future<Map<String, dynamic>> compareColleges(List<String> collegeIds) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/comparison/compare'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'collegeIds': collegeIds}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['data'];
      } else {
        throw Exception('Failed to compare colleges: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to compare colleges: $e');
    }
  }

  // Get search statistics
  static Future<Map<String, dynamic>> getSearchStats() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/search/stats'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['data'];
      } else {
        throw Exception('Failed to load search stats: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load search stats: $e');
    }
  }
} 