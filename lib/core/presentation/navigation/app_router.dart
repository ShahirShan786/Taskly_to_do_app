import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taskly_to_do_app/core/data/models/todo_model.dart';
import 'package:taskly_to_do_app/core/presentation/pages/dashboard/dsashboard_screen.dart';
import 'package:taskly_to_do_app/core/presentation/pages/dummy_screen.dart';
import 'package:taskly_to_do_app/core/presentation/pages/edit/edit_task_screen.dart';
import 'package:taskly_to_do_app/core/presentation/pages/home/home_screen.dart';
import 'package:taskly_to_do_app/core/presentation/pages/login_screen/login_screen.dart';
import 'package:taskly_to_do_app/core/presentation/pages/on_boarding_pages/on_boarding_page_one.dart';
import 'package:taskly_to_do_app/core/presentation/pages/sign_up/sign_up_screen.dart';
import 'package:taskly_to_do_app/core/presentation/pages/splash_screen/splash_screen.dart';
import 'package:taskly_to_do_app/core/presentation/utils/widget_helper.dart';

final GoRouter router = GoRouter(
  errorBuilder: (context, state) => const DummyScreen(text: "Error Screen"),
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
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
            child: const LoginScreen(),
          ),
        ),
        GoRoute(
          path: 'signIn',
          pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
            context: context,
            state: state,
            child: const SignUpScreen(),
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
          path: 'dashboard',
          pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
            context: context,
            state: state,
            child: const DashboardScreen(),
          ),
        ),
        GoRoute(
          path: 'home',
          pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
            context: context,
            state: state,
            child: const HomeScreen(),
          ),
        ),
        GoRoute(
          path: 'edit',
          pageBuilder: (context, state) {
            final task =
                state.extra is TodoModel ? state.extra as TodoModel : null;

            return buildPageWithDefaultTransition<void>(
              context: context,
              state: state,
              child: EditTaskScreen(task: task),
            );
          },
        ),
      ],
    ),
  ],
);

// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:taskly_to_do_app/core/presentation/pages/dummy_screen.dart';
// import 'package:taskly_to_do_app/core/presentation/pages/home/home_screen.dart';
// import 'package:taskly_to_do_app/core/presentation/pages/login_screen/login_screen.dart';
// import 'package:taskly_to_do_app/core/presentation/pages/on_boarding_pages/on_boarding_page_one.dart';
// import 'package:taskly_to_do_app/core/presentation/pages/sign_up/sign_up_screen.dart';

// import 'package:taskly_to_do_app/core/presentation/pages/splash_screen/splash_screen.dart';
// import 'package:taskly_to_do_app/core/presentation/utils/widget_helper.dart';
// import 'package:go_router/go_router.dart';

// final GoRouter router = GoRouter(
//   errorBuilder: (context, state) => const DummyScreen(text: "Error Screen"),
//   redirect: (BuildContext context, GoRouterState state) {
//     if (![
//       "/home",
//       "/signIn",
//       "/forgotPassword",
//       "/splash",
//       "/onboard",
//       "/login"
//     ].contains(state.fullPath)) {
//       // if any routes which needs auth, check for auth
//       bool auth = Random().nextBool();
//       if (!auth) {
//         // if not authenticated, show signin screen
//         return '/home';
//       } else {
//         // if authenticated, proceed
//         return null;
//       }
//     } else {
//       // for any screens which not need auth, proceed
//       return null;
//     }
//   },
//   routes: <RouteBase>[
//     GoRoute(
//       path: '/',
//       builder: (BuildContext context, GoRouterState state) {
//         return  const LoginScreen();
//       },
//       routes: <RouteBase>[
//         GoRoute(
//           path: 'splash',
//           pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
//             context: context,
//             state: state,
//             child: const SplashScreen(),
//           ),
//         ),
//         GoRoute(
//           path: 'onboard',
//           pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
//             context: context,
//             state: state,
//             child: const OnboardingPage(),
//           ),
//         ),
//         GoRoute(
//           path: 'login',
//           pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
//             context: context,
//             state: state,
//             child:  const LoginScreen(),
//           ),
//         ),
//           GoRoute(
//           path: 'signIn',
//           pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
//             context: context,
//             state: state,
//             child: const SignUpScreen(),
//           ),
//         ),
//         GoRoute(
//           path: 'forgotPassword',
//           pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
//             context: context,
//             state: state,
//             child: const DummyScreen(text: "Forgot Password Screen"),
//           ),
//         ),
//         GoRoute(
//           path: 'home',
//           pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
//             context: context,
//             state: state,
//             child: const HomeScreen(),
//           ),
//         ),
//       ],
//     ),
//   ],
// );
