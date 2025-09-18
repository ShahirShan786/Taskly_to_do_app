import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:taskly_to_do_app/core/data/models/todo_model.dart';
import 'package:taskly_to_do_app/core/presentation/pages/home/widgets/priority_selector_widget.dart';

import 'package:taskly_to_do_app/core/presentation/utils/message_generator.dart';
import 'package:taskly_to_do_app/core/presentation/utils/priority_helpers.dart';

import 'package:taskly_to_do_app/core/presentation/utils/theme.dart';
import 'package:taskly_to_do_app/core/providers/dashboard_provider.dart';

import 'package:taskly_to_do_app/core/providers/provider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:taskly_to_do_app/core/providers/task_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _titleController.clear();
    _descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final String todayDate =
        DateFormat('EEE dd MMMM yyyy').format(DateTime.now());
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            spacing: 10.h,
            children: [
              SizedBox(
                height: 25.h,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(MessageGenerator.getMessage("Today"),
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium
                        ?.copyWith(fontWeight: FontWeight.bold, fontSize: 35)),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(MessageGenerator.getMessage(todayDate),
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall
                        ?.copyWith(fontWeight: FontWeight.w500, fontSize: 20)),
              ),
              TextField(
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Search Task",
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey[600],
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10))),
              ),
              SizedBox(
                height: 10.h,
              ),
              Expanded(
                child: ref.watch(taskNotifierProvider).when(
                      data: (tasks) => ListView.builder(
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          final formattedDate = task.dueDate != null
                              ? DateFormat('EEE, dd MMM yyyy')
                                  .format(task.dueDate!)
                              : "No date";

                          final formattedTime = task.dueTime != null
                              ? DateFormat('hh:mm a').format(
                                  DateTime(0, 1, 1, task.dueTime!.hour,
                                      task.dueTime!.minute),
                                )
                              : "No time";
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            child: Container(
                              width: double.infinity,
                              constraints: const BoxConstraints(minHeight: 180),
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(13.r)),
                              child: Column(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    decoration: BoxDecoration(
                                      color: getPriorityColor(task.priority),
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(13.r)),
                                    ),
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.flag_outlined,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              MessageGenerator.getLabel(
                                                  "${task.priority.name} Priority"),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                      color:
                                                          appColors.appWhite),
                                            ),
                                            Icon(
                                              getPriorityIcon(task.priority),
                                              color: Colors.yellow,
                                              size: 18.h,
                                            ),
                                          ],
                                        ),
                                        PopupMenuButton<String>(
                                          icon: Icon(
                                            Icons.more_horiz,
                                            size: 25.h,
                                          ),
                                          onSelected: (value) async {
                                            if (value == 'edit') {
                                              // handle edit
                                            } else if (value == 'delete') {
                                              final confirmed =
                                                  await showDialog<bool>(
                                                context: context,
                                                builder: (c) => AlertDialog(
                                                  title: const Text(
                                                      'Delete task?'),
                                                  content: const Text(
                                                      'This action cannot be undone.'),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                c, false),
                                                        child: const Text(
                                                            'Cancel')),
                                                    TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                c, true),
                                                        child: const Text(
                                                            'Delete')),
                                                  ],
                                                ),
                                              );

                                              if (confirmed == true) {
                                                try {
                                                  await ref
                                                      .read(taskNotifierProvider
                                                          .notifier)
                                                      .deleteTask(task.id);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(const SnackBar(
                                                          content: Text(
                                                              'Task deleted')));
                                                } catch (e) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                              'Delete failed: $e')));
                                                }
                                              }
                                            }
                                          },
                                          itemBuilder: (context) => [
                                            PopupMenuItem<String>(
                                              height: 5.h,
                                              value: 'edit',
                                              child: SizedBox(
                                                width: 80.w,
                                                height: 25.h,
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.edit,
                                                      size: 15.h,
                                                      color: appColors.appRed,
                                                    ),
                                                    SizedBox(
                                                        width: 8
                                                            .w), // 👈 instead of spacing
                                                    Text(
                                                      "Edit",
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            PopupMenuDivider(),
                                            PopupMenuItem<String>(
                                              height: 5.h,
                                              value: 'delete',
                                              child: SizedBox(
                                                width: 80.w,
                                                height: 25.h,
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.delete,
                                                      size: 15.h,
                                                      color: appColors.appRed,
                                                    ),
                                                    SizedBox(width: 8.w),
                                                    Text(
                                                      "Delete",
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 15),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              spacing: 10.w,
                                              children: [
                                                Container(
                                                  width: 22.h,
                                                  height: 22.h,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: appColors.appWhite,
                                                      border: Border.all(
                                                          color:
                                                              appColors.appRed,
                                                          width: 2)),
                                                  child: Center(
                                                    child: CircleAvatar(
                                                      radius: 4.r,
                                                      backgroundColor:
                                                          appColors.appRed,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                    MessageGenerator.getLabel(
                                                        task.title),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge
                                                        ?.copyWith(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                              ],
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20.w,
                                                  vertical: 4.h),
                                              decoration: BoxDecoration(
                                                  color: Colors.blueAccent,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: Text(
                                                  MessageGenerator.getLabel(
                                                      "To-Do"),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelLarge
                                                      ?.copyWith(fontSize: 16)),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(task.description,
                                              textAlign: TextAlign.left,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelMedium
                                                  ?.copyWith(
                                                      color: appColors
                                                          .customGray)),
                                        ),
                                        SizedBox(
                                          height: 8.h,
                                        ),
                                        Divider(
                                          color: Colors.grey[500],
                                          thickness: 1,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              spacing: 5.w,
                                              children: [
                                                Icon(
                                                  Icons.access_time,
                                                  size: 15.h,
                                                ),
                                                Text(formattedTime,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelMedium)
                                              ],
                                            ),
                                            Text(formattedDate,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelMedium
                                                    ?.copyWith(
                                                        color: appColors
                                                            .customGray,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w700))
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Center(child: Text("Error: $e")),
                    ),
              ),
            ],
          ),
        ),
        drawer: Drawer(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.white),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, size: 40, color: Colors.white),
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Shahir Mon KS",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "shahir@example.com",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const ListTile(
                leading: Icon(Icons.home, color: Colors.black),
                title: Text("Home"),
                onTap: null,
              ),
              const ListTile(
                leading: Icon(Icons.favorite, color: Colors.black),
                title: Text("Favorites"),
                onTap: null,
              ),
              const ListTile(
                leading: Icon(Icons.settings, color: Colors.black),
                title: Text("Settings"),
                onTap: null,
              ),
              const Spacer(),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title:
                    const Text("Logout", style: TextStyle(color: Colors.red)),
                onTap: () => showSignOutDialog(context, ref),
              ),
            ],
          ),
        ),
        floatingActionButton: SpeedDial(
          icon: Icons.close, // shows when open
          activeIcon: Icons.add,

          foregroundColor: appColors.appWhite, // shows when closed
          backgroundColor: appColors.appPrimay,

          overlayOpacity: 0, // no background dim
          spacing: 2.h,
          spaceBetweenChildren: 2.h,
          children: [
            SpeedDialChild(
                labelWidget: Container(
                  width: 95, // custom width
                  height: 45, // custom height
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: appColors.appPrimay,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "Add Todo",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                backgroundColor: appColors.appPrimay,
                shape: const RoundedRectangleBorder(),
                onTap: () => showCustomBottomSheet(context, _titleController,
                    _descriptionController, _formKey, ref)),
            SpeedDialChild(
              labelWidget: Container(
                width: 95, // custom width
                height: 45, // custom height
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: appColors.appPrimay,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "Add Note",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              backgroundColor: appColors.appPrimay,
              onTap: () => print("Add Note tapped"),
            ),
            SpeedDialChild(
              labelWidget: Container(
                width: 95, // custom width
                height: 45, // custom height
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: appColors.appPrimay,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "Add List",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              backgroundColor: appColors.appPrimay,
              onTap: () => print("Add Note tapped"),
            ),
            SpeedDialChild(
              labelWidget: Container(
                width: 115, // custom width
                height: 45, // custom height
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: appColors.appWhite,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: appColors.appPrimay, width: 1.5)),
                child: Text(
                  "Setup Habit",
                  style: TextStyle(color: appColors.appPrimay, fontSize: 16),
                ),
              ),
              backgroundColor: Colors.white,
              onTap: () => print("Add Note tapped"),
            ),
            SpeedDialChild(
              labelWidget: Container(
                width: 115, // custom width
                height: 45, // custom height
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: appColors.appWhite,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: appColors.appPrimay, width: 1.5)),
                child: Text(
                  "Setup Journal",
                  style: TextStyle(color: appColors.appPrimay, fontSize: 16),
                ),
              ),
              backgroundColor: Colors.white,
              onTap: () => print("Add Note tapped"),
            ),
          ],
        ),
      ),
    );
  }

  void showSignOutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: appColors.inputBgFill,
          title: const Text("Sign Out", style: TextStyle(color: Colors.white)),
          content: Text(
            "Are you sure you want to sign out?",
            style: TextStyle(color: Colors.grey[300]),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel", style: TextStyle(color: Colors.grey[400])),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog first
                _handleSignOut(context, ref); // Pass context explicitly
              },
              child: Text("Sign Out", style: TextStyle(color: Colors.red[400])),
            ),
          ],
        );
      },
    );
  }

  void _handleSignOut(BuildContext context, WidgetRef ref) async {
    try {
      // Sign out from Firebase
      await ref.read(authNotifierProvider.notifier).signOut();

      // Check if widget is still mounted before navigation
      if (!mounted) return;
      context.go('/login');
    } catch (e) {
      // Handle any errors during sign out
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error signing out: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void showCustomBottomSheet(
    BuildContext context,
    TextEditingController titleController,
    TextEditingController descriptionController,
    GlobalKey<FormState> formKey,
    WidgetRef ref,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                // bottom sheet wraps content
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: appColors.appPrimay,
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      MessageGenerator.getLabel("New Todo"),
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: appColors.appWhite),
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: titleController,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                        // filled: true,
                        // fillColor: Colors.grey[200],

                        hintText: " eg : Meeting with client",
                        hintStyle: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10))),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Titile is required";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                        hintText: " Description",
                        hintStyle: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10))),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Description is required";
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.calendar_month,
                              color: Colors.grey),
                          onPressed: () =>
                              showCalendarBottomSheet(context, ref),
                        ),
                        IconButton(
                          icon: const Icon(Icons.access_time_filled_sharp,
                              color: Colors.grey),
                          onPressed: () => pickDueTime(context, ref),
                        ),
                        const PrioritySelector(),
                        const Spacer(),
                        IconButton(
                          icon: Icon(Icons.send, color: appColors.appPrimay),
                          onPressed: () {
                            final isValid =
                                formKey.currentState?.validate() ?? false;
                            final duedate = ref.read(selectedDateProvider);
                            final dueTime = ref.read(selectedTimeProvider);
                            final priority = ref.read(selectedPriorityProvider);

                            if (!isValid) return;

                            if (duedate == null ||
                                dueTime == null ||
                                priority == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "Please select date, time & priority"),
                                ),
                              );
                              return;
                            }
                            Navigator.pop(context); // close bottom sheet
                            showPreviewDialog(context, ref, titleController,
                                descriptionController);
                            print("Todo Saved");
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

void showCalendarBottomSheet(BuildContext context, WidgetRef ref) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Consumer(
        builder: (context, ref, child) {
          final selectedDate = ref.watch(selectedDateProvider);
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.access_time, color: Colors.grey),
                    SizedBox(width: 8),
                    Text(
                      "Select Due Date",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Calendar
                TableCalendar(
                  firstDay: DateTime(2020),
                  lastDay: DateTime(2100),
                  focusedDay: selectedDate ?? DateTime.now(),
                  selectedDayPredicate: (day) =>
                      isSameDay(selectedDate, day), // highlight selected
                  onDaySelected: (selectedDay, focusedDay) {
                    ref.read(selectedDateProvider.notifier).state = selectedDay;
                  },
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                  calendarStyle: CalendarStyle(
                    isTodayHighlighted: false,
                    todayDecoration: BoxDecoration(
                      color: Colors.grey.shade300,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: appColors.appPrimay,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Back",
                            style: TextStyle(color: Colors.black)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: appColors.appPrimay,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          // close sheet and keep selected date in provider
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Next",
                          style: TextStyle(color: appColors.appWhite),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          );
        },
      );
    },
  );
}

Future<void> pickDueTime(BuildContext context, WidgetRef ref) async {
  final TimeOfDay initialTime =
      ref.read(selectedTimeProvider) ?? TimeOfDay.now();

  final TimeOfDay? pickedTime = await showTimePicker(
    context: context,
    initialTime: initialTime,
  );

  if (pickedTime != null) {
    ref.read(selectedTimeProvider.notifier).state = pickedTime;
  }
}

void showPreviewDialog(
    BuildContext context,
    WidgetRef ref,
    TextEditingController titleController,
    TextEditingController descriptionController) {
  final priority = ref.read(selectedPriorityProvider);
  final dueDate = ref.read(selectedDateProvider);
  final dueTime = ref.read(selectedTimeProvider);
  final title = titleController.text;
  final description = descriptionController.text;
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
                  Icon(Icons.assignment_outlined,
                      color: Colors.grey[700], size: 28),
                  const SizedBox(height: 8),
                  const Text(
                    "Preview",
                    style: TextStyle(
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
                      Text(
                        getPriorityText(priority),
                        style: TextStyle(
                          color: getPriorityColor(priority),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
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
                      final task = TodoModel(
                          id: ' ',
                          title: title,
                          description: description,
                          dueDate: dueDate,
                          dueTime: dueTime,
                          priority: priority!);
                      ref.read(taskNotifierProvider.notifier).addTask(task);
                      resetTaskInputs(
                          ref, titleController, descriptionController);
                    },
                    child: Text(
                      "Save",
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

void resetTaskInputs(
  WidgetRef ref,
  TextEditingController titleController,
  TextEditingController descriptionController,
) {
  titleController.clear();
  descriptionController.clear();

  ref.read(selectedDateProvider.notifier).state = null;
  ref.read(selectedTimeProvider.notifier).state = null;
  ref.read(selectedPriorityProvider.notifier).state = null;
}

Color getPriorityColor(Priority priority) {
  switch (priority) {
    case Priority.High:
      return appColors.appRed; // High → Red
    case Priority.Medium:
      return appColors.appYellow; // Medium → Yellow
    case Priority.Low:
      return appColors.appGreen; // Low → Green
  }
}

IconData getPriorityIcon(Priority priority) {
  switch (priority) {
    case Priority.High:
      return Icons.warning;
    case Priority.Medium:
      return Icons.hourglass_bottom;
    case Priority.Low:
      return Icons.check_box;
  }
}
