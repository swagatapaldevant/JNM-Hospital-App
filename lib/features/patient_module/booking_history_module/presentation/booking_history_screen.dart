import 'package:flutter/material.dart';
import 'package:jnm_hospital_app/core/utils/commonWidgets/common_button.dart';
import 'package:jnm_hospital_app/core/utils/commonWidgets/common_header.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/app_dimensions.dart';
import 'package:jnm_hospital_app/core/utils/helper/screen_utils.dart';

class BookingHistoryScreen extends StatefulWidget {
  const BookingHistoryScreen({super.key});

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    AppDimensions.init(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: CommonHeader(
          iconColor: AppColors.white,
          textColor: AppColors.white,
          screenName: 'Booking History',
        ),
        backgroundColor: AppColors.arrowBackground,
        foregroundColor: AppColors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: AppDimensions.screenPadding),
          child: ListView.builder(
              itemCount: 10,
              itemBuilder: (BuildContext context, int index){
            return Padding(
              padding:  EdgeInsets.only(top: AppDimensions.screenWidth*0.04),
              child: appointmentHistoryCard(),
            );
          })
          
          
        ),
      ),
    );
  }


  Widget appointmentHistoryCard(){
    return Container(
      width: ScreenUtils().screenWidth(context),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.starBackgroundColor)
      ),
      child: Padding(
        padding:  EdgeInsets.all(ScreenUtils().screenWidth(context)*0.04),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Dr. Marcus Horizon", style: TextStyle(
                      fontSize: 16,
                      color: AppColors.colorBlack,
                      fontWeight: FontWeight.w600
                    ),),

                    Text("Cardiologist", style: TextStyle(
                        fontSize: 12,
                        color: AppColors.gray8,
                        fontWeight: FontWeight.w500
                    ),)
                  ],
                ),

                CircleAvatar(
                  radius: 22,
                  backgroundImage: NetworkImage("https://img.freepik.com/free-photo/portrait-experienced-professional-therapist-with-stethoscope-looking-camera_1098-19305.jpg?semt=ais_hybrid&w=740"),

                )
              ],
            ),
            SizedBox(height:AppDimensions.contentGap3,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                item(icon: Icons.calendar_month_outlined, text: "12/06/2025"),
                item(icon: Icons.watch_later_outlined, text: "10:30 AM"),
                item(icon: Icons.circle, text: "Confirmed", color: AppColors.colorGreen),
              ],
            ),

            SizedBox(height:AppDimensions.contentGap3,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonButton(
                  height: AppDimensions.screenHeight*0.045,
                  borderRadius: 10,
                  borderColor: AppColors.starBackgroundColor,
                  bgColor: AppColors.starBackgroundColor,
                  labelTextColor: AppColors.colorBlack,
                  width: AppDimensions.screenWidth*0.38,
                    buttonName: "Cancel"),

                CommonButton(
                    height: AppDimensions.screenHeight*0.045,
                    borderRadius: 10,
                    width: AppDimensions.screenWidth*0.38,
                    buttonName: "Reschedule")
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget item({required IconData icon, required String text, Color? color}){
    return Row(
      spacing: 5,
      children: [
        Icon(icon, size: 15,color: color,),
        Text(text, style: TextStyle(
          fontSize: 11,
          color: AppColors.colorBlack.withOpacity(0.6),
          fontWeight: FontWeight.w400
        ),)
      ],
    );
  }


}
