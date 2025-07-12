import 'package:flutter/material.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/app_dimensions.dart';
import 'package:jnm_hospital_app/core/utils/helper/screen_utils.dart';

class DeathReportItem extends StatelessWidget {
  final int? index;
  final String? patientId;
  final String? patientName;
  final String? gender;
  final String? doctorName;
  final String? admDate;
  final String? disChargeDate;


  const DeathReportItem({
    super.key, this.index, this.patientId, this.patientName, this.gender, this.doctorName, this.admDate, this.disChargeDate,

  });

  @override
  Widget build(BuildContext context) {
    AppDimensions.init(context);
    return Container(
      width: ScreenUtils().screenWidth(context),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border(
            right: BorderSide(
                color: AppColors.arrowBackground,
                width: index! % 2 == 0 ? 10 : 2),
            left: BorderSide(
                color: AppColors.arrowBackground,
                width: index! % 2 != 0 ? 10 : 2),
            top: BorderSide(color: AppColors.arrowBackground, width: 2),
            bottom: BorderSide(color: AppColors.arrowBackground, width: 2),
          )),
      child: Stack(
        children: [
          Center(
              child: Image.asset(
            "assets/images/admin_report/stetho1.png",
            height: ScreenUtils().screenHeight(context) * 0.22,
            width: ScreenUtils().screenWidth(context) * 0.5,
          )),
          Padding(
            padding: EdgeInsets.all(AppDimensions.screenPadding),
            child: Column(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Patient Id : ',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.colorBlack,
                        fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                          text: patientId,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: AppColors.colorBlack,
                              fontSize: 14)),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: 'Patient Name : ',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.colorBlack,
                        fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                          text: patientName,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: AppColors.colorBlack,
                              fontSize: 14)),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: 'Gender : ',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.colorBlack,
                        fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                          text: gender,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: AppColors.colorBlack,
                              fontSize: 14)),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: 'Doctor name : ',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.colorBlack,
                        fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                          text: doctorName,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: AppColors.colorBlack,
                              fontSize: 14)),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: 'Admission Date : ',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.colorBlack,
                        fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                          text: admDate,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: AppColors.colorBlack,
                              fontSize: 14)),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: 'Discharge Date : ',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.colorBlack,
                        fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                          text: disChargeDate,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: AppColors.colorBlack,
                              fontSize: 14)),
                    ],
                  ),
                )

              ],
            ),
          ),
        ],
      ),
    );
  }
}
