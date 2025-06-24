import 'package:flutter/material.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/app_dimensions.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    AppDimensions.init(context);
    return Container(
      decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColors.dashboardHeaderGrad2,
              width: 3.0,
            ),
          ),
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.bottomRight,
              stops: [
                100,
                100,
                0.5
              ],
              colors: [
                AppColors.arrowBackground,
                AppColors.dashboardHeaderGrad1,
                AppColors.dashboardHeaderGrad2,
              ])),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: AppDimensions.screenHeight * 0.01,
              horizontal: AppDimensions.screenPadding),
          child: Row(
            spacing: 10,
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(
                    "https://media.istockphoto.com/id/1437816897/photo/business-woman-manager-or-human-resources-portrait-for-career-success-company-we-are-hiring.jpg?s=612x612&w=0&k=20&c=tyLvtzutRh22j9GqSGI33Z4HpIwv9vL_MZw_xOE19NQ="),
              ),
              Column(
                spacing: 5,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white),
                  ),
                  Text(
                    "Swagata",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.white),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
