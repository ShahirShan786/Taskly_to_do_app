import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:taskly_to_do_app/core/providers/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, ref, child) {
          return Center(
            child: ElevatedButton(
              onPressed: () => handleSignOut(context, ref),
              child: const Text("Log Out"),
            ),
          );
        },
      ),
    );
  }
   void handleSignOut(BuildContext context, WidgetRef ref) async {
    try {
      // Sign out from Firebase
      await ref.read(authNotifierProvider.notifier).signOut();

      // Check if widget is still mounted before navigation
   
      // ignore: use_build_context_synchronously
      context.go('/login');
    } catch (e) {
      // Handle any errors during sign out
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error signing out: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
