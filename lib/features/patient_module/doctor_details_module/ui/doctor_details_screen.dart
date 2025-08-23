import 'package:flutter/material.dart';
import 'package:jnm_hospital_app/features/patient_module/model/dashboard/doctor_model.dart';

class DoctorDetailsScreen extends StatefulWidget {
  DoctorModel doctorDetails;
   DoctorDetailsScreen({super.key, required this.doctorDetails});

  @override
  State<DoctorDetailsScreen> createState() => _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends State<DoctorDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}
