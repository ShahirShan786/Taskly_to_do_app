import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  Future<void> _completeOnboarding(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
   if (!context.mounted) return; 
   context.go("/login");
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      globalBackgroundColor: Colors.white,
      pages: [
        PageViewModel(
          title: "📌 Stay Organized & Focused",
          body:
              "Easily create, manage, and prioritize your\ntasks to stay on top of your day.",
          image: Image.asset(
            "assets/lottie/onboard_one.jpg",
            height: 250, // control size
          ),
          decoration: const PageDecoration(
            pageColor: Colors.white,

            imageFlex: 3, // take less vertical space for the image
            bodyFlex: 2, // push text slightly down
            titleTextStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            bodyTextStyle: TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
        ),
        PageViewModel(
          title: "⌛ Never Miss a Deadline",
          body:
              "Set reminders and due dates to keep track\nof important tasks effortlessly.",
          image: Image.asset(
            "assets/lottie/onboard_one.jpg",
            height: 250, // control size
          ),
          decoration: const PageDecoration(
            pageColor: Colors.white,

            imageFlex: 3, // take less vertical space for the image
            bodyFlex: 2, // push text slightly down
            titleTextStyle: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
            bodyTextStyle: TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
        ),
        PageViewModel(
          title: "✅ Boost Productivity",
          body:
              "Break tasks into steps, track progress, and\nget more done with ease.",
          image: Image.asset(
            "assets/lottie/onboard_one.jpg",
            height: 250, // control size
          ),
          decoration: const PageDecoration(
            pageColor: Colors.white,

            imageFlex: 3, // take less vertical space for the image
            bodyFlex: 2, // push text slightly down
            titleTextStyle: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
            bodyTextStyle: TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
        ),
      ],
      onDone: () => _completeOnboarding(context),
      onSkip: () => _completeOnboarding(context),
      showSkipButton: true,
      skip: const Text("Skip"),
      next: const CircleAvatar(
          radius: 25,
          backgroundColor: Color(0xFFFF6C0A),
          child: Icon(
            Icons.arrow_forward_ios_rounded,
            size: 18,
            color: Colors.white,
          )),
      done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: const DotsDecorator(
        color: Colors.grey, // inactive dots color
        activeColor: Color(0xFFFF6C0A), // active dot color
        size: Size(8.0, 8.0),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
