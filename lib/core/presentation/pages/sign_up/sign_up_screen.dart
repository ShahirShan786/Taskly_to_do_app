







import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskly_to_do_app/core/presentation/utils/message_generator.dart';
import 'package:taskly_to_do_app/core/presentation/utils/theme.dart';
import 'package:taskly_to_do_app/core/providers/provider.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _acceptTerms = false;

 

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleAuthStateChanges(dynamic previous, dynamic next) {
    // Handle success
    if (next.user != null && next.error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      // Navigate to login or home
      context.go('/home');
    }

    // Handle error
    if (next.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(next.error!),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  // Validation functions
  String? _validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }
    if (value.trim().length < 2) {
      return 'Full name must be at least 2 characters';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value.trim())) {
      return 'Full name can only contain letters and spaces';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return MessageGenerator.getLabel('EmailRequired');
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return MessageGenerator.getLabel('InvalidEmail');
    }

    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }

    // Remove any non-digit characters for validation
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');

    if (digitsOnly.length < 10) {
      return 'Phone number must be at least 10 digits';
    }

    if (digitsOnly.length > 15) {
      return 'Phone number cannot exceed 15 digits';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return MessageGenerator.getLabel('PasswordRequired');
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    // Check for at least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }

    // Check for at least one lowercase letter
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }

    // Check for at least one digit
    if (!RegExp(r'\d').hasMatch(value)) {
      return 'Password must contain at least one number';
    }

    // Check for at least one special character
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }

    return null;
  }

  Future<void> _handleSignUp() async {
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the terms and conditions'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      final fullName = _fullNameController.text.trim();
      final email = _emailController.text.trim();
      final phone = _phoneController.text.trim();
      final password = _passwordController.text;

      // Call signup method from your auth notifier
      await ref.read(authNotifierProvider.notifier).signUp(
            fullName: fullName,
            email: email,
            phoneNumber: phone,
            password: password,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    ref.listen(authNotifierProvider, (previous, next) {
      _handleAuthStateChanges(previous, next);
    });

   
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
              const SizedBox(height: 50),
              Image.asset(
                "assets/images/taskly_logo.png",
                height: 130,
              ),
              Container(
                width: 305.w,
                constraints: BoxConstraints(minHeight: 500.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 3,
                      blurRadius: 8,
                      offset: const Offset(2, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Back button
                        Padding(
                          padding: const EdgeInsets.only(top: 8, left: 8),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: authState.isLoading
                                  ? null
                                  : () {
                                      context.go("/Login");
                                    },
                              child: Icon(
                                Icons.arrow_back_rounded,
                                color: authState.isLoading
                                    ? Colors.grey
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),

                        // Title
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              MessageGenerator.getLabel('Sign Up'),
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge
                                  ?.copyWith(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h),

                        // Login link
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: RichText(
                              text: TextSpan(
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: MessageGenerator.getLabel(
                                        'Account_have'),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(
                                          color: Colors.grey[700],
                                          fontSize: 13,
                                        ),
                                  ),
                                  TextSpan(
                                    text: MessageGenerator.getLabel('Login'),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(
                                          color: appColors.appPrimay,
                                          fontSize: 15,
                                        ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = authState.isLoading
                                          ? null
                                          : () {
                                              context.go("/Login");
                                            },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // Full Name Field
                        _buildInputField(
                          label: MessageGenerator.getLabel("Full Name"),
                          controller: _fullNameController,
                          validator: _validateFullName,
                          keyboardType: TextInputType.name,
                          hintText: MessageGenerator.getLabel('John Josh'),
                          enabled: !authState.isLoading,
                        ),

                        SizedBox(height: 16.h),

                        // Email Field
                        _buildInputField(
                          label: MessageGenerator.getLabel("Email"),
                          controller: _emailController,
                          validator: _validateEmail,
                          keyboardType: TextInputType.emailAddress,
                          hintText:
                              MessageGenerator.getLabel('user@domain.com'),
                          enabled: !authState.isLoading,
                        ),

                        SizedBox(height: 16.h),

                        // Phone Field
                        _buildInputField(
                          label: MessageGenerator.getLabel("Phone Number"),
                          controller: _phoneController,
                          validator: _validatePhone,
                          keyboardType: TextInputType.phone,
                          hintText: MessageGenerator.getLabel('988878766'),
                          enabled: !authState.isLoading,
                        ),

                        SizedBox(height: 16.h),

                        // Password Field
                        _buildPasswordField(
                          label: MessageGenerator.getLabel("Password"),
                          controller: _passwordController,
                          validator: _validatePassword,
                          enabled: !authState.isLoading,
                        ),

                        SizedBox(height: 16.h),

                        // Terms and Conditions
                        _buildTermsCheckbox(authState),

                        SizedBox(height: 16.h),

                        // Sign Up Button
                        _buildSignUpButton(authState),

                        SizedBox(height: 16.h),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String? Function(String?) validator,
    required TextInputType keyboardType,
    required String hintText,
    required bool enabled,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            label,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                  fontSize: 15,
                ),
          ),
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: validator,
            enabled: enabled,
            style: Theme.of(context).textTheme.labelMedium,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: appColors.disableBgColor),
              filled: true,
              fillColor: enabled ? appColors.appWhite : Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade500, width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.red, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.red, width: 1.5),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required String? Function(String?) validator,
    required bool enabled,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            label,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                  fontSize: 15,
                ),
          ),
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: TextFormField(
            controller: controller,
            validator: validator,
            enabled: enabled,
            obscureText: _obscurePassword,
            style: Theme.of(context).textTheme.labelMedium,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _handleSignUp(),
            decoration: InputDecoration(
              hintText: MessageGenerator.getLabel('user@123'),
              hintStyle: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: appColors.disableBgColor),
              filled: true,
              fillColor: enabled ? appColors.appWhite : Colors.grey[100],
              suffixIcon: IconButton(
                onPressed: enabled
                    ? () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      }
                    : null,
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey[600],
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade500, width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.red, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.red, width: 1.5),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTermsCheckbox(dynamic authState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: _acceptTerms,
            onChanged: authState.isLoading
                ? null
                : (value) {
                    setState(() {
                      _acceptTerms = value ?? false;
                    });
                  },
            activeColor: appColors.appPrimay,
          ),
          Expanded(
            child: GestureDetector(
              onTap: authState.isLoading
                  ? null
                  : () {
                      setState(() {
                        _acceptTerms = !_acceptTerms;
                      });
                    },
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[700],
                        ),
                    children: [
                      const TextSpan(text: 'I agree to the '),
                      TextSpan(
                        text: 'Terms and Conditions',
                        style: TextStyle(
                          color: appColors.appPrimay,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Navigate to terms and conditions
                          },
                      ),
                      const TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          color: appColors.appPrimay,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Navigate to privacy policy
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpButton(dynamic authState) {
    return GestureDetector(
      onTap: authState.isLoading ? null : _handleSignUp,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 125, vertical: 12),
        decoration: BoxDecoration(
          color: authState.isLoading ? Colors.grey[400] : appColors.appPrimay,
          borderRadius: BorderRadius.circular(10),
        ),
        child: authState.isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                "Sign Up",
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: appColors.appWhite),
              ),
      ),
    );
  }
}
