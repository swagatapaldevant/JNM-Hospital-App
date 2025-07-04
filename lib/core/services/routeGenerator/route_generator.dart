import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:jnm_hospital_app/core/utils/helper/app_fontSize.dart';
import 'package:jnm_hospital_app/features/admin_report_module/billing_report_module/presentation/billing_report_screen.dart';
import 'package:jnm_hospital_app/features/admin_report_module/birth_report_module/presentation/birth_report_screen.dart';
import 'package:jnm_hospital_app/features/admin_report_module/dashboard_module/presentation/report_dashboard_screen.dart';
import 'package:jnm_hospital_app/features/admin_report_module/death_report_module/presentation/death_report_screen.dart';
import 'package:jnm_hospital_app/features/admin_report_module/dialysis_patients_report_module/presentation/dialysis_patients_report_screen.dart';
import 'package:jnm_hospital_app/features/admin_report_module/discharge_report_module/presentation/discharge_report_screen.dart';
import 'package:jnm_hospital_app/features/admin_report_module/edit_bill_report_module/presentation/edit_bill_report_screen.dart';
import 'package:jnm_hospital_app/features/admin_report_module/emg_patient_report_module/presentation/emg_patient_report_screen.dart';
import 'package:jnm_hospital_app/features/admin_report_module/ipd_patient_report_module/presentation/ipd_patient_report_screen.dart';
import 'package:jnm_hospital_app/features/admin_report_module/opd_patient_report_module/presentation/landscape_view_screen.dart';
import 'package:jnm_hospital_app/features/admin_report_module/opd_patient_report_module/presentation/opd_patient_report_screen.dart';
import 'package:jnm_hospital_app/features/auth_module/presentation/login_screen.dart';
import 'package:jnm_hospital_app/features/auth_module/presentation/signup_screen.dart';
import 'package:jnm_hospital_app/features/patient_module/booking_history_module/presentation/booking_history_screen.dart';
import 'package:jnm_hospital_app/features/patient_module/booking_module/presentation/booking_payment_screen.dart';
import 'package:jnm_hospital_app/features/patient_module/dashboard_module/presentation/patient_buttom_navigation.dart';
import 'package:jnm_hospital_app/features/patient_module/doctor_details_module/presentation/doctor_details_screen.dart';
import 'package:jnm_hospital_app/features/patient_module/find_doctor_module/presentation/find_doctor_screen.dart';
import 'package:jnm_hospital_app/features/patient_module/top_doctor/presentation/top_doctor_screen.dart';
import 'package:jnm_hospital_app/features/splash_module/presentation/onboarding_auth_screen.dart';
import 'package:jnm_hospital_app/features/splash_module/presentation/onboarding_screen.dart';
import 'package:jnm_hospital_app/features/splash_module/presentation/splash_screen.dart';

class RouteGenerator{

  // general navigation
  static const kSplash = "/";


  static const kOnboardingScreen = "/OnboardingScreen";
  static const kOnboardingAuthScreen = "/OnboardingAuthScreen";

  static const kLoginScreen = "/LoginScreen";
  static const kSignupScreen = "/SignupScreen";


  static const kPatientButtonNavigation = "/PatientButtonNavigation";
  static const kTopDoctorScreen = "/TopDoctorScreen";
  static const kFindDoctorScreen = "/FindDoctorScreen";


  static const kBookingHistoryScreen = "/BookingHistoryScreen";
  static const kDoctorDetailsScreen = "/DoctorDetailsScreen";
  static const kBookingPaymentScreen = "/BookingPaymentScreen";



  static const kReportDashboardScreen = "/ReportDashboardScreen";
  static const kOpdPatientReportScreen = "/OpdPatientReportScreen";
  static const kDepartmentWiseOpdReportLandscapeScreen = "/DepartmentWiseOpdReportLandscapeScreen";
  static const kEmgPatientReportScreen = "/EmgPatientReportScreen";
  static const kDialysisPatientsReportScreen = "/DialysisPatientsReportScreen";
  static const kIpdPatientReportScreen = "/IpdPatientReportScreen";
  static const kBillingReportScreen = "/BillingReportScreen";
  static const kBirthReportScreen = "/BirthReportScreen";
  static const kDeathReportScreen = "/DeathReportScreen";
  static const kDischargeReportScreen = "/DischargeReportScreen";
  static const kEditBillReportScreen = "/EditBillReportScreen";





  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Route<dynamic> generateRoute(RouteSettings settings){

    final args = settings.arguments;
    switch(settings.name){

      case kSplash:
        //return MaterialPageRoute(builder: (_)=>SplashScreen());
        return _animatedPageRoute(SplashScreen());


      case kOnboardingScreen:
        return _animatedPageRoute(OnboardingScreen());
      case kOnboardingAuthScreen:
        return _animatedPageRoute(OnboardingAuthScreen());


      case kLoginScreen:
        return _animatedPageRoute(LoginScreen());
      case kSignupScreen:
        return _animatedPageRoute(SignupScreen());


      case kPatientButtonNavigation:
        return _animatedPageRoute(PatientButtonNavigation());
      case kTopDoctorScreen:
        return _animatedPageRoute(TopDoctorScreen());
      case kFindDoctorScreen:
        return _animatedPageRoute(FindDoctorScreen());


        case kBookingHistoryScreen:
        return _animatedPageRoute(BookingHistoryScreen());
        case kDoctorDetailsScreen:
        return _animatedPageRoute(DoctorDetailsScreen());
        case kBookingPaymentScreen:
        return _animatedPageRoute(BookingPaymentScreen());



        case kReportDashboardScreen:
        return _animatedPageRoute(ReportDashboardScreen());
        case kOpdPatientReportScreen:
        return _animatedPageRoute(OpdPatientReportScreen());
       case kDepartmentWiseOpdReportLandscapeScreen:
        return _animatedPageRoute(DepartmentWiseOpdReportLandscapeScreen());
       case kEmgPatientReportScreen:
        return _animatedPageRoute(EmgPatientReportScreen());
       case kDialysisPatientsReportScreen:
        return _animatedPageRoute(DialysisPatientsReportScreen());
       case kIpdPatientReportScreen:
        return _animatedPageRoute(IpdPatientReportScreen());
       case kBillingReportScreen:
        return _animatedPageRoute(BillingReportScreen());
       case kBirthReportScreen:
        return _animatedPageRoute(BirthReportScreen());
       case kDeathReportScreen:
        return _animatedPageRoute(DeathReportScreen());
       case kDischargeReportScreen:
        return _animatedPageRoute(DischargeReportScreen());
       case kEditBillReportScreen:
        return _animatedPageRoute(EditBillReportScreen());


      default:
        return _errorRoute(errorMessage: "Route not found: ${settings.name}");

    }

  }

  static Route<dynamic> _animatedPageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return page;  // The page to navigate to
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Define the transition animation

        // Slide from the right (Offset animation)
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        final curve = Curves.easeInToLinear;  // A more natural easing curve

        var offsetTween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(offsetTween);

        // Scale transition (page zooms in slightly)
        var scaleTween = Tween(begin: 0.95, end: 1.0);
        var scaleAnimation = animation.drive(scaleTween);

        // Fade transition (opacity increases from 0 to 1)
        var fadeTween = Tween(begin: 0.0, end: 1.0);
        var fadeAnimation = animation.drive(fadeTween);

        // Return a combination of Slide, Fade, and Scale
        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: ScaleTransition(
              scale: scaleAnimation,
              child: Material(
                color: Colors.transparent,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), // Add blur effect
                  child: child,
                ),
              ),
            ),
          ),
        );

      },
    );
  }




  static Route<dynamic> _errorRoute(
      {
        String errorMessage = '',
      }
      ) {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Error",
            style: Theme.of(_)
                .textTheme
                .displayMedium
                ?.copyWith(color: Colors.black),
          ),
        ),
        body: Center(
          child: Column(
            children: [
              Text(
                "Oops something went wrong",
                style: Theme.of(_).textTheme.displayMedium?.copyWith(
                    fontSize: AppFontSize.textExtraLarge,
                    color: Colors.black),
              ),
              Text(
                errorMessage,
                style: Theme.of(_).textTheme.displayMedium?.copyWith(
                    fontSize: AppFontSize.textExtraLarge,
                    color: Colors.black),
              ),
            ],
          ),
        ),
      );
    });
  }
}