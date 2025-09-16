import 'dart:math';

import 'package:flutter/material.dart';
import 'package:taskly_to_do_app/core/presentation/pages/dummy_screen.dart';
import 'package:taskly_to_do_app/core/presentation/pages/login_screen/login_screen.dart';
import 'package:taskly_to_do_app/core/presentation/pages/on_boarding_pages/on_boarding_page_one.dart';
import 'package:taskly_to_do_app/core/presentation/pages/sign_in/sign_in_screen.dart';

import 'package:taskly_to_do_app/core/presentation/pages/splash_screen/splash_screen.dart';
import 'package:taskly_to_do_app/core/presentation/utils/widget_helper.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  errorBuilder: (context, state) => const DummyScreen(text: "Error Screen"),
  redirect: (BuildContext context, GoRouterState state) {
    if (![
      "/home",
      "/signIn",
      "/forgotPassword",
      "/splash",
      "/onboard",
      "/login"
    ].contains(state.fullPath)) {
      // if any routes which needs auth, check for auth
      bool auth = Random().nextBool();
      if (!auth) {
        // if not authenticated, show signin screen
        return '/login';
      } else {
        // if authenticated, proceed
        return null;
      }
    } else {
      // for any screens which not need auth, proceed
      return null;
    }
  },
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return  const LoginScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'splash',
          pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
            context: context,
            state: state,
            child: const SplashScreen(),
          ),
        ),
        GoRoute(
          path: 'onboard',
          pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
            context: context,
            state: state,
            child: const OnboardingPage(),
          ),
        ),
        GoRoute(
          path: 'login',
          pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
            context: context,
            state: state,
            child:  const LoginScreen(),
          ),
        ),
          GoRoute(
          path: 'signIn',
          pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
            context: context,
            state: state,
            child: const SignInScreen(),
          ),
        ),
        GoRoute(
          path: 'forgotPassword',
          pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
            context: context,
            state: state,
            child: const DummyScreen(text: "Forgot Password Screen"),
          ),
        ),
        GoRoute(
          path: 'home',
          pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
            context: context,
            state: state,
            child: const DummyScreen(text: "Home Screen"),
          ),
        ),
      ],
    ),
  ],
);
