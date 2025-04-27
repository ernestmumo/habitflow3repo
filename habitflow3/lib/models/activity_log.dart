import 'package:flutter/material.dart';

class ActivityLog {
  final String id;
  final String description;
  final DateTime timestamp;
  final IconData icon;

  ActivityLog({
    required this.id,
    required this.description,
    required this.timestamp,
    required this.icon,
  });
}