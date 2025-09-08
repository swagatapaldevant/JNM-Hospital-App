import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/locator.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/resource.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/status.dart';
import 'package:jnm_hospital_app/core/services/localStorage/shared_pref.dart';
import 'package:jnm_hospital_app/core/utils/commonWidgets/common_button.dart';
import 'package:jnm_hospital_app/core/utils/commonWidgets/custom_textField.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/animation.dart';
import 'package:jnm_hospital_app/core/utils/helper/app_dimensions.dart';
import 'package:jnm_hospital_app/core/utils/helper/common_utils.dart';
import 'package:jnm_hospital_app/features/auth_module/data/auth_usecase.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  late AnimationController _controller;
  bool isLoading = false;

  final AuthUsecase _authUsecase = getIt<AuthUsecase>();
  final SharedPref _pref = getIt<SharedPref>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ======================== UI ========================

  @override
  Widget build(BuildContext context) {
    AppDimensions.init(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1) Animated Background
          const _AnimatedGradientBackground(),

          // 2) Decorative blurred blobs
          Positioned(
              top: -60,
              left: -40,
              child: _blob(180, AppColors.arrowBackground.withOpacity(.10))),
          Positioned(
              bottom: -70,
              right: -60,
              child: _blob(220, const Color(0xFF7F5AF0).withOpacity(.10))),
          Positioned(
              top: 120,
              right: -40,
              child: _blob(100, Colors.white.withOpacity(.18))),

          // 3) Content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.screenPadding, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: AppDimensions.contentGap1),

                  // Brand row
                  _BrandHeader(),

                  SizedBox(height: AppDimensions.contentGap3),
                  SizedBox(height: AppDimensions.contentGap1),

                  // Glass login panel
                  _GlassPanel(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Title + subtitle
                        Row(
                          children: [
                            _circleIcon(
                              Icons.admin_panel_settings_rounded,
                              bg: AppColors.arrowBackground.withOpacity(.12),
                              fg: AppColors.arrowBackground,
                            ),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Administrator Login',
                                    style: TextStyle(
                                      fontSize: 18.5,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black87,
                                      letterSpacing: .2,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Access the secure admin dashboard',
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: AppDimensions.contentGap3),

                        // Email
                        StaggeredAnimatedWidget(
                          index: 0,
                          controller: _controller,
                          child: CustomTextField(
                            controller: emailController,
                            hintText: "Enter your userId",
                            prefixIcon: Icons.email_rounded,
                          ),
                        ),
                        SizedBox(height: AppDimensions.contentGap3),

                        // Password
                        StaggeredAnimatedWidget(
                          index: 1,
                          controller: _controller,
                          child: CustomTextField(
                            controller: passwordController,
                            hintText: 'Password',
                            prefixIcon: Icons.lock_rounded,
                            suffixIcon:
                                Icons.visibility, // your widget handles obscure
                            isPassword: true,
                          ),
                        ),

                        SizedBox(height: AppDimensions.contentGap1),

                        // Forgot pass (optional)
                        // Align(
                        //   alignment: Alignment.centerRight,
                        //   child: Bounceable(
                        //     onTap: () {
                        //       // hook if needed
                        //       CommonUtils().flutterSnackBar(
                        //         context: context,
                        //         mes: "Use admin tool to reset password.",
                        //         messageType: 2,
                        //       );
                        //     },
                        //     child: Padding(
                        //       padding: const EdgeInsets.only(top: 6),
                        //       child: Text(
                        //         "Forgot Password?",
                        //         style: TextStyle(
                        //           fontSize: 13,
                        //           fontWeight: FontWeight.w600,
                        //           color: AppColors.arrowBackground,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        //
                        // SizedBox(height: AppDimensions.contentGap3),

                        // Login button + loading state
                        StaggeredAnimatedWidget(
                          index: 2,
                          controller: _controller,
                          child: isLoading
                              ? Center(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 6),
                                    child: CircularProgressIndicator(
                                        color: AppColors.arrowBackground),
                                  ),
                                )
                              : CommonButton(
                                  onTap: _onLoginPressed,
                                  width: AppDimensions.screenWidth * 0.7,
                                  buttonName: 'Login',
                                ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: AppDimensions.contentGap3),
                  SizedBox(height: AppDimensions.contentGap1),

                  // Footer / tagline
                  const _FooterNote(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ======================== Actions ========================

  void _onLoginPressed() {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      CommonUtils().flutterSnackBar(
        context: context,
        mes: "Please enter email and password",
        messageType: 4,
      );
      return;
    }
    loginAdmin();
  }

  List<String> parseApprovalPermission(List<dynamic> json) {
    
    /*Permission structure
    // {
          "id": 117,
          "permissions": "APPROVAL BILL",
          "parent_id": 1,
          "guard_name": "web"
    }*/

    List<String> permList = [];
    bool hasPerm = false;

    for (var item in json) {
      if (item["permissions"] == "APPROVAL BILL") {
        hasPerm = true;
      } else {
        String permName = item["permissions"].split(" ").last;
        permList.add(permName);
      }
    }
    print("Permissions: ");
    print(permList);
    

    return  hasPerm ? permList : [];
  }

  Future<void> loginAdmin() async {
    setState(() => isLoading = true);

    final requestData = {
      "email": emailController.text.trim(),
      "password": passwordController.text.trim(),
    };

    final Resource resource =
        await _authUsecase.login(requestData: requestData);

    if (!mounted) return;

    if (resource.status == STATUS.SUCCESS) {
      _pref.setLoginStatus(true);
      _pref.setUserAuthToken(resource.data["access_token"].toString());
      _pref.setProfileImage(resource.data["user"]["profile_img"].toString());
      _pref.setUserName(resource.data["user"]["name"].toString());

      List<String> approvalPermissionList = [];
      approvalPermissionList =
          parseApprovalPermission(resource.data["user"]["permissions"]);
      _pref.setApprovalPermissionList(approvalPermissionList);
      

      setState(() => isLoading = false);

      Navigator.pushNamedAndRemoveUntil(
        context,
        "/ReportDashboardScreen",
        (Route<dynamic> route) => false,
      );
    } else {
      setState(() => isLoading = false);
      CommonUtils().flutterSnackBar(
        context: context,
        mes: resource.message ?? "Login failed",
        messageType: 4,
      );
    }
  }
}

// ======================== Pieces ========================

class _AnimatedGradientBackground extends StatefulWidget {
  const _AnimatedGradientBackground();

  @override
  State<_AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState
    extends State<_AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 6),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) {
        final t = _c.value;
        // subtle shift between two palettes
        final c1 =
            Color.lerp(const Color(0xFFF0F3FF), const Color(0xFFEAF4FF), t)!;
        final c2 = Color.lerp(
            const Color(0xFFCDDBFF), const Color(0xFFD6E6FF), 1 - t)!;
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
    );
  }
}

class _GlassPanel extends StatelessWidget {
  final Widget child;
  const _GlassPanel({required this.child});

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(22);
    return Container(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 24,
            offset: const Offset(0, 12),
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
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
            decoration: BoxDecoration(
              borderRadius: radius,
              color: Colors.white.withOpacity(.78),
              border: Border.all(color: Colors.white.withOpacity(.6), width: 1),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(.88),
                  Colors.white.withOpacity(.72)
                ],
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _BrandHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _brandBadge(),
        const SizedBox(width: 12),
        const Expanded(
          child: Text(
            "Welcome back,\nAdmin",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Colors.black87,
              letterSpacing: .2,
              height: 1.2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _brandBadge() {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.arrowBackground, // primary
            Color(0xFF7F5AF0), // accent
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.12),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Center(
        child:
            Icon(Icons.local_hospital_rounded, color: Colors.white, size: 26),
      ),
    );
  }
}

class _FooterNote extends StatelessWidget {
  const _FooterNote();

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: .85,
      child: Column(
        children: [
          const SizedBox(height: 8),
          const Text(
            "Secure • Role-based access • Audit-ready",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.5,
              color: Colors.black54,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _badge('v1.0.0'),
              // const SizedBox(width: 6),
              // _badge('Admin Portal'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _badge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.black12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
      ),
    );
  }
}

// ---------- tiny helpers ----------
Widget _blob(double size, Color color) {
  return ClipOval(
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    ),
  );
}

Widget _circleIcon(IconData icon, {required Color bg, required Color fg}) {
  return Container(
    width: 40,
    height: 40,
    decoration: BoxDecoration(
      color: bg,
      shape: BoxShape.circle,
      border: Border.all(color: fg.withOpacity(.35)),
    ),
    child: Icon(icon, color: fg, size: 20),
  );
}
