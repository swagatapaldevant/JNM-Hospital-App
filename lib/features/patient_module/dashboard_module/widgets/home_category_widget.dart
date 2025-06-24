import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/app_dimensions.dart';

class HomeCategoryWidget extends StatelessWidget {
  final String imageList;
  final String name;
  Function()? onTap;
   HomeCategoryWidget({super.key, required this.imageList, required this.name, this.onTap});

  @override
  Widget build(BuildContext context) {
    AppDimensions.init(context);
    return Column(
      spacing: 10,
      children: [
        Bounceable(
          onTap: onTap,
          child: Container(
            height: AppDimensions.screenHeight * 0.06,
            width: AppDimensions.screenWidth * 0.16,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.gray7.withOpacity(0.5),
                  blurRadius: 4,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                imageList,
              ),
            ),
          ),
        ),

        Text(
          name,
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.gray8),
        ),
      ],
    );
  }
}
