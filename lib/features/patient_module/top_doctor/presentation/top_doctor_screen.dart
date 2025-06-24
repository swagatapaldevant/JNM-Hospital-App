import 'package:flutter/material.dart';
import 'package:jnm_hospital_app/core/utils/commonWidgets/common_header.dart';
import 'package:jnm_hospital_app/core/utils/helper/app_dimensions.dart';
import 'package:jnm_hospital_app/features/patient_module/top_doctor/widget/top_doctor_widget.dart';

class TopDoctorScreen extends StatefulWidget {
  const TopDoctorScreen({super.key});

  @override
  State<TopDoctorScreen> createState() => _TopDoctorScreenState();
}

class _TopDoctorScreenState extends State<TopDoctorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:  EdgeInsets.all(
                  AppDimensions.screenPadding,

              ),
              child: CommonHeader(
                screenName: 'Top Doctor',
              ),
            ),

            Expanded(
              child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index){
                return Padding(
                  padding:  EdgeInsets.only(
                      left:AppDimensions.screenPadding,
                      right: AppDimensions.screenPadding,
                      top: AppDimensions.screenPadding
                  ),
                  child: TopDoctorWidget(
                    onTap: (){
                        Navigator.pushNamed(context, "/DoctorDetailsScreen");

                    },
                  ),
                );
              }),
            )

          ],
        ),
      ),
    );
  }
}
