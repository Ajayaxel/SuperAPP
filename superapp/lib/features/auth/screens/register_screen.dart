import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:superapp/Themes/app_colors.dart';
import 'package:superapp/Themes/app_images.dart';
import 'package:superapp/core/constants/btn.dart';
import 'package:superapp/core/utils/custom_toast.dart';
import 'package:superapp/core/widgets/custom_textfield.dart';
import 'package:superapp/features/auth/bloc/auth_bloc.dart';
import 'package:superapp/features/auth/bloc/auth_event.dart';
import 'package:superapp/features/auth/bloc/auth_state.dart';
import 'package:superapp/features/bootmnav/bottm_navbar.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            if (!state.isAutoLogin) {
              CustomToast.show(
                context,
                title: "Success",
                message: "Registration Successful",
              );
            }
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const BottomNavBar()),
              (route) => false,
            );
          } else if (state is AuthFailure) {
            print('DEBUG: AuthFailure on RegisterScreen: ${state.error}');
            CustomToast.show(
              context,
              title: "Error",
              message: state.error,
              isError: true,
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return Stack(
              children: [
                SafeArea(
                  bottom: false,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minHeight: constraints.maxHeight),
                          child: IntrinsicHeight(
                            child: Column(
                              children: [
                                SizedBox(height: constraints.maxHeight * 0.08),
                                Center(
                                  child: Image.asset(
                                    AppImages.loginScreenLogo,
                                    fit: BoxFit.contain,
                                    width: 200,
                                    height: 50,
                                  ),
                                ),
                                SizedBox(height: constraints.maxHeight * 0.08),
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                                    decoration: const BoxDecoration(
                                      color: AppColors.secondary,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(32),
                                        topRight: Radius.circular(32),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Create Account",
                                          style: TextStyle(
                                            color: AppColors.primary,
                                            fontSize: 26,
                                            fontFamily: 'SF Pro',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          "Join us to start your EV journey",
                                          style: TextStyle(
                                            color: Colors.grey.shade400,
                                            fontSize: 16,
                                            fontFamily: 'SF Pro',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        const SizedBox(height: 32),
                                        CustomTextField(
                                          controller: _nameController,
                                          hintText: "Full Name",
                                          prefixIcon: Icons.person_outline,
                                        ),
                                        const SizedBox(height: 16),
                                        CustomTextField(
                                          controller: _emailController,
                                          hintText: "Email Address",
                                          prefixIcon: Icons.email_outlined,
                                          keyboardType: TextInputType.emailAddress,
                                        ),
                                        const SizedBox(height: 16),
                                        CustomTextField(
                                          controller: _passwordController,
                                          hintText: "Password",
                                          prefixIcon: Icons.lock_outline,
                                          obscureText: true,
                                        ),
                                        const SizedBox(height: 16),
                                        CustomTextField(
                                          controller: _confirmPasswordController,
                                          hintText: "Confirm Password",
                                          prefixIcon: Icons.lock_reset_outlined,
                                          obscureText: true,
                                        ),
                                        const SizedBox(height: 32),
                                        Btn(
                                          text: "Sign Up",
                                          isLoading: state is AuthLoading,
                                          onTap: () {
                                            final name = _nameController.text.trim();
                                            final email = _emailController.text.trim();
                                            final password = _passwordController.text;
                                            final confirmPassword = _confirmPasswordController.text;

                                            if (name.isEmpty ||
                                                email.isEmpty ||
                                                password.isEmpty ||
                                                confirmPassword.isEmpty) {
                                              CustomToast.show(
                                                context,
                                                title: "Error",
                                                message: "Please fill all fields",
                                                isError: true,
                                              );
                                              return;
                                            }

                                            // Simple email regex
                                            final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                                            if (!emailRegex.hasMatch(email)) {
                                              CustomToast.show(
                                                context,
                                                title: "Invalid Email",
                                                message: "Please enter a valid email address",
                                                isError: true,
                                              );
                                              return;
                                            }

                                            if (password.length < 6) {
                                              CustomToast.show(
                                                context,
                                                title: "Weak Password",
                                                message: "Password must be at least 6 characters",
                                                isError: true,
                                              );
                                              return;
                                            }

                                            if (password != confirmPassword) {
                                              CustomToast.show(
                                                context,
                                                title: "Error",
                                                message: "Passwords do not match",
                                                isError: true,
                                              );
                                              return;
                                            }

                                            context.read<AuthBloc>().add(
                                                  RegisterEvent(
                                                    name: name,
                                                    email: email,
                                                    password: password,
                                                    passwordConfirmation: confirmPassword,
                                                    role: "private_seller",
                                                  ),
                                                );
                                          },
                                        ),
                                        const Spacer(),
                                        Center(
                                          child: GestureDetector(
                                            onTap: () => Navigator.pop(context),
                                            child: Text.rich(
                                              TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: "Already have an account? ",
                                                    style: TextStyle(
                                                      color: Colors.grey.shade400,
                                                      fontSize: 14,
                                                      fontFamily: 'SF Pro',
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                  const TextSpan(
                                                    text: "Login",
                                                    style: TextStyle(
                                                      color: AppColors.thirdcolor,
                                                      fontSize: 14,
                                                      fontFamily: 'SF Pro',
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (state is AuthLoading)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
