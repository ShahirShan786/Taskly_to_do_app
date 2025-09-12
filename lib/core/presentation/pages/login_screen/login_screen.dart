import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:taskly_to_do_app/core/presentation/utils/message_generator.dart';
import 'package:taskly_to_do_app/core/presentation/utils/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          border: Border(),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFFFFFFFF),
              Color.fromARGB(134, 255, 130, 47),
              Color(0xFFFFFFFF),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Image.asset(
                "assets/images/taskly_logo.png",
                height: 130,
              ),
              Container(
                  width: 305.w,
                  constraints: BoxConstraints(
                    minHeight: 390.h,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(0.1), // semi-transparent black
                          spreadRadius: 3, // how much the shadow spreads
                          blurRadius: 8, // softness of shadow
                          offset: const Offset(2, 4), // x,y position of shadow
                        ),
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(
                          MessageGenerator.getLabel('Login'),
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(
                                  fontSize: 30, fontWeight: FontWeight.w800),
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(),
                            children: <TextSpan>[
                              TextSpan(
                                  text: MessageGenerator.getLabel(
                                      'Account_havent'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                          color: Colors.grey[700],
                                          fontSize: 13),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {}),
                              TextSpan(
                                  text: MessageGenerator.getLabel('Signup'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                          color: appColors.appPrimay,
                                          fontSize: 15),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      context.go("/signIn");
                                    }),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              MessageGenerator.getLabel("Email"),
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[700],
                                      fontSize: 15),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            // controller: _passwordController,
                            keyboardType: TextInputType.text,

                            style: Theme.of(context).textTheme.labelMedium,
                            textInputAction: TextInputAction.go,
                            onSubmitted: (value) {},
                            decoration: InputDecoration(
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(color: appColors.disableBgColor),
                              hintText:
                                  MessageGenerator.getLabel('user@domain.com'),
                              filled: true,
                              fillColor: appColors.appWhite,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: Colors.grey.shade300, width: 1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: Colors.grey.shade300, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: Colors.grey.shade500, width: 1.5),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              MessageGenerator.getLabel("Password"),
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[700],
                                      fontSize: 15),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            // controller: _passwordController,
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            style: Theme.of(context).textTheme.labelMedium,
                            textInputAction: TextInputAction.go,
                            onSubmitted: (value) {},
                            decoration: InputDecoration(
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(color: appColors.disableBgColor),
                              hintText: MessageGenerator.getLabel('user@123'),
                              filled: true,
                              fillColor: appColors.appWhite,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: Colors.grey.shade300, width: 1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: Colors.grey.shade300, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: Colors.grey.shade500, width: 1.5),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: RichText(
                              textAlign: TextAlign.right,
                              text: TextSpan(
                                  text: MessageGenerator.getLabel(
                                      'ForgotPassword'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                          color: appColors.appPrimay,
                                          fontSize: 13),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {}),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 125, vertical: 12),
                          decoration: BoxDecoration(
                              color: appColors.appPrimay,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            MessageGenerator.getLabel("Login"),
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(color: appColors.appWhite),
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Divider(
                                endIndent: 8,
                              )),
                              Text("OR"),
                              Expanded(
                                  child: Divider(
                                indent: 8,
                              ))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 56),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/svg/google.svg",
                                height: 18,
                                width: 18,
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                "Continue with Google",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
