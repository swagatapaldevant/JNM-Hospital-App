import 'package:flutter/material.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/app_dimensions.dart';
import 'package:jnm_hospital_app/core/utils/helper/screen_utils.dart';

class OpdPatientItemData extends StatelessWidget {
  const OpdPatientItemData({super.key});

  @override
  Widget build(BuildContext context) {
    AppDimensions.init(context);
    return Container(
      width: ScreenUtils().screenWidth(context),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
        border: Border(
          right: BorderSide(color: AppColors.arrowBackground, width: 6),
          left: BorderSide(color: AppColors.arrowBackground, width: 2),
          top: BorderSide(color: AppColors.arrowBackground, width: 2),
          bottom: BorderSide(color: AppColors.arrowBackground, width: 2),
        )

      ),

      child: Padding(
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
                  TextSpan(text: 'Swagata Pal', style: TextStyle(
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
                  TextSpan(text: 'Cardiology', style: TextStyle(
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
                      TextSpan(text: '412275', style: TextStyle(
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
                      TextSpan(text: '412275', style: TextStyle(
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
                      TextSpan(text: 'Male', style: TextStyle(
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
                      TextSpan(text: '12-01-2025', style: TextStyle(
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
                      TextSpan(text: '9800072183', style: TextStyle(
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
                      TextSpan(text: 'New', style: TextStyle(
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
                  TextSpan(text: '24-05-2025', style: TextStyle(
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
                  TextSpan(text: '12:00 AM', style: TextStyle(
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
                  TextSpan(text: 'Dr. Subir Sen', style: TextStyle(
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
    );
  }
}
