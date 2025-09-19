import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:taskly_to_do_app/core/data/models/todo_model.dart';
import 'package:taskly_to_do_app/core/providers/dashboard_provider.dart';
import 'package:taskly_to_do_app/core/providers/task_provider.dart';

class EditTaskScreen extends ConsumerStatefulWidget {
  final TodoModel? task;
  const EditTaskScreen({Key? key, this.task}) : super(key: key);

  @override
  ConsumerState<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends ConsumerState<EditTaskScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  String selectedPriority = 'High';
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initializeTaskData();
  }

  void _initializeTaskData() {
    debugPrint("Editing task: ${widget.task?.title}");

    if (widget.task != null) {
      titleController.text = widget.task!.title;
      descriptionController.text = widget.task!.description;
      selectedPriority = widget.task!.priority.name;

      // Initialize date
      if (widget.task!.dueDate != null) {
        selectedDate = widget.task!.dueDate!;
        dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate!);
      }

      // Initialize time
      if (widget.task!.dueTime != null) {
        selectedTime = widget.task!.dueTime!;
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Set time controller text after context is available
    if (!_initialized && selectedTime != null) {
      timeController.text = selectedTime!.format(context);
      _initialized = true;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    dateController.dispose();
    timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.go("/home"),
        ),
        title: const Text(
          'Edit Task',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            /// Scrollable form fields
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    const Text(
                      'Title',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: titleController,
                      hint: 'Complete project proposal',
                    ),

                    const SizedBox(height: 24),

                    // Description
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: descriptionController,
                      hint:
                          'Review and finalize the quarterly project proposal including budget estimates and timeline.',
                      maxLines: 4,
                    ),

                    const SizedBox(height: 24),

                    // Date + Time
                    Row(
                      children: [
                        Expanded(
                          child: _buildDateField(context),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTimeField(context),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Priority
                    const Text(
                      'Priority',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildPriorityButton('High', Colors.red),
                        const SizedBox(width: 12),
                        _buildPriorityButton('Medium', Colors.orange),
                        const SizedBox(width: 12),
                        _buildPriorityButton('Low', Colors.green),
                      ],
                    ),

                    const SizedBox(
                        height: 100), // space so last field not hidden
                  ],
                ),
              ),
            ),

            /// Fixed bottom buttons
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      final updatedTask = widget.task!.copyWith(
                        title: titleController.text,
                        description: descriptionController.text,
                        dueDate: ref.read(selectedDateProvider),
                        dueTime: ref.read(selectedTimeProvider),
                        priority: ref.read(selectedPriorityProvider),
                      );
                      ref
                          .read(taskNotifierProvider.notifier)
                          .updateTask(updatedTask, widget.task!.id);
                      context.go('/home');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Task saved successfully!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Save Changes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Task'),
                          content: const Text(
                              'Are you sure you want to delete this task?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                              child: const Text('Delete',
                                  style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red, width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.delete_outline, color: Colors.red),
                        SizedBox(width: 8),
                        Text(
                          'Delete Task',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Reusable TextField
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400]),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blue),
        ),
      ),
    );
  }

  Widget _buildDateField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Due Date',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: dateController,
          decoration: InputDecoration(
            suffixIcon:
                const Icon(Icons.calendar_today_outlined, color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
          ),
          readOnly: true,
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2030),
            );
            if (date != null) {
              setState(() {
                selectedDate = date;
                dateController.text = DateFormat('dd/MM/yyyy').format(date);
              });

              // Update provider if needed
              ref.read(selectedDateProvider.notifier).state = date;
            }
          },
        ),
      ],
    );
  }

  Widget _buildTimeField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Due Time',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: timeController,
          decoration: InputDecoration(
            suffixIcon: const Icon(Icons.access_time, color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
          ),
          readOnly: true,
          onTap: () async {
            final time = await showTimePicker(
              context: context,
              initialTime: selectedTime ?? TimeOfDay.now(),
            );
            if (time != null) {
              setState(() {
                selectedTime = time;
                timeController.text = time.format(context);
              });

              // Update provider if needed
              ref.read(selectedTimeProvider.notifier).state = time;
            }
          },
        ),
      ],
    );
  }

  Widget _buildPriorityButton(String label, Color color) {
    bool isSelected = selectedPriority == label;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedPriority = label;
          });
          ref.read(selectedPriorityProvider.notifier).state = TodoModel.priorityFromString(label);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.1) : Colors.white,
            border: Border.all(
              color: isSelected ? color : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.circle, color: color, size: 12),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                  color: isSelected ? color : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
