import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/app_dimensions.dart';

class HomeDashboardDoctorWidget extends StatelessWidget {
  Function()? onTap;
   HomeDashboardDoctorWidget({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    AppDimensions.init(context);
    return Padding(
      padding:  EdgeInsets.only(
          bottom: AppDimensions.screenWidth*0.02,
          right: AppDimensions.screenWidth*0.02
      ),
      child: Bounceable(
        onTap: onTap,
        child: Container(
          width:AppDimensions.screenWidth*0.28,
         // height: AppDimensions.screenHeight*0.15,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.gray7.withOpacity(0.50)),
            boxShadow: [
              BoxShadow(
                color: AppColors.gray7.withOpacity(0.50),
                blurRadius: 4,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding:  EdgeInsets.all(AppDimensions.screenWidth*0.03),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage("https://img.freepik.com/free-photo/portrait-experienced-professional-therapist-with-stethoscope-looking-camera_1098-19305.jpg?semt=ais_hybrid&w=740"),
                  ),
                ),

                SizedBox(height: AppDimensions.screenHeight*0.01,),

                Text(
                  "Dr. Marcus Horizon",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: AppColors.colorBlack),
                ),

                Text(
                  "Chardiologist",
                  style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w500,
                      color: AppColors.gray8),
                ),
                SizedBox(height: AppDimensions.screenHeight*0.01,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    rating(),
                    distance(),
                  ],
                ),
                //SizedBox(height: AppDimensions.screenHeight*0.005,),



              ],
            ),
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
        padding:  EdgeInsets.all(2.0),
        child: Row(
          spacing: 2,
          children: [
            Icon(Icons.star, color: AppColors.starColor, size: 12,),
            Text(
              "4.7",
              style: TextStyle(
                  fontSize: 8,
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
        Icon(Icons.location_on,color: AppColors.gray8,size: 12,),
        Text(
          "800m",
          style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w500,
              color: AppColors.gray8),
        ),
      ],
    );
  }
}
