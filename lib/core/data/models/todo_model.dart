import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskly_to_do_app/core/providers/dashboard_provider.dart';



class TodoModel {
  final String id;            // Firestore document ID
  final String title;
  final String description;
  final DateTime? dueDate;
  final TimeOfDay? dueTime;
  final Priority priority;
  final String? username;

  TodoModel({
    required this.id,
    required this.title,
    required this.description,
    this.dueDate,
    this.dueTime,
    this.priority = Priority.Low,
    this.username
  });

  /// Convert model → Map (for Firebase)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate != null
          ? Timestamp.fromDate(dueDate!)
          : null,
      'dueTime': dueTime != null
          ? {'hour': dueTime!.hour, 'minute': dueTime!.minute}
          : null,
      'priority': priority.name, // stores as "high", "medium", "low"
    };
  }

  /// Create model from Firebase snapshot
  factory TodoModel.fromMap(Map<String, dynamic> map, String docId) {
    return TodoModel(
      id: docId,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      dueDate: map['dueDate'] != null
          ? (map['dueDate'] as Timestamp).toDate()
          : null,
      dueTime: map['dueTime'] != null
          ? TimeOfDay(
               hour: (map['dueTime']['hour'] as num).toInt(),
            minute: (map['dueTime']['minute'] as num).toInt(),
            )
          : null,
      priority: _priorityFromString(map['priority']),
      
    );
  }

  /// Helper: convert string → Priority enum
  static Priority _priorityFromString(String? value) {
    switch (value) {
      case 'high':
        return Priority.High;
      case 'medium':
        return Priority.Medium;
      case 'low':
        return Priority.Low;
      default:
        return Priority.Low;
    }
  }
}
