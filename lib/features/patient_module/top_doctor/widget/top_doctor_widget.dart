import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/app_dimensions.dart';

class TopDoctorWidget extends StatelessWidget {
  Function()? onTap;
   TopDoctorWidget({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    AppDimensions.init(context);
    return Bounceable(
      onTap: onTap,
      child: Container(
        width: AppDimensions.screenWidth,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.gray7),
          boxShadow: [
            BoxShadow(
              color: AppColors.gray7.withOpacity(0.5),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding:  EdgeInsets.symmetric(
              horizontal: AppDimensions.screenWidth*0.04,
              vertical: AppDimensions.screenWidth*0.02
          ),
          child: Row(
            spacing: AppDimensions.contentGap3,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  "https://img.freepik.com/free-photo/portrait-experienced-professional-therapist-with-stethoscope-looking-camera_1098-19305.jpg?semt=ais_hybrid&w=740",
                  height: AppDimensions.screenHeight * 0.12,
                  width: AppDimensions.screenHeight * 0.12,
                  fit: BoxFit.fill,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Dr. Marcus Horizon",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.colorBlack),
                  ),
                  SizedBox(height: AppDimensions.screenHeight*0.005,),

                  Text(
                    "Chardiologist",
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: AppColors.gray8),
                  ),
                  SizedBox(height: AppDimensions.screenHeight*0.01,),

                  rating(),
                  SizedBox(height: AppDimensions.screenHeight*0.005,),

                  distance(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }


  Widget rating(){
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: AppColors.starBackgroundColor
      ),
      child: Padding(
        padding:  EdgeInsets.all(4.0),
        child: Row(
          spacing: 4,
          children: [
            Icon(Icons.star, color: AppColors.starColor, size: 14,),
            Text(
              "4.7",
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: AppColors.starColor),
            ),
          ],
        ),
      ) ,
    );
  }

  Widget distance(){
    return Row(
      spacing: 2,
      children: [
        Icon(Icons.location_on,color: AppColors.gray8,size: 15,),
        Text(
          "800m away",
          style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: AppColors.gray8),
        ),
      ],
    );
  }
}
