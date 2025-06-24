import 'package:flutter/material.dart';
import 'package:jnm_hospital_app/core/utils/commonWidgets/common_button.dart';
import 'package:jnm_hospital_app/core/utils/commonWidgets/custom_button.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/app_dimensions.dart';

class OnboardingAuthScreen extends StatefulWidget {
  const OnboardingAuthScreen({super.key});

  @override
  State<OnboardingAuthScreen> createState() => _OnboardingAuthScreenState();
}

class _OnboardingAuthScreenState extends State<OnboardingAuthScreen> {
  @override
  Widget build(BuildContext context) {
    AppDimensions.init(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image.asset("assets/images/onboarding/logo.png",
                height: AppDimensions.screenHeight*0.25,
                  width: AppDimensions.screenWidth*0.4,
                ),
              ),
              SizedBox(height: AppDimensions.contentGap2,),
              Text("Let’s get started!", style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.colorBlack,
                fontSize: 22
              ),),
              SizedBox(height: 5,),
              Text("Login to Stay healthy and fit ", style: TextStyle(
                fontWeight: FontWeight.w300,
                color: AppColors.onboardingContainerText,
                fontSize: 16
              ),),
              SizedBox(height: AppDimensions.contentGap1,),
              CommonButton(
                onTap: (){
                  Navigator.pushNamed(context, "/LoginScreen");
                },
                width: AppDimensions.screenWidth*0.6,
                buttonName: 'Login',),
              SizedBox(height: AppDimensions.contentGap2,),

              CommonButton(
                onTap: (){
                    Navigator.pushNamed(context, "/SignupScreen");
                },
                bgColor: AppColors.white,
                labelTextColor: AppColors.arrowBackground,
                width: AppDimensions.screenWidth*0.6,
                buttonName: 'Sign Up',),


            ],
          ),
        ),
      ),
    );
  }
}
