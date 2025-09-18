import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskly_to_do_app/core/providers/dashboard_provider.dart';

class PrioritySelector extends ConsumerWidget {
  const PrioritySelector({super.key});
  

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPriority = ref.watch(selectedPriorityProvider);

    return PopupMenuButton<Priority>(
      icon: Icon(
        Icons.flag,
        color: _getPriorityColor(selectedPriority),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 8,
      offset: const Offset(0, 50), 
      onSelected: (Priority priority) {
        ref.read(selectedPriorityProvider.notifier).state = priority;
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<Priority>(
          value: Priority.High,
          child: _buildPriorityItem(
            icon: Icons.warning,
            text: "High Priority",
            color: Colors.red,
          ),
        ),
        PopupMenuItem<Priority>(
          value: Priority.Medium,
          child: _buildPriorityItem(
            icon: Icons.hourglass_bottom,
            text: "Medium Priority",
            color: Colors.orange,
          ),
        ),
        PopupMenuItem<Priority>(
          value: Priority.Low,
          child: _buildPriorityItem(
            icon: Icons.check_box,
            text: "Low Priority",
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildPriorityItem({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Color _getPriorityColor(Priority? priority) {
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
}