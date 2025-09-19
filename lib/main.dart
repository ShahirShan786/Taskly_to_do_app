import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly_to_do_app/core/presentation/navigation/app_router.dart';
import 'package:taskly_to_do_app/core/presentation/pages/login_screen/login_screen.dart';

// import 'package:taskly_to_do_app/core/presentation/utils/di.dart';
import 'package:taskly_to_do_app/core/presentation/utils/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // setPathUrlStrategy();
  // setupDependencies();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      splitScreenMode: true,
      minTextAdapt: false,
      fontSizeResolver: FontSizeResolvers.radius,
      builder: (context, child) {
        return MaterialApp.router(
          routerConfig: router,
          title: "taskly_to_do_app",
          debugShowCheckedModeBanner: false,
          theme: appTheme,
          darkTheme: appTheme,
        );
      },
      child: const LoginScreen(),
    );
  }

  static void debugPrint(Object? object) {
    if (kDebugMode) {
      print(object);
    }
  }
}
