import 'package:flutter/material.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/app_dimensions.dart';
import 'package:jnm_hospital_app/core/utils/helper/screen_utils.dart';
import 'package:jnm_hospital_app/features/patient_module/dashboard_module/widgets/dashboard_heading.dart';

class ReportModuleScreen extends StatefulWidget {
  const ReportModuleScreen({super.key});

  @override
  State<ReportModuleScreen> createState() => _ReportModuleScreenState();
}

class _ReportModuleScreenState extends State<ReportModuleScreen> {
  @override
  Widget build(BuildContext context) {
    AppDimensions.init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Personal Report", style: TextStyle(
            fontSize: 20,
            fontFamily: "Roboto",
            fontWeight: FontWeight.w600
        ),),
        backgroundColor: AppColors.arrowBackground,
        foregroundColor: AppColors.white,
        elevation: 0,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
                    padding: EdgeInsets.only(
              left: AppDimensions.screenPadding,
              right: AppDimensions.screenPadding,
              top: AppDimensions.screenPadding),
                    child: Column(
            children: [
              heartRateContainer(),
              SizedBox(
                height: AppDimensions.contentGap3,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  bloodGroupContainer(
                      color: AppColors.bloodGroupCard,
                      image: 'assets/images/reports/blood_group.png',
                      name: 'Blood Group',
                      value: 'A+'),
                  bloodGroupContainer(
                      color: AppColors.weightCardColor,
                      image: 'assets/images/reports/weight.png',
                      name: 'weight',
                      value: '103lbs'),
                ],
              ),
              SizedBox(
                height: AppDimensions.contentGap2,
              ),
              DashboardHeading(
                  headingName: 'Latest report',
                  isSeeAllVisible: false,
                  onTap: () {}),
              SizedBox(
                height: AppDimensions.contentGap2,
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index){
                return Padding(
                  padding:  EdgeInsets.only(bottom: ScreenUtils().screenWidth(context)*0.03),
                  child: reportContainer(),
                );
              })

            ],
                    ),
                  ),
          )),
    );
  }

  Widget heartRateContainer() {
    return Container(
      width: ScreenUtils().screenWidth(context),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColors.arrowBackground.withOpacity(0.19)),
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.screenPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  "Heart rate",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.colorBlack),
                ),
                RichText(
                  text: TextSpan(
                    text: '97',
                    style: TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.w500,
                        color: AppColors.colorBlack),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'bpm',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: AppColors.colorBlack)),
                    ],
                  ),
                ),
              ],
            ),
            Image.asset(
              "assets/images/reports/heart_rate.png",
              height: AppDimensions.screenHeight * 0.1,
              width: AppDimensions.screenWidth * 0.4,
            ),
          ],
        ),
      ),
    );
  }

  Widget bloodGroupContainer(
      {required Color color,
      required String image,
      required String name,
      required String value}) {
    return Container(
      width: ScreenUtils().screenWidth(context) * 0.42,
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          spacing: 5,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              image,
              height: ScreenUtils().screenHeight(context) * 0.05,
              width: ScreenUtils().screenWidth(context) * 0.08,
            ),
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.colorBlack),
            ),
            Text(
              value,
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: AppColors.colorBlack),
            )
          ],
        ),
      ),
    );
  }

  Widget reportContainer() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.gray7.withOpacity(0.5)),
      ),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 10,
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color:
                          AppColors.reportIconContainerColor.withOpacity(0.12)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      "assets/images/reports/report.png",
                      height: ScreenUtils().screenHeight(context) * 0.04,
                      width: ScreenUtils().screenWidth(context) * 0.08,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 5,
                  children: [
                    Text(
                      "General report",
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.colorBlack,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "16th july 2025",
                      style: TextStyle(
                          fontSize: 10,
                          color: AppColors.colorBlack.withOpacity(0.4),
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ],
            ),
            Icon(Icons.more_horiz)
          ],
        ),
      ),
    );
  }
}
