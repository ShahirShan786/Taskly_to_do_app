import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskly_to_do_app/core/providers/dashboard_provider.dart';

// ignore: constant_identifier_names

enum TaskStatus { Pending, Completed }

class TodoModel {
  final String id;
  final String title;
  final String description;
  final DateTime? dueDate;
  final TimeOfDay? dueTime;
  final Priority priority;
  final TaskStatus status;
  final String? username;

  TodoModel({
    required this.id,
    required this.title,
    required this.description,
    this.dueDate,
    this.dueTime,
    this.priority = Priority.Low,
    this.status = TaskStatus.Pending,
    this.username,
  });

  /// Create a copy with optional new values
  TodoModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    TimeOfDay? dueTime,
    Priority? priority,
    TaskStatus? status,
    String? username,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      dueTime: dueTime ?? this.dueTime,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      username: username ?? this.username,
    );
  }

  /// Convert model → Map (for Firebase)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate != null ? Timestamp.fromDate(dueDate!) : null,
      'dueTime': dueTime != null
          ? {'hour': dueTime!.hour, 'minute': dueTime!.minute}
          : null,
      'priority': priority.name,
      'status': status.name,
      'username': username,
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
      priority: TodoModel.priorityFromString(map['priority']),
      status: TodoModel.statusFromString(map['status']),
      username: map['username'],
    );
  }

  /// Convert string → Priority enum
  static Priority priorityFromString(String? value) {
    switch (value) {
      case 'High':
        return Priority.High;
      case 'Medium':
        return Priority.Medium;
      case 'Low':
      default:
        return Priority.Low;
    }
  }

  /// Convert string → TaskStatus enum
  static TaskStatus statusFromString(String? value) {
    switch (value) {
      case 'Completed':
        return TaskStatus.Completed;
      case 'Pending':
      default:
        return TaskStatus.Pending;
    }
  }
}











// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:taskly_to_do_app/core/providers/dashboard_provider.dart';

// class TodoModel {
//   final String id; // Firestore document ID
//   final String title;
//   final String description;
//   final DateTime? dueDate;
//   final TimeOfDay? dueTime;
//   final Priority priority;
//   final String? username;

//   TodoModel(
//       {required this.id,
//       required this.title, 
//       required this.description,
//       this.dueDate,
//       this.dueTime,
//       this.priority = Priority.Low,
//       this.username});

//   /// Convert model → Map (for Firebase)
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'title': title,
//       'description': description,
//       'dueDate': dueDate != null ? Timestamp.fromDate(dueDate!) : null,
//       'dueTime': dueTime != null
//           ? {'hour': dueTime!.hour, 'minute': dueTime!.minute}
//           : null,
//       'priority': priority.name, // stores as "high", "medium", "low"
//     };
//   }

//   /// Create model from Firebase snapshot
//   factory TodoModel.fromMap(Map<String, dynamic> map, String docId) {
//     return TodoModel(
//       id: docId,
//       title: map['title'] ?? '',
//       description: map['description'] ?? '',
//       dueDate: map['dueDate'] != null
//           ? (map['dueDate'] as Timestamp).toDate()
//           : null,
//       dueTime: map['dueTime'] != null
//           ? TimeOfDay(
//               hour: (map['dueTime']['hour'] as num).toInt(),
//               minute: (map['dueTime']['minute'] as num).toInt(),
//             )
//           : null,
//       priority: _priorityFromString(map['priority']),
//     );
//   }

//   /// Helper: convert string → Priority enum
//   static Priority _priorityFromString(String? value) {
//     switch (value) {
//       case 'High':
//         return Priority.High;
//       case 'Medium':
//         return Priority.Medium;
//       case 'Low':
//         return Priority.Low;
//       default:
//         return Priority.Low;
//     }
//   }
// }
