import 'package:flutter/material.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/app_dimensions.dart';
import 'package:jnm_hospital_app/core/utils/helper/screen_utils.dart';

class BirthReportItem extends StatelessWidget {
  final int? index;
  final String? name;
  final String? gender;
  final String? address;
  final String? guardianName;
  final String? doctorName;
  final String? dob;
  final String? weight;
  final String? diagnosis;
  final String? operation;
  final String? deliveryMode;
  final String? creDate;

  const BirthReportItem(
      {super.key,
        this.index, this.name, this.gender, this.address, this.guardianName, this.doctorName, this.dob, this.weight, this.diagnosis, this.operation, this.deliveryMode, this.creDate,

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
                    text: 'Name : ',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.colorBlack,
                        fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                          text: name,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: AppColors.colorBlack,
                              fontSize: 14)),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: 'Guardian Name : ',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.colorBlack,
                        fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                          text: guardianName,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: AppColors.colorBlack,
                              fontSize: 14)),
                    ],
                  ),
                ),

                RichText(
                  text: TextSpan(
                    text: 'Address : ',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.colorBlack,
                        fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                          text: address,
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
                    text: 'Doctor Name : ',
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
                    text: 'Dob : ',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.colorBlack,
                        fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                          text: dob,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: AppColors.colorBlack,
                              fontSize: 14)),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: 'Weight : ',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.colorBlack,
                        fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                          text: weight,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: AppColors.colorBlack,
                              fontSize: 14)),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: 'Diagnosis : ',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.colorBlack,
                        fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                          text: diagnosis,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: AppColors.colorBlack,
                              fontSize: 14)),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: 'Operation : ',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.colorBlack,
                        fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                          text: operation,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: AppColors.colorBlack,
                              fontSize: 14)),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: 'Delivery Mode : ',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.colorBlack,
                        fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                          text: deliveryMode,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: AppColors.colorBlack,
                              fontSize: 14)),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: 'Created Date : ',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.colorBlack,
                        fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                          text: creDate,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: AppColors.colorBlack,
                              fontSize: 14)),
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
