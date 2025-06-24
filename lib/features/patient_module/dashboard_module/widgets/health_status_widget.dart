import 'package:flutter/material.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/app_dimensions.dart';

class HealthStatusWidget extends StatelessWidget {
  final String image;
  final String text;
  final String value;
  const HealthStatusWidget({super.key, required this.image, required this.text, required this.value});

  @override
  Widget build(BuildContext context) {
    AppDimensions.init(context);
    return Column(

      children: [
        Image.asset(image,
        height:AppDimensions.screenHeight*0.06,
          width:AppDimensions.screenHeight*0.06 ,
        ),
        Text(text, style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: AppColors.arrowBackground.withOpacity(0.74)
        ),),
        SizedBox(height: 5,),
        Text(value, style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.arrowBackground
        ),),
      ],
    );
  }
}
