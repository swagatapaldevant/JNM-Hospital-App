import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';

class CommonHeader extends StatelessWidget {
  final String screenName;
  final Color? textColor;
  final Color? iconColor;
  final bool? isVisible;
  const CommonHeader({super.key, required this.screenName,this.isVisible, this.textColor, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Visibility(
          visible:isVisible??true ,
          child: Bounceable(
              onTap: (){
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios_new, size: 25,color: iconColor??AppColors.colorBlack,)),
        ),
        Text(screenName, style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: textColor??AppColors.headerText
        ),),
        Text("", style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.headerText
        ),)
      ],
    );
  }
}
