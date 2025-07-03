import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/app_dimensions.dart';
import 'package:jnm_hospital_app/core/utils/helper/screen_utils.dart';
import 'package:jnm_hospital_app/features/admin_report_module/dashboard_module/widgets/statistical_graph.dart';

class ReportDashboardScreen extends StatefulWidget {
  const ReportDashboardScreen({super.key});

  @override
  State<ReportDashboardScreen> createState() => _ReportDashboardScreenState();
}

class _ReportDashboardScreenState extends State<ReportDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    AppDimensions.init(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            header(),
            SizedBox(
              height: AppDimensions.contentGap1,
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: AppDimensions.screenPadding,
                  left: AppDimensions.screenPadding,
                  right: AppDimensions.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StatisticalGraph(
                    weekDays: [
                      "2018",
                      "2019",
                      "2020",
                      "2021",
                      "2022",
                      "2023",
                      "2024",
                      "2025"
                    ],
                    blueData: [100, 300, 700, 200, 400, 900, 1200, 500],
                    text: "Performance graph year wise",
                  ),
                  SizedBox(
                    height: AppDimensions.contentGap2,
                  ),
                  Text(
                    "Patient & Billing Reports",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.colorBlack),
                  ),
                  SizedBox(
                    height: AppDimensions.contentGap3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      dashboardItem("assets/images/admin_report/opd.png",
                          "OPD Patient Report", onTap: () {
                        Navigator.pushNamed(context, "/OpdPatientReportScreen");
                        }, ),
                      dashboardItem("assets/images/admin_report/emg.png",
                          "EMG Patient Report", onTap: () {
                        Navigator.pushNamed(context, "/EmgPatientReportScreen");
                          }),
                      dashboardItem("assets/images/admin_report/ipd.png",
                          "IPD/DAYCARE Patient Report", onTap: () {
                        Navigator.pushNamed(context, "/IpdPatientReportScreen");
                          }),
                    ],
                  ),
                  SizedBox(
                    height: AppDimensions.contentGap3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      dashboardItem("assets/images/admin_report/dialysis.png",
                          "Dialysis Report", onTap: () {
                            Navigator.pushNamed(context, "/DialysisPatientsReportScreen");
                          }),
                      dashboardItem("assets/images/admin_report/billing.png",
                          "Billing Report", onTap: () {
                        Navigator.pushNamed(context, "/BillingReportScreen");
                          }),
                      dashboardItem(
                          "assets/images/admin_report/birth_report.png",
                          "Birth Report", onTap: () {
                            Navigator.pushNamed(context, "/BirthReportScreen");
                      }),
                    ],
                  ),
                  SizedBox(
                    height: AppDimensions.contentGap3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      dashboardItem(
                          "assets/images/admin_report/death_report.png",
                          "Death Report", onTap: () {  }),
                      dashboardItem("assets/images/admin_report/discharge.png",
                          "Discharge Report", onTap: () {  }),
                      dashboardItem(
                          "assets/images/admin_report/edited_bill.png",
                          "Edited Bill Report", onTap: () {  }),
                    ],
                  ),
                  SizedBox(
                    height: AppDimensions.contentGap2,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // dashboard header section
  Widget header() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: ScreenUtils().screenHeight(context) * 0.3,
          width: ScreenUtils().screenWidth(context),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
            color: AppColors.overviewCardBgColor,
            boxShadow: [
              BoxShadow(
                color: AppColors.colorBlack.withOpacity(0.25),
                offset: const Offset(
                  0.0,
                  4.0,
                ),
                blurRadius: 4.0,
                spreadRadius: 0.0,
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.screenPadding,
                  vertical: AppDimensions.screenWidth * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                            fontSize: 14),
                      ),
                      Text(
                        "DHIRAJ KHADKA",
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: AppColors.white,
                            fontSize: 18),
                      ),
                      Text(
                        "ADMIN",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppColors.white,
                            fontSize: 14),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        "https://www.shutterstock.com/image-photo/head-shot-portrait-close-smiling-600nw-1714666150.jpg",
                        height: AppDimensions.screenHeight * 0.06,
                        width: AppDimensions.screenWidth * 0.15,
                        fit: BoxFit.fill,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: AppDimensions.screenWidth * 0.05,
          right: AppDimensions.screenWidth * 0.05,
          bottom: -AppDimensions.screenHeight * 0.06,
          child: Container(
            width: AppDimensions.screenWidth * 0.9,
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.colorBlack.withOpacity(0.25),
                  offset: const Offset(
                    0.0,
                    4.0,
                  ),
                  blurRadius: 4.0,
                  spreadRadius: 0.0,
                )
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.screenWidth * 0.05,
                  vertical: AppDimensions.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Today's Overview",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.colorBlack),
                  ),
                  SizedBox(
                    height: AppDimensions.contentGap2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      overviewCard("6", "REPORTS \nTODAY"),
                      overviewCard("240", "TOTAL \nPATIENTS"),
                      overviewCard("3.40L", "TOTAL \nREVENUE"),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: AppDimensions.screenHeight * 0.03,
          right: AppDimensions.screenWidth * 0.25,
          child: Image.asset(
            "assets/images/admin_report/stethoscope.png",
            height: ScreenUtils().screenHeight(context) * 0.1,
            width: ScreenUtils().screenWidth(context) * 0.1,
          ),
        ),
        Positioned(
          top: AppDimensions.screenHeight * 0.03,
          left: AppDimensions.screenWidth * 0.3,
          child: Image.asset(
            "assets/images/admin_report/medical.png",
            height: ScreenUtils().screenHeight(context) * 0.06,
            width: ScreenUtils().screenWidth(context) * 0.06,
          ),
        ),
        Positioned(
          top: AppDimensions.screenHeight * 0.1,
          left: AppDimensions.screenWidth * 0.45,
          child: Image.asset(
            "assets/images/admin_report/pills.png",
            height: ScreenUtils().screenHeight(context) * 0.07,
            width: ScreenUtils().screenWidth(context) * 0.07,
          ),
        )
      ],
    );
  }

  // dashboard card section
  Widget dashBoardCard() {
    return Container(
      width: ScreenUtils().screenWidth(context),
      height: ScreenUtils().screenHeight(context) * 0.2,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColors.colorBlack.withOpacity(0.25),
              offset: const Offset(
                0.0,
                4.0,
              ),
              blurRadius: 4.0,
              spreadRadius: 0.0,
            )
          ],
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.reportDashboardCardGrad1,
                AppColors.reportDashboardCardGrad2,
              ])),
      child: Padding(
        padding: EdgeInsets.only(left: AppDimensions.screenPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Hospital \nInsights & \nAnalytics \nDashboard",
              style: TextStyle(
                  shadows: [
                    Shadow(
                      blurRadius: 4.0, // shadow blur
                      color: AppColors.colorBlack
                          .withOpacity(0.36), // shadow color
                      offset: Offset(0.0, 4.0), // how much shadow will be shown
                    ),
                  ],
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white),
            ),
            Image.asset(
              "assets/images/admin_report/dashboard_card.png",
              width: AppDimensions.screenWidth * 0.55,
            )
          ],
        ),
      ),
    );
  }

  // dashboard item
  Widget dashboardItem(String imageLink, String text, {required Function() onTap}) {
    return Bounceable(
      onTap: onTap,
      child: Container(
        height: ScreenUtils().screenHeight(context) * 0.17,
        width: ScreenUtils().screenWidth(context) * 0.27,
        decoration: BoxDecoration(
          color: AppColors.reportDashboardCategoryBg,
          boxShadow: [
            BoxShadow(
              color: AppColors.colorBlack.withOpacity(0.25),
              offset: const Offset(
                0.0,
                4.0,
              ),
              blurRadius: 4.0,
              spreadRadius: 0.0,
            )
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(ScreenUtils().screenWidth(context) * 0.03),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset(imageLink),
              ),
              Text(
                text,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.colorBlack,
                    fontSize: 10),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget overviewCard(String value, String text) {
    return Container(
      width: ScreenUtils().screenWidth(context) * 0.24,
      decoration: BoxDecoration(
        color: AppColors.overviewCardBgColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.colorBlack.withOpacity(0.25),
            offset: const Offset(
              5.0,
              5.0,
            ),
            blurRadius: 7.0,
            spreadRadius: 0.0,
          ),
          BoxShadow(
            color: AppColors.colorBlack.withOpacity(0.25),
            offset: const Offset(
              1.0,
              3.0,
            ),
            blurRadius: 3.0,
            spreadRadius: 0.0,
          ),
          BoxShadow(
            color: AppColors.white.withOpacity(0.79),
            offset: const Offset(
              -2.0,
              0.0,
            ),
            blurRadius: 4.0,
            spreadRadius: 0.0,
          ),
          BoxShadow(
            color: AppColors.white.withOpacity(0.40),
            offset: const Offset(
              2.0,
              0.0,
            ),
            blurRadius: 6.0,
            spreadRadius: 0.0,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(ScreenUtils().screenWidth(context) * 0.02),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: AppColors.white),
            ),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                  color: AppColors.white),
            )
          ],
        ),
      ),
    );
  }
}
