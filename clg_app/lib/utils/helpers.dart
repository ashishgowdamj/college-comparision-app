import 'package:flutter/material.dart';

class Helpers {
  // Format currency
  static String formatCurrency(int amount) {
    if (amount >= 100000) {
      return '₹${(amount / 100000).toStringAsFixed(1)}L';
    } else if (amount >= 1000) {
      return '₹${(amount / 1000).toStringAsFixed(1)}K';
    }
    return '₹$amount';
  }

  // Format rank
  static String formatRank(int rank) {
    if (rank == 1) return '1st';
    if (rank == 2) return '2nd';
    if (rank == 3) return '3rd';
    return '${rank}th';
  }

  // Get facility icon
  static IconData getFacilityIcon(String facility) {
    switch (facility.toLowerCase()) {
      case 'library':
        return Icons.library_books;
      case 'cafeteria':
        return Icons.restaurant;
      case 'hostel':
        return Icons.home;
      case 'sports complex':
        return Icons.sports_soccer;
      case 'gym':
        return Icons.fitness_center;
      case 'hospital':
        return Icons.local_hospital;
      case 'wifi':
        return Icons.wifi;
      case 'shuttle':
        return Icons.directions_bus;
      case 'auditorium':
        return Icons.event_seat;
      case 'music room':
        return Icons.music_note;
      case 'dance room':
        return Icons.music_note;
      case 'store':
        return Icons.store;
      case 'labs':
        return Icons.science;
      default:
        return Icons.check_circle;
    }
  }

  // Get exam icon
  static IconData getExamIcon(String examName) {
    switch (examName.toLowerCase()) {
      case 'jee main':
      case 'jee advanced':
      case 'kcet':
      case 'comedk':
        return Icons.school;
      case 'neet':
        return Icons.medical_services;
      case 'cat':
      case 'mat':
        return Icons.business;
      case 'clat':
        return Icons.gavel;
      default:
        return Icons.assignment;
    }
  }

  // Validate email
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Validate phone number
  static bool isValidPhone(String phone) {
    return RegExp(r'^[0-9]{10}$').hasMatch(phone);
  }

  // Show snackbar
  static void showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Show confirmation dialog
  static Future<bool> showConfirmationDialog(
    BuildContext context,
    String title,
    String message,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Confirm'),
          ),
        ],
      ),
    );
    return result ?? false;
  }
} 