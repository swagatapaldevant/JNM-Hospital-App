import 'package:flutter/material.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/animation.dart';
import 'package:jnm_hospital_app/core/utils/helper/app_dimensions.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin{

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

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
    Future.delayed(const Duration(seconds: 3), () {
      setTimerNavigation();
    });
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
      body: Container(
        height: AppDimensions.screenHeight,
        width: AppDimensions.screenWidth,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.splashBg1, AppColors.splashBg2])),
        
        child: Stack(
          children: [
            Positioned(
                top: AppDimensions.screenWidth*0.15,
                right:AppDimensions.screenWidth*0.1 ,
                child: StaggeredAnimatedWidget(
                  index: 0,
                  controller: _controller,
                  child: Image.asset("assets/images/splash/m1.png",
                  height: AppDimensions.screenHeight*0.15,
                    width: AppDimensions.screenWidth*0.2,
                  ),
                )),

            Positioned(
                top: AppDimensions.screenWidth*0.3,
                left:AppDimensions.screenWidth*0.1 ,
                child: StaggeredAnimatedWidget(
                  index: 1,
                  controller: _controller,
                  child: Image.asset("assets/images/splash/m2.png",
                    height: AppDimensions.screenHeight*0.1,
                    width: AppDimensions.screenWidth*0.1,
                  ),
                )),

            Positioned(
                bottom: AppDimensions.screenWidth*0.2,
                left:0,
                child: StaggeredAnimatedWidget(
                  index: 2,
                  controller: _controller,
                  child: Image.asset("assets/images/splash/stetho.png",
                    height: AppDimensions.screenHeight*0.3,
                    width: AppDimensions.screenWidth*0.3,
                  ),
                )),

            Positioned(
                bottom: 0,
                right:0,
                child: StaggeredAnimatedWidget(
                  index: 3,
                  controller: _controller,
                  child: Image.asset("assets/images/splash/p1.png",
                    height: AppDimensions.screenHeight*0.15,
                    width: AppDimensions.screenWidth*0.4,
                  ),
                )),

            Center(
              child: StaggeredAnimatedWidget(
                index: 4,
                controller: _controller,
                child: Image.asset("assets/images/splash/splash_logo.png",
                  height: AppDimensions.screenHeight*0.2,
                  width: AppDimensions.screenWidth*0.4,
                ),
              ),
            ),

            Positioned(
              bottom: AppDimensions.screenHeight*0.35,
              left: AppDimensions.screenWidth*0.43,
              child: StaggeredAnimatedWidget(
                index: 5,
                controller: _controller,
                child: Center(
                  child: Text("JNM", style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppColors.splashText,
                    fontFamily: "Poppins"
                  ),),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void setTimerNavigation() async {
    //Navigator.pushReplacementNamed(context, "/OnboardingScreen");
    Navigator.pushNamed(context, "/PatientLoginScreen");
    //Navigator.pushNamed(context, "/LoginScreen");
    // String token = await _pref.getUserAuthToken();
    // bool loginStatus = await _pref.getLoginStatus();
    // String userType = await _pref.getUserType();
    //
    // try {
    //   if (token.length > 10 && loginStatus) {
    //     Navigator.pushReplacementNamed(context, "/BottomNavbar");
    //   }
    //   else{
    //     Navigator.pushReplacementNamed(context, "/SigninScreen");
    //   }
    //
    // } catch (ex) {
    //   Navigator.pushReplacementNamed(context, "/SigninScreen");
    // }
  }



}
