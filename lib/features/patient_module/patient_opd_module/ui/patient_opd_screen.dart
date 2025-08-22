import 'package:flutter/material.dart';
import 'package:jnm_hospital_app/core/services/routeGenerator/route_generator.dart';
import 'package:jnm_hospital_app/core/utils/commonWidgets/common_button.dart';
import 'package:jnm_hospital_app/features/patient_module/patient_details_module/ui/common_layout.dart';

class PatientOPDScreen extends StatefulWidget {
  const PatientOPDScreen({super.key});

  @override
  State<PatientOPDScreen> createState() => _PatientOPDScreenState();
}

class _PatientOPDScreenState extends State<PatientOPDScreen> {
  void onPressed() {
    Navigator.pushNamed(context, RouteGenerator.kOPDBookAppointmentScreen);
  }

  @override
  Widget build(BuildContext context) {
    return PatientDetailsScreenLayout(
      heading: "OPD page",
      child:  SliverToBoxAdapter(
        child: CommonButton(
            onTap: onPressed, buttonName: "Book New Appointment"),
      ),
    );
  }
}
