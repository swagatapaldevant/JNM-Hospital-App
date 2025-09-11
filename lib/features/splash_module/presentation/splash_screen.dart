import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/animation.dart';
import 'package:jnm_hospital_app/core/utils/helper/app_dimensions.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _bgController; // gentle bg animation

  @override
  void initState() {
    super.initState();

    // Entrance stagger for children
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..forward();

    // Looping background / particles
    _bgController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat(reverse: true);

    // Navigate after a short pause
    Future.delayed(const Duration(seconds: 3), setTimerNavigation);
  }

  @override
  void dispose() {
    _controller.dispose();
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppDimensions.init(context);

    return Scaffold(
      body: Stack(
        children: [
          // Animated gradient background
          AnimatedBuilder(
            animation: _bgController,
            builder: (_, __) {
              final t = _bgController.value;
              final c1 =
              Color.lerp(AppColors.splashBg1, const Color(0xFFEAF4FF), t)!;
              final c2 =
              Color.lerp(AppColors.splashBg2, const Color(0xFFD6E6FF), 1 - t)!;
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [c1, c2],
                  ),
                ),
              );
            },
          ),

          // Soft moving blobs (blurred)
          _floatingBlob(
            top: -60,
            left: -40,
            size: 200,
            color: AppColors.splashBg2.withOpacity(.20),
            dx: 16,
            dy: 12,
          ),
          _floatingBlob(
            bottom: -70,
            right: -50,
            size: 240,
            color: const Color(0xFF7F5AF0).withOpacity(.16),
            dx: -18,
            dy: 10,
          ),
          _floatingBlob(
            top: AppDimensions.screenHeight * .25,
            right: -40,
            size: 120,
            color: Colors.white.withOpacity(.18),
            dx: 12,
            dy: -8,
          ),

          // Decorative assets (kept, but softened & aligned modernly)
          Positioned(
            top: AppDimensions.screenWidth * 0.12,
            right: AppDimensions.screenWidth * 0.06,
            child: StaggeredAnimatedWidget(
              index: 0,
              controller: _controller,
              child: Opacity(
                opacity: .65,
                child: Image.asset(
                  "assets/images/splash/m1.png",
                  height: AppDimensions.screenHeight * 0.14,
                  width: AppDimensions.screenWidth * 0.2,
                ),
              ),
            ),
          ),
          Positioned(
            top: AppDimensions.screenWidth * 0.32,
            left: AppDimensions.screenWidth * 0.08,
            child: StaggeredAnimatedWidget(
              index: 1,
              controller: _controller,
              child: Opacity(
                opacity: .65,
                child: Image.asset(
                  "assets/images/splash/m2.png",
                  height: AppDimensions.screenHeight * 0.09,
                  width: AppDimensions.screenWidth * 0.12,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: AppDimensions.screenWidth * 0.18,
            left: 0,
            child: StaggeredAnimatedWidget(
              index: 2,
              controller: _controller,
              child: Opacity(
                opacity: .75,
                child: Image.asset(
                  "assets/images/splash/stetho.png",
                  height: AppDimensions.screenHeight * 0.28,
                  width: AppDimensions.screenWidth * 0.32,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: AppDimensions.screenWidth * 0.02,
            right: AppDimensions.screenWidth * 0.02,
            child: StaggeredAnimatedWidget(
              index: 3,
              controller: _controller,
              child: Opacity(
                opacity: .70,
                child: Image.asset(
                  "assets/images/splash/p1.png",
                  height: AppDimensions.screenHeight * 0.16,
                  width: AppDimensions.screenWidth * 0.38,
                ),
              ),
            ),
          ),

          // Centerpiece: glass logo + glow + brand
          Center(
            child: StaggeredAnimatedWidget(
              index: 4,
              controller: _controller,
              child: _GlassLogoCard(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Glow ring behind logo
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: AppDimensions.screenWidth * 0.42,
                          height: AppDimensions.screenWidth * 0.42,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            // soft glow
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF7F5AF0).withOpacity(.25),
                                blurRadius: 40,
                                spreadRadius: -4,
                              ),
                              BoxShadow(
                                color: AppColors.splashBg2.withOpacity(.25),
                                blurRadius: 30,
                                spreadRadius: -6,
                              ),
                            ],
                          ),
                        ),
                        ClipOval(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                            child: Container(
                              width: AppDimensions.screenWidth * 0.30,
                              height: AppDimensions.screenWidth * 0.30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(.75),
                                border: Border.all(
                                  color: Colors.white.withOpacity(.6),
                                  width: 1.2,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Image.asset(
                                  "assets/images/splash/splash_logo.png",
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Brand lockup
                    Text(
                      "JNM",
                      //"Rainbow",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: AppColors.splashText,
                        letterSpacing: .6,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Hospital & Research",
                      style: TextStyle(
                        fontSize: 13.5,
                        color: Colors.black54,
                        letterSpacing: .2,
                      ),
                    ),
                    const SizedBox(height: 14),
                    // Minimal progress indicator
                    SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.6,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.splashText.withOpacity(.85),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Version / footer
          Positioned(
            bottom: AppDimensions.screenHeight * 0.05,
            left: 0,
            right: 0,
            child: StaggeredAnimatedWidget(
              index: 5,
              controller: _controller,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Secure • Smart • Fast",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 12.5,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: const Text(
                      "v1.0 • JNM Suite",
                      //"v1.0.0 • Rainbow",
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---- nav ----
  void setTimerNavigation() {
    Navigator.pushNamed(context, "/PatientLoginScreen");
    // If you later add token logic, do it here safely and keep the route fallback.
  }

  // ---- tiny pieces ----
  Widget _floatingBlob({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required double size,
    required Color color,
    required double dx,
    required double dy,
  }) {
    return AnimatedBuilder(
      animation: _bgController,
      builder: (_, __) {
        final t = sin((_bgController.value * 2 * pi));
        return Positioned(
          top: top != null ? top + dy * t : null,
          bottom: bottom != null ? bottom + dy * t : null,
          left: left != null ? left + dx * t : null,
          right: right != null ? right + dx * t : null,
          child: ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                width: size,
                height: size,
                color: color,
              ),
            ),
          ),
        );
      },
    );
  }
}

// ---------- Glass card for the logo ----------
class _GlassLogoCard extends StatelessWidget {
  final Widget child;
  const _GlassLogoCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(24);
    return Container(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 28,
            offset: const Offset(0, 16),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(.7),
            blurRadius: 6,
            offset: const Offset(-2, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
            decoration: BoxDecoration(
              borderRadius: radius,
              color: Colors.white.withOpacity(.78),
              border: Border.all(color: Colors.white.withOpacity(.6), width: 1),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white.withOpacity(.88), Colors.white.withOpacity(.72)],
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
