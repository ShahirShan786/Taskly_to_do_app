import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: constant_identifier_names
enum Priority { High, Medium, Low }
// Dash board Provider
final dashboardIndexProvider = StateProvider<int>((ref)=> 0);

// calender provider
final selectedDateProvider = StateProvider<DateTime?>((ref)=> DateTime.now());

// selected time provider
final selectedTimeProvider = StateProvider<TimeOfDay?>((ref)=> null);

// priority Provider
final selectedPriorityProvider = StateProvider<Priority?>((ref)=> null);