import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF1976D2);
  static const Color primaryDark = Color(0xFF1565C0);
  static const Color secondary = Color(0xFF26A69A);
  static const Color accent = Color(0xFFFF9800);
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Colors.white;
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFF57C00);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Color(0xFFBDBDBD);
}

class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle heading2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle heading3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle body1 = TextStyle(
    fontSize: 16,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle body2 = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
  );
  
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
  );
  
  static const TextStyle button = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}

class AppSizes {
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
}

class AppStrings {
  static const String appName = 'EduFinder';
  static const String searchHint = 'Search colleges, courses or exams';
  static const String greeting = 'Hello Ashish,';
  static const String greetingSubtitle = 'Here\'s a great personalized experience for you.';
  
  // Section Headers
  static const String topCollegesNearYou = 'Top Colleges Near You';
  static const String exploreCourses = 'Explore Courses';
  static const String topExams = 'Top Exams';
  static const String latestNews = 'Latest News & Stats';
  static const String compareColleges = 'Compare Colleges';
  static const String topSpecializations = 'Top Specializations';
  static const String topCollegesForStream = 'Top Colleges for a Stream';
  static const String collegeRankings = 'College Rankings';
  static const String topStudyPlaces = 'Top Study Places';
  
  // Course Types
  static const List<String> courseTypes = [
    'Engineering',
    'MBA',
    'Medical',
    'Arts',
    'Law',
    'Science',
    'Commerce',
  ];
  
  // Specializations
  static const List<String> specializations = [
    'Computer Science',
    'Mechanical Engineering',
    'Civil Engineering',
    'Electrical Engineering',
    'Information Technology',
  ];
  
  // Exams
  static const List<Map<String, dynamic>> exams = [
    {'name': 'JEE Main', 'icon': 'school'},
    {'name': 'NEET', 'icon': 'medical_services'},
    {'name': 'CAT', 'icon': 'business'},
    {'name': 'KCET', 'icon': 'school'},
    {'name': 'COMEDK', 'icon': 'school'},
  ];
  
  // Cities
  static const List<String> cities = [
    'Bangalore',
    'Delhi',
    'Mumbai',
    'Chennai',
  ];
} 