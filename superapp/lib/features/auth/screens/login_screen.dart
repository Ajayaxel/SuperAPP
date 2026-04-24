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
import 'package:superapp/features/auth/screens/register_screen.dart';
import 'package:superapp/features/bootmnav/bottm_navbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
                message: "Login Successful",
              );
            }
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const BottomNavBar()),
              (route) => false,
            );
          } else if (state is AuthFailure) {
            CustomToast.show(
              context,
              title: "Error",
              message: state.error,
              isError: true,
            );
          }
        },
        child: SafeArea(
          bottom: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        SizedBox(height: constraints.maxHeight * 0.12),
                        Center(
                          child: Image.asset(
                            AppImages.loginScreenLogo,
                            fit: BoxFit.contain,
                            width: 250,
                            height: 64,
                          ),
                        ),
                        SizedBox(height: constraints.maxHeight * 0.12),
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
                                  "Welcome Back",
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 26,
                                    fontFamily: 'SF Pro',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Login to continue your EV journey",
                                  style: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 16,
                                    fontFamily: 'SF Pro',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(height: 40),
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
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    "Forgot Password?",
                                    style: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontSize: 14,
                                      fontFamily: 'SF Pro',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 32),
                                BlocBuilder<AuthBloc, AuthState>(
                                  builder: (context, state) {
                                    return Btn(
                                      text: "Login",
                                      isLoading: state is AuthLoading,
                                      onTap: () {
                                        if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
                                          CustomToast.show(
                                            context,
                                            title: "Error",
                                            message: "Please fill all fields",
                                            isError: true,
                                          );
                                          return;
                                        }
                                        context.read<AuthBloc>().add(
                                              LoginEvent(
                                                email: _emailController.text.trim(),
                                                password: _passwordController.text,
                                              ),
                                            );
                                      },
                                    );
                                  },
                                ),
                                const Spacer(),
                                Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const RegisterScreen(),
                                        ),
                                      );
                                    },
                                    child: Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "Don't have an account? ",
                                            style: TextStyle(
                                              color: Colors.grey.shade400,
                                              fontSize: 14,
                                              fontFamily: 'SF Pro',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          const TextSpan(
                                            text: "Sign Up",
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
      ),
    );
  }
}
