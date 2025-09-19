 import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:taskly_to_do_app/core/data/models/todo_model.dart';
import 'package:taskly_to_do_app/core/presentation/pages/home/home_screen.dart';
import 'package:taskly_to_do_app/core/presentation/utils/theme.dart';
import 'package:taskly_to_do_app/core/providers/dashboard_provider.dart';
import 'package:taskly_to_do_app/core/providers/task_provider.dart';

void showEditPreviewDialog(
    BuildContext context,
    WidgetRef ref,
    TextEditingController titleController,
    TextEditingController descriptionController,
    {TodoModel? existingTask}) {
  
  final priority = ref.read(selectedPriorityProvider);
  final dueDate = ref.read(selectedDateProvider);
  final dueTime = ref.read(selectedTimeProvider);
  final title = titleController.text;
  final description = descriptionController.text;
  final isEditing = existingTask != null;
  
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        contentPadding: const EdgeInsets.all(20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Center(
              child: Column(
                children: [
                  Icon(
                    isEditing ? Icons.edit_outlined : Icons.assignment_outlined,
                    color: Colors.grey[700], 
                    size: 28
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isEditing ? "Update Task" : "Preview",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Priority
            Row(
              children: [
                const Icon(Icons.flag, size: 20, color: Colors.grey),
                const SizedBox(width: 12),
                const Text("Priority",
                    style: TextStyle(fontWeight: FontWeight.w500)),
                const Spacer(),
                if (priority != null)
                  Row(
                    children: [
                      Icon(
                        getPriorityIcon(priority),
                        color: getPriorityColor(priority),
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      // Text(
                      //   getPriorityText(priority),
                      //   style: TextStyle(
                      //     color: getPriorityColor(priority),
                      //     fontWeight: FontWeight.w500,
                      //   ),
                      // ),
                    ],
                  )
                else
                  const Text("-"),
              ],
            ),
            const SizedBox(height: 14),

            // Due Date
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 20, color: Colors.grey),
                const SizedBox(width: 12),
                const Text("Due Date",
                    style: TextStyle(fontWeight: FontWeight.w500)),
                const Spacer(),
                Text(
                  dueDate != null
                      ? DateFormat("dd MMM yyyy").format(dueDate)
                      : "-",
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Time
            Row(
              children: [
                const Icon(Icons.access_time, size: 20, color: Colors.grey),
                const SizedBox(width: 12),
                const Text("Time",
                    style: TextStyle(fontWeight: FontWeight.w500)),
                const Spacer(),
                Text(
                  dueTime != null
                      ? DateFormat.jm().format(
                          DateTime(0, 1, 1, dueTime.hour, dueTime.minute),
                        )
                      : "-",
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.grey[200],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Back"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appColors.appPrimay,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      
                      if (isEditing) {
                        // Update existing task
                        final updatedTask = TodoModel(
                          id: existingTask.id,
                          title: title,
                          description: description,
                          dueDate: dueDate,
                          dueTime: dueTime,
                          priority: priority!,
                        );
                        ref.read(taskNotifierProvider.notifier).updateTask(updatedTask , existingTask.id);
                      } else {
                        // Create new task
                        final task = TodoModel(
                          id: '',
                          title: title,
                          description: description,
                          dueDate: dueDate,
                          dueTime: dueTime,
                          priority: priority!,
                        );
                        ref.read(taskNotifierProvider.notifier).addTask(task);
                      }
                      
                      resetTaskInputs(ref, titleController, descriptionController);
                    },
                    child: Text(
                      isEditing ? "Update" : "Save",
                      style: TextStyle(color: appColors.appWhite),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    },
  );
}