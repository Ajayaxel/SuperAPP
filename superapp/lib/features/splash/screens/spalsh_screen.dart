import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/primary_button.dart';

class SpalshScreen extends StatelessWidget {
  const SpalshScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.splashGradient),
        child: Column(
          children: [
            const SizedBox(height: 50),
            Stack(
              children: [
                Center(
                  child:
                      Image.asset(
                            "images/spalsh/carimage.png",
                            fit: BoxFit.contain,
                            height: 520,
                          )
                          .animate()
                          .fadeIn(duration: 700.ms)
                          .moveY(
                            begin: -500,
                            end: 0,
                            duration: 900.ms,
                            curve: Curves.easeOutCubic,
                          ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  width: MediaQuery.of(context).size.width * 0.46,
                  child:
                      ClipRect(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 30,
                                      bottom: 50,
                                    ),
                                    child: Image.asset(
                                      "images/spalsh/electrologo.png",
                                      fit: BoxFit.contain,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                          .animate()
                          .fadeIn(delay: 900.ms, duration: 400.ms)
                          .slideX(
                            begin: 1.0,
                            end: 0.0,
                            duration: 600.ms,
                            curve: Curves.easeOutCubic,
                          ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 34,
                ),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(3),
                    topRight: Radius.circular(3),
                  ),
                  color: const Color(0x33FBFBFB),
                ),
                child:
                    Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 327,
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Welcome to Your \n',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 34,
                                        fontFamily: 'Lufga',
                                        fontWeight: FontWeight.w600,
                                        height: 1,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Journey',
                                      style: TextStyle(
                                        color: Color(0xFF0D4226),
                                        fontSize: 34,
                                        fontFamily: 'Lufga',
                                        fontWeight: FontWeight.w400,
                                        height: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 13),
                            Text(
                              'Experience smarter, connected driving with\nreal-time insights and seamless control.',
                              style: TextStyle(
                                color: Colors.black.withValues(alpha: 0.50),
                                fontSize: 12,
                                fontFamily: 'Lufga',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 19),
                            PrimaryButton(
                              text: 'Get Started',
                              onPressed: () {},
                            ),
                            const SizedBox(height: 20),
                            Center(
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Already have an Account?',
                                      style: TextStyle(
                                        color: Colors.black.withValues(
                                          alpha: 0.60,
                                        ),
                                        fontSize: 12,
                                        fontFamily: 'Lufga',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' ',
                                      style: TextStyle(
                                        color: Colors.black.withValues(
                                          alpha: 0.60,
                                        ),
                                        fontSize: 12,
                                        fontFamily: 'Lufga',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Login',
                                      style: TextStyle(
                                        color: const Color(0xFF0D4226),
                                        fontSize: 12,
                                        fontFamily: 'Lufga',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                        .animate()
                        .fadeIn(delay: 1500.ms, duration: 800.ms)
                        .moveY(
                          begin: 30,
                          end: 0,
                          duration: 800.ms,
                          curve: Curves.easeOutCubic,
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
