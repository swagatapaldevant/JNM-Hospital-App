import 'package:flutter/material.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/app_dimensions.dart';
import 'package:jnm_hospital_app/core/utils/helper/screen_utils.dart';

class IpdPatientItemData extends StatelessWidget {
  final int? index;
  final String? patientName;
  final String? department;
  final String? admissionType;
  final String? gender;
  final String? dobYear;
  final String? mobile;
  final String? appointmentDate;
  final String? doctor;
  final String? departmentName;
  final String? wardName;
  final String? bedName;
  final String? tpaName;

  const IpdPatientItemData(
      {super.key,
      this.index,
      this.patientName,
      this.department,
      this.admissionType,
      this.gender,
      this.dobYear,
      this.mobile,
      this.appointmentDate,
      this.departmentName,
      this.wardName,
      this.bedName,
      this.tpaName,
      this.doctor});

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
            height: ScreenUtils().screenHeight(context) * 0.25,
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
                    text: 'Patient Name : ',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.colorBlack,
                        fontSize: 13),
                    children: <TextSpan>[
                      TextSpan(
                          text: patientName,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: AppColors.colorBlack,
                              fontSize: 12)),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: 'Department : ',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.colorBlack,
                        fontSize: 13),
                    children: <TextSpan>[
                      TextSpan(
                          text: department,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: AppColors.colorBlack,
                              fontSize: 12)),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: 'Admission Type : ',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.colorBlack,
                        fontSize: 13),
                    children: <TextSpan>[
                      TextSpan(
                          text: admissionType,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: AppColors.colorBlack,
                              fontSize: 12)),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: 'Department name : ',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.colorBlack,
                        fontSize: 13),
                    children: <TextSpan>[
                      TextSpan(
                          text: departmentName,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: AppColors.colorBlack,
                              fontSize: 12)),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'Gender : ',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.colorBlack,
                            fontSize: 13),
                        children: <TextSpan>[
                          TextSpan(
                              text: gender,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.colorBlack,
                                  fontSize: 12)),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'DOB Year : ',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.colorBlack,
                            fontSize: 13),
                        children: <TextSpan>[
                          TextSpan(
                              text: dobYear,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.colorBlack,
                                  fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'Mobile : ',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.colorBlack,
                            fontSize: 13),
                        children: <TextSpan>[
                          TextSpan(
                              text: mobile,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.colorBlack,
                                  fontSize: 12)),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Tpa : ',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.colorBlack,
                            fontSize: 13),
                        children: <TextSpan>[
                          TextSpan(
                              text: tpaName,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.colorBlack,
                                  fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'Ward : ',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.colorBlack,
                            fontSize: 13),
                        children: <TextSpan>[
                          TextSpan(
                              text: wardName,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.colorBlack,
                                  fontSize: 12)),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Bed : ',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.colorBlack,
                            fontSize: 13),
                        children: <TextSpan>[
                          TextSpan(
                              text: bedName,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.colorBlack,
                                  fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
                RichText(
                  text: TextSpan(
                    text: 'Appointment Date : ',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.colorBlack,
                        fontSize: 13),
                    children: <TextSpan>[
                      TextSpan(
                          text: appointmentDate,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: AppColors.colorBlack,
                              fontSize: 12)),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: 'Doctor : ',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.colorBlack,
                        fontSize: 13),
                    children: <TextSpan>[
                      TextSpan(
                          text: doctor,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: AppColors.colorBlack,
                              fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
