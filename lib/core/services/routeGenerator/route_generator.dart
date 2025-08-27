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
import 'package:jnm_hospital_app/features/login_type_selection/ui/login_type_selection_screen.dart';
import 'package:jnm_hospital_app/features/patient_module/doctor_details_module/ui/doctor_details_screen.dart';
import 'package:jnm_hospital_app/features/patient_module/investigation/ui/investigation_screen.dart';
import 'package:jnm_hospital_app/features/patient_module/model/dashboard/doctor_model.dart';
import 'package:jnm_hospital_app/features/patient_module/model/patient_details/patient_details_model.dart';
import 'package:jnm_hospital_app/features/patient_module/new%20patient_module/patient_dashboard/ui/patient_dashboard_screen.dart';
import 'package:jnm_hospital_app/features/patient_module/patient_details_module/ui/patient_bill_details_screen.dart';
import 'package:jnm_hospital_app/features/patient_module/patient_details_module/ui/patient_daycare_details_screen.dart';
import 'package:jnm_hospital_app/features/patient_module/patient_details_module/ui/patient_details_screen.dart';
import 'package:jnm_hospital_app/features/patient_module/patient_details_module/ui/patient_emg_details_screen.dart';
import 'package:jnm_hospital_app/features/patient_module/patient_details_module/ui/patient_emr_details_screen.dart';
import 'package:jnm_hospital_app/features/patient_module/patient_details_module/ui/patient_opd_details_screen.dart';
import 'package:jnm_hospital_app/features/patient_module/patient_details_module/ui/patient_receipt_details_screen.dart';
import 'package:jnm_hospital_app/features/patient_module/patient_login/ui/patient_login_screen.dart';
import 'package:jnm_hospital_app/features/patient_module/patient_opd_module/ui/appointment_form_screen.dart';
import 'package:jnm_hospital_app/features/patient_module/patient_opd_module/ui/opd_registration.dart';
import 'package:jnm_hospital_app/features/patient_module/patient_opd_module/ui/patient_opd_screen.dart';
import 'package:jnm_hospital_app/features/patient_module/patient_rate_enquiry/rate_enquiry_screen.dart';
import 'package:jnm_hospital_app/features/splash_module/presentation/onboarding_auth_screen.dart';
import 'package:jnm_hospital_app/features/splash_module/presentation/onboarding_screen.dart';
import 'package:jnm_hospital_app/features/splash_module/presentation/splash_screen.dart';

class RouteGenerator{

  // general navigation
  static const kSplash = "/";


  static const kRoleSelectionScreen = "/RoleSelectionScreen";


  static const kOnboardingScreen = "/OnboardingScreen";
  static const kOnboardingAuthScreen = "/OnboardingAuthScreen";

  static const kLoginScreen = "/LoginScreen";
  static const kPatientLoginScreen = "/PatientLoginScreen";
  static const kSignupScreen = "/SignupScreen";


  static const kPatientDashboardScreen = "/PatientDashboardScreen";




  static const kPatientButtonNavigation = "/PatientButtonNavigation";
  static const kTopDoctorScreen = "/TopDoctorScreen";
  static const kFindDoctorScreen = "/FindDoctorScreen";
  static const kBookingHistoryScreen = "/BookingHistoryScreen";
  //static const kDoctorDetailsScreen = "/DoctorDetailsScreen";
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

  static const kPatientDetailsScreen = "/PatientDetailsScreen";
  static const kPatientBillDetailsScreen = "/PatientBillDetailsScreen";
  static const kPatientReceiptDetailsScreen = "/PatientReceiptDetailsScreen";
  static const kPatientOpdDetailsScreen = "/PatientOpdDetailsScreen";
  static const kPatientDaycareDetailsScreen = "/PatientDaycareDetailsScreen";
  static const kPatientOPDScreen = "/PatientOPDScreen";
  static const kOPDBookAppointmentScreen = "/OPDBookAppointmentScreen";
  static const kPatientEmgDetailsScreen = "/PatientEmgDetailsScreen";
  static const kPatientEmrDetailsScreen = "/PatientEmrDetailsScreen";
  static const kDoctorDetailsScreen = "/DoctorDetailsScreen";
  static const kRateEnquiryScreen = "/RateEnquiryScreen";
  static const kInvestigationScreen = "/InvestigationScreen";
  static const kOPDRegistrationScreen = "/OPDRegistrationScreen";

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Route<dynamic> generateRoute(RouteSettings settings){

    final args = settings.arguments;
    switch(settings.name){

      case kSplash:
        //return MaterialPageRoute(builder: (_)=>SplashScreen());
        return _animatedPageRoute(SplashScreen());


      case kRoleSelectionScreen:
        return _animatedPageRoute(RoleSelectionScreen());
      case kOnboardingScreen:
        return _animatedPageRoute(OnboardingScreen());

      case kOnboardingAuthScreen:
        return _animatedPageRoute(OnboardingAuthScreen());


      case kLoginScreen:
        return _animatedPageRoute(LoginScreen());
      case kPatientLoginScreen:
        return _animatedPageRoute(PatientLoginScreen());
      case kSignupScreen:
        return _animatedPageRoute(SignupScreen());

      case kPatientDashboardScreen:
        return _animatedPageRoute(PatientDashboardScreen());

      case kPatientBillDetailsScreen:
        final args = settings.arguments as List<BillDetail>;
        return _animatedPageRoute(PatientBillsListScreen( bills: args,));
      case kPatientReceiptDetailsScreen:
        final args = settings.arguments as List<ReceiptDetail>;
        return _animatedPageRoute(PatientReceiptsListScreen(receipts: args,));
      case kPatientOpdDetailsScreen:
        final args = settings.arguments as List<OpdDetailsModel>;
        return _animatedPageRoute(PatientOpdDetailsScreen(opdList: args,));
      case kPatientDaycareDetailsScreen:
        final args = settings.arguments as List<DaycareDetailsModel>;
        return _animatedPageRoute(PatientDaycareDetailsScreen(dayCareList: args,));
      case kPatientEmgDetailsScreen:
        final args = settings.arguments as List<EmgDetailsModel>;
        return _animatedPageRoute(PatientEmgDetailsScreen(emgList: args,));
      case kPatientEmrDetailsScreen:
        final args = settings.arguments as List<EmrDetailsModel>;
        return _animatedPageRoute(PatientEmrDetailsScreen(emrList: args,));
      case kDoctorDetailsScreen:
        return _animatedPageRoute(DoctorDetailsScreen(doctorDetails: args as DoctorModel,));
      case kOPDRegistrationScreen:
        return _animatedPageRoute(OpdRegistration());
      // case kPatientButtonNavigation:
      //   return _animatedPageRoute(PatientButtonNavigation());
      // case kTopDoctorScreen:
      //   return _animatedPageRoute(TopDoctorScreen());
      // case kFindDoctorScreen:
      //   return _animatedPageRoute(FindDoctorScreen());
      //   case kBookingHistoryScreen:
      //   return _animatedPageRoute(BookingHistoryScreen());
      //   case kDoctorDetailsScreen:
      //   return _animatedPageRoute(DoctorDetailsScreen());
      //   case kBookingPaymentScreen:
      //   return _animatedPageRoute(BookingPaymentScreen());



        case kReportDashboardScreen:
        return _animatedPageRoute(ReportDashboardScreen());
        case kOpdPatientReportScreen:
        return _animatedPageRoute(OpdPatientReportScreen());
       case kDepartmentWiseOpdReportLandscapeScreen:
         final args = settings.arguments as Map<String, dynamic>;
        return _animatedPageRoute(DepartmentWiseOpdReportLandscapeScreen(
          newCount: args["newCount"],
          oldCount: args["oldCount"],
          departmentName: args["departmentName"],
        ));
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
       case kPatientDetailsScreen:
        return _animatedPageRoute(PatientDetailsScreen());
      case kPatientOPDScreen:
        return _animatedPageRoute(PatientOPDScreen());
      case kOPDBookAppointmentScreen:
        return _animatedPageRoute(AppointmentFormScreen());
      case kRateEnquiryScreen:
        return _animatedPageRoute(RateEnquiryScreen());
      case kInvestigationScreen:
        return _animatedPageRoute(InvestigationScreen());

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