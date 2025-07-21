import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/locator.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/resource.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/status.dart';
import 'package:jnm_hospital_app/core/services/localStorage/shared_pref.dart';
import 'package:jnm_hospital_app/core/utils/commonWidgets/common_button.dart';
import 'package:jnm_hospital_app/core/utils/commonWidgets/common_header.dart';
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
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool isLoading = false;
  final AuthUsecase _authUsecase = getIt<AuthUsecase>();
  final SharedPref _pref = getIt<SharedPref>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.2, 1.0, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppDimensions.init(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.screenPadding),
            child: Column(
              children: [
                CommonHeader(
                  screenName: 'Login',
                ),
                SizedBox(
                  height: AppDimensions.contentGap1,
                ),
                SizedBox(
                  height: AppDimensions.contentGap3,
                ),
                StaggeredAnimatedWidget(
                  index: 0,
                  controller: _controller,
                  child: CustomTextField(
                    controller: emailController,
                    hintText: "Enter your email",
                    prefixIcon: Icons.email,
                  ),
                ),
                SizedBox(
                  height: AppDimensions.contentGap3,
                ),
                StaggeredAnimatedWidget(
                  index: 1,
                  controller: _controller,
                  child: CustomTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    prefixIcon: Icons.lock,
                    suffixIcon: Icons.visibility,
                    isPassword: true,
                  ),
                ),
                SizedBox(
                  height: AppDimensions.contentGap3,
                ),
                StaggeredAnimatedWidget(
                  index: 2,
                  controller: _controller,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Bounceable(
                      onTap: () {},
                      child: Text(
                        "Forgot Password ?",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.arrowBackground),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: AppDimensions.contentGap1,
                ),
                SizedBox(
                  height: AppDimensions.contentGap3,
                ),
                isLoading?CircularProgressIndicator(
                  color: AppColors.arrowBackground,
                ):
                StaggeredAnimatedWidget(
                  index: 3,
                  controller: _controller,
                  child: CommonButton(
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(context, "/ReportDashboardScreen", (Route<dynamic> route) => false,);

                      // if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty)
                      // {
                      //   loginAdmin();
                      // }
                      // else{
                      //   CommonUtils().flutterSnackBar(
                      //       context: context, mes:"Please enter email and password", messageType: 4);
                      //
                      // }
                      //Navigator.pushNamedAndRemoveUntil(context, "/PatientButtonNavigation", (Route<dynamic> route) => false,);
                      //Navigator.pushNamedAndRemoveUntil(context, "/ReportDashboardScreen", (Route<dynamic> route) => false,);
                    },
                    width: AppDimensions.screenWidth * 0.7,
                    buttonName: 'Login',
                  ),
                ),
                SizedBox(
                  height: AppDimensions.contentGap1,
                ),
                StaggeredAnimatedWidget(
                  index: 4,
                  controller: _controller,
                  child: Bounceable(
                    onTap: () {},
                    child: RichText(
                      text: TextSpan(
                        text: 'Don’t have an account? ',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: AppColors.onboardingContainerText),
                        children: const <TextSpan>[
                          TextSpan(
                              text: 'Sign Up ',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.arrowBackground)),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: AppDimensions.contentGap1,
                ),
                SizedBox(
                  height: AppDimensions.contentGap3,
                ),
                StaggeredAnimatedWidget(
                  index: 5,
                  controller: _controller,
                  child: Text(
                    "----------OR----------",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.gray7),
                  ),
                ),
                SizedBox(
                  height: AppDimensions.contentGap1,
                ),
                SizedBox(
                  height: AppDimensions.contentGap3,
                ),
                StaggeredAnimatedWidget(
                  index: 6,
                  controller: _controller,
                  child: CommonButton(
                      onTap: () {},
                      bgColor: AppColors.white,
                      labelTextColor: AppColors.colorBlack,
                      width: AppDimensions.screenWidth * 0.7,
                      buttonName: "Sign in with Google"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }


  loginAdmin() async {
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> requestData = {
      "email": emailController.text.trim(),
      "password": passwordController.text.trim()
    };

    Resource resource = await _authUsecase.login(requestData: requestData);

    if (resource.status == STATUS.SUCCESS) {
      _pref.setLoginStatus(true);
      _pref.setUserAuthToken(resource.data["access_token"]);
      // _pref.setProfileImage(resource.data['image']);
      // _pref.setUserName(
      //     resource.data['first_name'] +" "+ resource.data['last_name']);
      // if (resource.data['user_type_id'] == 1) {
      //   Navigator.pushNamed(context, "/BottomNavbar");
      // }
      // else{
      //   CommonUtils().flutterSnackBar(
      //       context: context, mes:"You are not an admin, you have not permission to view the app", messageType: 4);
      // }

      setState(() {
        isLoading = false;
        Navigator.pushNamedAndRemoveUntil(context, "/ReportDashboardScreen", (Route<dynamic> route) => false,);
      });

    } else {
      setState(() {
        isLoading = false;
      });
      CommonUtils().flutterSnackBar(
          context: context, mes: resource.message ?? "", messageType: 4);
    }
  }




}
