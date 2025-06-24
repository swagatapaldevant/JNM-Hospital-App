import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/app_dimensions.dart';

class CommonButton extends StatelessWidget {
  final Color? bgColor;
  final Color? labelTextColor;
  final Color? borderColor;
  final double? borderRadius;
  final double? width;
  final double? height;
  final String buttonName;
  Function()? onTap;

   CommonButton({super.key,this.onTap,this.height, this.bgColor, this.labelTextColor, this.borderColor, this.borderRadius, this.width, required this.buttonName});

  @override
  Widget build(BuildContext context) {
    AppDimensions.init(context);
    return Bounceable(
      onTap: onTap,
      child: Container(
        height: height??AppDimensions.buttonHeight,
        width:width?? AppDimensions.screenWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius??32),
          color:bgColor?? AppColors.arrowBackground,
          border: Border.all(color:borderColor?? AppColors.arrowBackground)
        ),
        child: Center(
          child: Text(buttonName, style: TextStyle(
            fontSize: 14,
            color:labelTextColor?? AppColors.white,
            fontWeight: FontWeight.w500
          ),),
        ),
      ),
    );
  }
}
