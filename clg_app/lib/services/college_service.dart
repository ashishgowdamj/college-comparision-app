import '../models/college.dart';
import 'api_service.dart';

class CollegeService {
  // Get all colleges
  Future<List<College>> getColleges() async {
    return await ApiService.getColleges();
  }

  // Get colleges by type
  Future<List<College>> getCollegesByType(String type) async {
    // For now, get all colleges and filter by type
    // TODO: Add type filter to backend API
    final allColleges = await ApiService.getColleges();
    return allColleges.where((college) => college.type == type).toList();
  }

  // Get top colleges
  Future<List<College>> getTopColleges({int limit = 10}) async {
    final colleges = await ApiService.getColleges(limit: limit);
    return colleges.take(limit).toList();
  }

  // Search colleges
  Future<List<College>> searchColleges(String query) async {
    final allColleges = await ApiService.getColleges();
    
    if (query.isEmpty) return allColleges;

    final searchLower = query.toLowerCase();
    return allColleges.where((college) {
      return college.name.toLowerCase().contains(searchLower) ||
             college.city.toLowerCase().contains(searchLower) ||
             college.type.toLowerCase().contains(searchLower);
    }).toList();
  }

  // Get college by ID
  Future<College?> getCollegeById(String id) async {
    try {
      return await ApiService.getCollegeById(id);
    } catch (e) {
      return null;
    }
  }

  // Get branches/courses
  Future<List<String>> getBranches() async {
    return await ApiService.getBranches();
  }

  // Search colleges with filters
  Future<List<College>> searchCollegesWithFilters({
    String? branch,
    String? city,
    int page = 1,
    int limit = 20,
  }) async {
    return await ApiService.searchColleges(
      branch: branch,
      city: city,
      page: page,
      limit: limit,
    );
  }

  // TODO: Implement favorites functionality with backend
  // For now, these methods are placeholders
  Future<void> addToFavorites(String userId, String collegeId) async {
    // TODO: Implement with backend API
  }

  Future<void> removeFromFavorites(String userId, String collegeId) async {
    // TODO: Implement with backend API
  }

  Future<bool> isFavorited(String userId, String collegeId) async {
    // TODO: Implement with backend API
    return false;
  }

  Future<List<College>> getUserFavorites(String userId) async {
    // TODO: Implement with backend API
    return [];
  }
} 