import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:taskly_to_do_app/core/presentation/notifiers/auth_notifiers.dart';
import 'package:taskly_to_do_app/core/presentation/utils/message_generator.dart';
import 'package:taskly_to_do_app/core/presentation/utils/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskly_to_do_app/core/providers/provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    // Listen to auth state changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listen<AuthState>(authNotifierProvider, (previous, next) {
        _handleAuthStateChanges(previous, next);
      });
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleAuthStateChanges(AuthState? previous, AuthState next) {
    // Handle loading state
    if (previous?.isLoading == true && !next.isLoading) {
      // Remove loading indicator if it was shown
    }

    // Handle success
    if (next.user != null && next.error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(MessageGenerator.getLabel('LoginSuccess')),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
      // Navigate to home or dashboard
      context.go('/home'); // Adjust route as needed
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

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return MessageGenerator.getLabel('EmailRequired');
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return MessageGenerator.getLabel('InvalidEmail');
    }
    
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return MessageGenerator.getLabel('PasswordRequired') ;
    }
    
    if (value.length < 6) {
      return MessageGenerator.getLabel('PasswordTooShort');
    }
    
    return null;
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text;
      
      await ref.read(authNotifierProvider.notifier).signIn(email, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    
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
                constraints: BoxConstraints(minHeight: 390.h),
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
                        SizedBox(height: 20.h),
                        Text(
                          MessageGenerator.getLabel('Login'),
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        SizedBox(height: 8.h),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(),
                            children: <TextSpan>[
                              TextSpan(
                                text: MessageGenerator.getLabel('Account_havent') ,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      color: Colors.grey[700],
                                      fontSize: 13,
                                    ),
                              ),
                              TextSpan(
                                text: MessageGenerator.getLabel('Signup'),
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      color: appColors.appPrimay,
                                      fontSize: 15,
                                    ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    context.go("/signIn");
                                  },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16.h),
                        
                        // Email Field
                        _buildInputField(
                          label: MessageGenerator.getLabel("Email"),
                          controller: _emailController,
                          validator: _validateEmail,
                          keyboardType: TextInputType.emailAddress,
                          hintText: MessageGenerator.getLabel('user@domain.com'),
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
                        
                        SizedBox(height: 8.h),
                        
                        // Forgot Password
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: authState.isLoading ? null : () {
                                // Handle forgot password
                              },
                              child: Text(
                                MessageGenerator.getLabel('ForgotPassword'),
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      color: authState.isLoading 
                                          ? Colors.grey 
                                          : appColors.appPrimay,
                                      fontSize: 13,
                                    ),
                              ),
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 16.h),
                        
                        // Login Button
                        _buildLoginButton(authState),
                        
                        SizedBox(height: 16.h),
                        
                        // Divider
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Expanded(child: Divider(endIndent: 8)),
                              Text("OR"),
                              Expanded(child: Divider(indent: 8)),
                            ],
                          ),
                        ),
                        
                        SizedBox(height: 16.h),
                        
                        // Google Sign In Button
                        _buildGoogleSignInButton(authState),
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
            onFieldSubmitted: (_) => _handleLogin(),
            decoration: InputDecoration(
              hintText: MessageGenerator.getLabel('user@123'),
              hintStyle: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: appColors.disableBgColor),
              filled: true,
              fillColor: enabled ? appColors.appWhite : Colors.grey[100],
              suffixIcon: IconButton(
                onPressed: enabled ? () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                } : null,
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

  Widget _buildLoginButton(AuthState authState) {
    return GestureDetector(
      onTap: authState.isLoading ? null : _handleLogin,
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
                MessageGenerator.getLabel("Login"),
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: appColors.appWhite),
              ),
      ),
    );
  }

  Widget _buildGoogleSignInButton(AuthState authState) {
    return GestureDetector(
      onTap: authState.isLoading ? null : () {
        // Handle Google Sign In
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 56),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: authState.isLoading ? Colors.grey[200]! : Colors.grey[300]!,
          ),
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
              colorFilter: authState.isLoading 
                  ? const ColorFilter.mode(Colors.grey, BlendMode.srcIn)
                  : null,
            ),
            const SizedBox(width: 12),
            Text(
              "Continue with Google",
              style: TextStyle(
                fontSize: 16,
                color: authState.isLoading ? Colors.grey : Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}