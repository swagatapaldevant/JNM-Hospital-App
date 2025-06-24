import 'package:flutter/material.dart';
import 'package:jnm_hospital_app/core/utils/commonWidgets/common_button.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/app_dimensions.dart';

class HomeDashboardCard extends StatelessWidget {
  const HomeDashboardCard({super.key});

  @override
  Widget build(BuildContext context) {
    AppDimensions.init(context);
    return Container(
      height: AppDimensions.screenHeight * 0.2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.arrowBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(left: AppDimensions.screenPadding),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Find your desire\nhealth solution",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white),
                ),
                SizedBox(
                  height: AppDimensions.contentGap3,
                ),
                CommonButton(
                    width: AppDimensions.screenWidth * 0.3,
                    labelTextColor: AppColors.arrowBackground,
                    bgColor: AppColors.white,
                    buttonName: "Learn More")
              ],
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(
                            AppDimensions.screenHeight * 0.13))),
                child: Padding(
                  padding: EdgeInsets.only(top: AppDimensions.screenPadding),
                  child: Image.asset("assets/images/home/doctor.png",
                      height: AppDimensions.screenHeight * 0.2,
                      width: AppDimensions.screenWidth * 0.2),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
