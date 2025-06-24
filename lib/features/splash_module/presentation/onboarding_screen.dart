import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/app_dimensions.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {


  final List<String> images = [
    'assets/images/onboarding/doctor1.png',
    'assets/images/onboarding/doctor2.png',
  ];
  final List<String> text = [
      "Find a lot of specialist doctors in one place",
      "Get advice only from a doctor you believe in."
  ];


  int currentStep = 0; // Step tracker (0-indexed)


  @override
  @override
  Widget build(BuildContext context) {
    AppDimensions.init(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.screenPadding),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Bounceable(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, "/OnboardingAuthScreen");
                      },
                      child: Text(
                        "Skip",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: AppColors.gray7),
                      ),
                    ),
                  ),
                  SizedBox(height: AppDimensions.contentGap1),
                  Center(
                    child: Image.asset(
                      images[currentStep],
                      height: AppDimensions.screenHeight * 0.6,
                      width: AppDimensions.screenWidth * 0.8,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),

              // Overlapping Container
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: AppDimensions.screenHeight * 0.28, // Overlaps a portion
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.onboardingContainer,
                        AppColors.white,
                      ],
                    ),
                  ),
                  padding: EdgeInsets.all(AppDimensions.screenPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: AppDimensions.screenHeight*0.03,),
                      Text(
                        text[currentStep],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onboardingContainerText,
                        ),
                      ),
                      SizedBox(height: AppDimensions.contentGap1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Dot Indicators
                          Row(
                            children: List.generate(
                              images.length,
                                  (index) => AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                width: index == currentStep ? 18 : 8,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: index == currentStep
                                      ? AppColors.arrowBackground
                                      : AppColors.gray7.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                          ),

                          // Next Button
                          Bounceable(
                            onTap: () {
                              setState(() {
                                if (currentStep < images.length - 1) {
                                  currentStep++;
                                } else {
                                  Navigator.pushReplacementNamed(context, "/OnboardingAuthScreen");
                                }
                              });
                            },
                            child: CircleAvatar(
                              radius: 25,
                              backgroundColor: AppColors.arrowBackground,
                              child: const Icon(Icons.arrow_forward,
                                  color: Colors.white, size: 25),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
