import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:taskly_to_do_app/core/presentation/utils/message_generator.dart';
import 'package:taskly_to_do_app/core/presentation/utils/theme.dart';
import 'package:taskly_to_do_app/core/providers/provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
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
                child: Text(MessageGenerator.getMessage("Mon 20 March 2024"),
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall
                        ?.copyWith(fontWeight: FontWeight.w500, fontSize: 20)),
              ),
              TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green, width: 4),
                        borderRadius: BorderRadius.circular(10))),
              )
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
}
