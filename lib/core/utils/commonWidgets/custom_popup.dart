
import 'package:flutter/material.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/screen_utils.dart';

class CustomPopup extends StatelessWidget {
  final String title;
  final String description;
  final String eventDate;
  const CustomPopup(
      {super.key,
      required this.title,
      required this.description,
      required this.eventDate});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(ScreenUtils().screenWidth(context) * 0.05),
      ),
      child: Padding(
        padding: EdgeInsets.all(ScreenUtils().screenWidth(context) * 0.05),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.colorBlue500,
                  fontFamily: "Poppins",
                  fontSize: 16),
            ),
            SizedBox(height: ScreenUtils().screenWidth(context) * 0.05),
            Container(
              constraints: BoxConstraints(
                maxHeight: ScreenUtils().screenHeight(context) *
                    0.4, // Limit height for scrolling
              ),
              child: SingleChildScrollView(
                child: Text(
                  description,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppColors.colorPrimaryText,
                      fontFamily: "Poppins",
                      fontSize: 13),
                ),
              ),
            ),
            SizedBox(height: ScreenUtils().screenWidth(context) * 0.05),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "📅 Date: $eventDate",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.colorPrimaryText,
                      fontFamily: "Poppins",
                      fontSize: 11),
                ),
                Icon(Icons.event, color: Colors.blue.shade700),
              ],
            ),
            SizedBox(height: ScreenUtils().screenWidth(context) * 0.05),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Close",
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.colorBlue500,
                      fontFamily: "Poppins",
                      fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
