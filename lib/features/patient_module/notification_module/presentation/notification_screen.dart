import 'package:flutter/material.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/app_dimensions.dart';
import 'package:jnm_hospital_app/core/utils/helper/screen_utils.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    AppDimensions.init(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications", style: TextStyle(
          fontSize: 20,
          fontFamily: "Roboto",
          fontWeight: FontWeight.w600
        ),),
        backgroundColor: AppColors.arrowBackground,
        foregroundColor: AppColors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: 10,
          padding: EdgeInsets.symmetric(
            vertical: AppDimensions.screenPadding,
          ),
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.screenPadding,
                //vertical: AppDimensions.screenPadding / 2,
              ),
              child: notificationCard(
                isVisible: index/2==0?true:false,
                title: "Report delivered",
                subtitle: "Sunday | 5:20 PM (18 Jan 2025)",
              ),
            );
          },
        ),
      ),
    );
  }

  Widget notificationCard({required String title, required String subtitle, required bool isVisible}) {
    return Column(
      children: [
        SizedBox(height: ScreenUtils().screenHeight(context)*0.01,),
        Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: AppColors.arrowBackground.withOpacity(0.1),
              child: Icon(
                Icons.calendar_today_outlined,
                size: 26,
                color: AppColors.starColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.colorBlack,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.colorBlack.withOpacity(0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: isVisible,
              child: CircleAvatar(
                radius: 6,
                backgroundColor: AppColors.profileGradient,
              ),
            )
          ],
        ),
        SizedBox(height: ScreenUtils().screenHeight(context)*0.01,),
        Divider(color: AppColors.arrowBackground.withOpacity(0.2),)
      ],
    );
  }
}
