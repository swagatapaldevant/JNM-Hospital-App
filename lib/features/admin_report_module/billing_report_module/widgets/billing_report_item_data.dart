import 'package:flutter/material.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/app_dimensions.dart';
import 'package:jnm_hospital_app/core/utils/helper/screen_utils.dart';

class BillingReportItemData extends StatelessWidget {
  final int? index;
  final String? patientName;
  final String? section;
  final String? uhid;
  final String? opdId;
  final String? uid;
  final String? total;
  final String? mobile;
  final String? grandTotal;
  final String? billingTime;
  final String? appointmentTime;
  final String? doctor;
  final String? discountAmount;
  final String? refundAmount;
  final String? totalPayment;
  final String? dueAmount;


  const BillingReportItemData(
      {super.key,
        this.index,
        this.patientName,
        this.section,
        this.uhid,
        this.opdId,
        this.uid,
        this.total,
        this.mobile,
        this.grandTotal,
        this.billingTime,
        this.appointmentTime,
        this.doctor, this.discountAmount, this.refundAmount, this.totalPayment, this.dueAmount});

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
                    text: 'Department : ',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.colorBlack,
                        fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                          text: section,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: AppColors.colorBlack,
                              fontSize: 14)),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'ID : ',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.colorBlack,
                            fontSize: 14),
                        children: <TextSpan>[
                          TextSpan(
                              text: uhid,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.colorBlack,
                                  fontSize: 14)),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'OPD ID : ',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.colorBlack,
                            fontSize: 14),
                        children: <TextSpan>[
                          TextSpan(
                              text: opdId,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.colorBlack,
                                  fontSize: 14)),
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
                        text: 'UID : ',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.colorBlack,
                            fontSize: 14),
                        children: <TextSpan>[
                          TextSpan(
                              text: uid,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.colorBlack,
                                  fontSize: 14)),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Total : ',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.colorBlack,
                            fontSize: 14),
                        children: <TextSpan>[
                          TextSpan(
                              text: total,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.colorBlack,
                                  fontSize: 14)),
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
                            fontSize: 14),
                        children: <TextSpan>[
                          TextSpan(
                              text: mobile,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.colorBlack,
                                  fontSize: 14)),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Grand total : ',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.colorBlack,
                            fontSize: 14),
                        children: <TextSpan>[
                          TextSpan(
                              text: grandTotal,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.colorBlack,
                                  fontSize: 14)),
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
                        text: 'Discount Amount : ',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.colorBlack,
                            fontSize: 14),
                        children: <TextSpan>[
                          TextSpan(
                              text: discountAmount,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.colorBlack,
                                  fontSize: 14)),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Refund Amount : ',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.colorBlack,
                            fontSize: 14),
                        children: <TextSpan>[
                          TextSpan(
                              text: refundAmount,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.colorBlack,
                                  fontSize: 14)),
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
                        text: 'Total Payment : ',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.colorBlack,
                            fontSize: 14),
                        children: <TextSpan>[
                          TextSpan(
                              text: totalPayment,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.colorBlack,
                                  fontSize: 14)),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Due Amount : ',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.colorBlack,
                            fontSize: 14),
                        children: <TextSpan>[
                          TextSpan(
                              text: dueAmount,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.colorBlack,
                                  fontSize: 14)),
                        ],
                      ),
                    ),
                  ],
                ),
                RichText(
                  text: TextSpan(
                    text: 'Appointment Time : ',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.colorBlack,
                        fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                          text: billingTime,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: AppColors.colorBlack,
                              fontSize: 14)),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: 'Appointment Date : ',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.colorBlack,
                        fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                          text: appointmentTime,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: AppColors.colorBlack,
                              fontSize: 14)),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: 'Doctor : ',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.colorBlack,
                        fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                          text: doctor,
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
