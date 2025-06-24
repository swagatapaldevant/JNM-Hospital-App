import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';

class DashboardHeading extends StatelessWidget {
  final String headingName;
  Function()? onTap;
  final bool? isSeeAllVisible;
   DashboardHeading({super.key, required this.headingName, this.isSeeAllVisible = true, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          headingName,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.headerText),
        ),

        Visibility(
          visible: isSeeAllVisible?? true,
          child: Bounceable(
            onTap: onTap,
            child: Text(
              "See All",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.arrowBackground),
            ),
          ),
        ),
      ],
    );
  }
}
