
import 'package:flutter/material.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/screen_utils.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final IconData? icon;
  final Color? color;
  final Color? labelTextColor;
  final Color? textColor;
  final double? width;
  //final double? height;
  final double? labelTextSize;
  final double borderRadius;
  final double horizontalPadding;
  final double verticalPadding;
  final Color borderColor;


  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.color,
    this.textColor,
    this.width,
    //this.height = 50.0,
    this.borderRadius = 12.0,
    this.labelTextSize,
    required this.horizontalPadding,
    required this.verticalPadding,
    this.labelTextColor = AppColors.white,
     this.borderColor =AppColors.colorBlue500 ,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      //height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppColors.white,
          foregroundColor: labelTextColor ?? Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          side: BorderSide( // Add border color here
            color: borderColor ,
            width: 1.5,
          ),
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
        ),
        child: isLoading
            ? SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: textColor ?? AppColors.darkBlue,
          ),
        )
            : Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: ScreenUtils().screenWidth(context)*0.2, color: textColor ?? Colors.white),
              SizedBox(width: 8),
            ],
            Text(
              text,
              style: TextStyle(fontSize: labelTextSize, fontWeight: FontWeight.w500,
              color: labelTextColor,
                fontFamily: "Poppins"
              ),
            ),
          ],
        ),
      ),
    );
  }
}
