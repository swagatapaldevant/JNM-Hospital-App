import 'package:flutter/material.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/app_dimensions.dart';
import 'package:jnm_hospital_app/core/utils/helper/screen_utils.dart';

class OpdPatientItemData extends StatelessWidget {
  final int? index;
  final String? patientName;
  final String? department;
  final String? uhid;
  final String? opdId;
  final String? gender;
  final String? age;
  final String? mobile;
  final String? visitType;
  final String? appointmentDate;
  final String? appointmentTime;
  final String? doctor;
  const OpdPatientItemData({super.key, this.index, this.patientName, this.department, this.uhid, this.opdId, this.gender, this.age, this.mobile, this.visitType, this.appointmentDate, this.appointmentTime, this.doctor});

  @override
  Widget build(BuildContext context) {
    AppDimensions.init(context);
    return Container(
      width: ScreenUtils().screenWidth(context),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border(
          right: BorderSide(color: AppColors.arrowBackground, width: index!%2==0?10:2),
          left: BorderSide(color: AppColors.arrowBackground, width: index!%2!=0?10:2),
          top: BorderSide(color: AppColors.arrowBackground, width: 2),
          bottom: BorderSide(color: AppColors.arrowBackground, width: 2),
        )

      ),

      child: Stack(
        children: [
          Center(child: Image.asset("assets/images/admin_report/stetho1.png", height: ScreenUtils().screenHeight(context)*0.25,width: ScreenUtils().screenWidth(context)*0.5,)),
          Padding(
            padding:  EdgeInsets.all(AppDimensions.screenPadding),
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
                      fontSize: 14
                    ),
                    children:  <TextSpan>[
                      TextSpan(text: patientName, style: TextStyle(
                          fontWeight: FontWeight.w400,
                        color: AppColors.colorBlack,
                        fontSize: 14
                      )),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: 'Department : ',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.colorBlack,
                      fontSize: 14
                    ),
                    children:  <TextSpan>[
                      TextSpan(text: department, style: TextStyle(
                          fontWeight: FontWeight.w400,
                        color: AppColors.colorBlack,
                        fontSize: 14
                      )),
                    ],
                  ),
                ),
          
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'UHID : ',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.colorBlack,
                            fontSize: 14
                        ),
                        children:  <TextSpan>[
                          TextSpan(text: uhid, style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: AppColors.colorBlack,
                              fontSize: 14
                          )),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'OPD ID : ',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.colorBlack,
                            fontSize: 14
                        ),
                        children:  <TextSpan>[
                          TextSpan(text: opdId, style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: AppColors.colorBlack,
                              fontSize: 14
                          )),
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
                        text: 'Gender : ',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.colorBlack,
                            fontSize: 14
                        ),
                        children:  <TextSpan>[
                          TextSpan(text: gender, style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: AppColors.colorBlack,
                              fontSize: 14
                          )),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Age : ',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.colorBlack,
                            fontSize: 14
                        ),
                        children:  <TextSpan>[
                          TextSpan(text:age, style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: AppColors.colorBlack,
                              fontSize: 14
                          )),
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
                            fontSize: 14
                        ),
                        children:  <TextSpan>[
                          TextSpan(text: mobile, style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: AppColors.colorBlack,
                              fontSize: 14
                          )),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Visit Type : ',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.colorBlack,
                            fontSize: 14
                        ),
                        children:  <TextSpan>[
                          TextSpan(text: visitType, style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: AppColors.colorBlack,
                              fontSize: 14
                          )),
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
                        fontSize: 14
                    ),
                    children:  <TextSpan>[
                      TextSpan(text: appointmentDate, style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: AppColors.colorBlack,
                          fontSize: 14
                      )),
                    ],
                  ),
                ),
          
                RichText(
                  text: TextSpan(
                    text: 'Appointment Time : ',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.colorBlack,
                        fontSize: 14
                    ),
                    children:  <TextSpan>[
                      TextSpan(text: appointmentTime, style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: AppColors.colorBlack,
                          fontSize: 14
                      )),
                    ],
                  ),
                ),
          
                RichText(
                  text: TextSpan(
                    text: 'Doctor : ',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.colorBlack,
                        fontSize: 14
                    ),
                    children:  <TextSpan>[
                      TextSpan(text: doctor, style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: AppColors.colorBlack,
                          fontSize: 14
                      )),
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
