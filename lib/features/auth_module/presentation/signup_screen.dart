import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:jnm_hospital_app/core/utils/commonWidgets/common_button.dart';
import 'package:jnm_hospital_app/core/utils/commonWidgets/common_header.dart';
import 'package:jnm_hospital_app/core/utils/commonWidgets/custom_textField.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/animation.dart';
import 'package:jnm_hospital_app/core/utils/helper/app_dimensions.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> with TickerProviderStateMixin{

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool rememberMe = false;

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
  Widget build(BuildContext context) {
    AppDimensions.init(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.all(AppDimensions.screenPadding),
            child: Column(
              children: [
                CommonHeader(
                  screenName: 'Sign Up',
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
                    controller: nameController,
                    hintText: "Enter your name",
                    prefixIcon: Icons.person,
                  ),
                ),
                SizedBox(
                  height: AppDimensions.contentGap3,
                ),
                StaggeredAnimatedWidget(
                  index: 1,
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
                  index: 2,
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
                  height: AppDimensions.contentGap2,
                ),

                StaggeredAnimatedWidget(
                  index: 3,
                  controller: _controller,
                  child: Row(
                    children: [
                      Checkbox(
                                value: rememberMe,
                                onChanged: (val) {
                                  setState(() {
                                    rememberMe = val!;
                                  });
                                },
                              ),

                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: 'I agree to the medidoc',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: AppColors.onboardingContainerText),
                            children: const <TextSpan>[
                              TextSpan(
                                  text: ' Terms of Service ',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.arrowBackground)),
                              TextSpan(
                                  text: 'and ',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.onboardingContainerText)),
                              TextSpan(
                                  text: 'Privacy Policy',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.arrowBackground)),
                            ],
                          ),
                        ),
                      ),

                    ],
                  ),
                ),


                SizedBox(
                  height: AppDimensions.contentGap3,
                ),
                SizedBox(
                  height: AppDimensions.contentGap2,
                ),

                StaggeredAnimatedWidget(
                  index: 4,
                  controller: _controller,
                  child: CommonButton(
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(context, "/PatientButtonNavigation", (Route<dynamic> route) => false,);
                    },
                    width: AppDimensions.screenWidth * 0.7,
                    buttonName: 'Sign Up',
                  ),
                ),

                SizedBox(
                  height: AppDimensions.contentGap2,
                ),
                StaggeredAnimatedWidget(
                  index: 5,
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
                              text: 'Signin',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.arrowBackground)),
                        ],
                      ),
                    ),
                  ),
                ),





              ],
            ),
          ),
        ),
      ),
    );
  }
}
