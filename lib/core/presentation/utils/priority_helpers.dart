import 'package:flutter/material.dart';
import 'package:taskly_to_do_app/core/providers/dashboard_provider.dart';
 // where Priority enum is

String getPriorityText(Priority? priority) {
  switch (priority) {
    case Priority.High:
      return "High";
    case Priority.Medium:
      return "Medium";
    case Priority.Low:
      return "Low";
    default:
      return "-";
  }
}

Color getPriorityColor(Priority? priority) {
  switch (priority) {
    case Priority.High:
      return Colors.red;
    case Priority.Medium:
      return Colors.orange;
    case Priority.Low:
      return Colors.green;
    default:
      return Colors.grey;
  }
}

IconData getPriorityIcon(Priority? priority) {
  switch (priority) {
    case Priority.High:
      return Icons.warning;
    case Priority.Medium:
      return Icons.hourglass_bottom;
    case Priority.Low:
      return Icons.check_box;
    default:
      return Icons.flag;
  }
}
