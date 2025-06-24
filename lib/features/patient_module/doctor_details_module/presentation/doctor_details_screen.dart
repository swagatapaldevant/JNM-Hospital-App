import 'package:flutter/material.dart';
import 'package:jnm_hospital_app/core/utils/commonWidgets/common_button.dart';
import 'package:jnm_hospital_app/core/utils/commonWidgets/common_header.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/app_dimensions.dart';
import 'package:jnm_hospital_app/features/patient_module/dashboard_module/widgets/dashboard_heading.dart';
import 'package:jnm_hospital_app/features/patient_module/doctor_details_module/widgets/date_section_widget.dart';
import 'package:jnm_hospital_app/features/patient_module/doctor_details_module/widgets/read_more_text_widget.dart';
import 'package:jnm_hospital_app/features/patient_module/doctor_details_module/widgets/time_slot_selector.dart';

class DoctorDetailsScreen extends StatefulWidget {
  const DoctorDetailsScreen({super.key});

  @override
  State<DoctorDetailsScreen> createState() => _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends State<DoctorDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    AppDimensions.init(context);
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
              child: Column(
        children: [
          Padding(
              padding: EdgeInsets.only(
                  left: AppDimensions.screenPadding,
                  right: AppDimensions.screenPadding,
                  top: AppDimensions.screenPadding),
              child: Column(children: [
                CommonHeader(
                  screenName: 'Doctor details',
                ),
                SizedBox(
                  height: AppDimensions.contentGap2,
                ),
                Row(
                  spacing: AppDimensions.contentGap3,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        "https://img.freepik.com/free-photo/portrait-experienced-professional-therapist-with-stethoscope-looking-camera_1098-19305.jpg?semt=ais_hybrid&w=740",
                        height: AppDimensions.screenHeight * 0.13,
                        width: AppDimensions.screenHeight * 0.13,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Column(
                      spacing: 2,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Dr. Marcus Horizon",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.colorBlack,
                              fontSize: 16),
                        ),
                        Text(
                          "Cardiologist",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: AppColors.gray8,
                              fontSize: 10),
                        ),
                        SizedBox(
                          height: AppDimensions.screenHeight * 0.01,
                        ),
                        rating(),
                        distance()
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: AppDimensions.contentGap3,
                ),
                DashboardHeading(
                  headingName: 'About',
                  isSeeAllVisible: false,
                ),
                SizedBox(
                  height: AppDimensions.screenHeight * 0.01,
                ),
                ReadMoreText(
                  text:
                      "Lorem ipsum dolor sit amet, Lorem ipsum dolor sit amet,  Lorem ipsum dolor sit amet,  consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam...",
                  trimLines: 3,
                ),
                SizedBox(
                  height: AppDimensions.contentGap3,
                ),
              ])),
          SizedBox(
            height: AppDimensions.contentGap3,
          ),
          Padding(
            padding: EdgeInsets.only(left: AppDimensions.screenPadding),
            child: DateSelector(),
          ),
          SizedBox(
            height: AppDimensions.contentGap3,
          ),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: AppDimensions.screenPadding),
            child: Column(
              children: [
                Divider(
                  color: AppColors.starBackgroundColor,
                ),
                SizedBox(
                  height: AppDimensions.contentGap3,
                ),
                TimeSlotSelector(),
                SizedBox(
                  height: AppDimensions.contentGap1,
                ),SizedBox(
                  height: AppDimensions.contentGap1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: AppDimensions.buttonHeight,
                      width: AppDimensions.buttonHeight,
                      decoration: BoxDecoration(
                          color: AppColors.starBackgroundColor,
                          borderRadius:BorderRadius.circular(10)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset("assets/images/find_doctors/Chat.png"),
                      ),
                    ),
                    CommonButton(
                      onTap: (){
                        Navigator.pushNamed(context, "/BookingPaymentScreen");
                      },
                        width: AppDimensions.screenWidth*0.7,
                        buttonName: "Book Appointment")
                  ],
                )
              ],
            ),
          ),


        ],
      ))),
    );
  }

  Widget rating() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: AppColors.starBackgroundColor),
      child: Padding(
        padding: EdgeInsets.all(4.0),
        child: Row(
          spacing: 4,
          children: [
            Icon(
              Icons.star,
              color: AppColors.starColor,
              size: 14,
            ),
            Text(
              "4.7",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.starColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget distance() {
    return Row(
      spacing: 2,
      children: [
        Icon(
          Icons.location_on,
          color: AppColors.gray8,
          size: 15,
        ),
        Text(
          "800m away",
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.gray8),
        ),
      ],
    );
  }
}
