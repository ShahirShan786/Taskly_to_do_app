import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    
    Timer(const Duration(seconds: 3), () {
      context.go("/onboard");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFFFFA04A),
            Color(0xFFFF6C0A),
            Color(0xFFFFA04A),
          ],
        ),
      ),
      child: Center(
        child: Image.asset("assets/images/splash_icon.png"),
      ),
    );
  }
}
