import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:jnm_hospital_app/core/utils/commonWidgets/common_button.dart';
import 'package:jnm_hospital_app/core/utils/commonWidgets/common_dialog.dart';
import 'package:jnm_hospital_app/core/utils/commonWidgets/common_header.dart';
import 'package:jnm_hospital_app/core/utils/commonWidgets/custom_popup.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/app_dimensions.dart';
import 'package:jnm_hospital_app/core/utils/helper/screen_utils.dart';
import 'package:jnm_hospital_app/features/patient_module/booking_module/widgets/appointment_date_time_display.dart';
import 'package:jnm_hospital_app/features/patient_module/booking_module/widgets/reason_section.dart';

class BookingPaymentScreen extends StatefulWidget {
  const BookingPaymentScreen({super.key});

  @override
  State<BookingPaymentScreen> createState() => _BookingPaymentScreenState();
}

class _BookingPaymentScreenState extends State<BookingPaymentScreen> {
  @override
  Widget build(BuildContext context) {
    AppDimensions.init(context);
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
              child: Column(children: [
        Padding(
            padding: EdgeInsets.only(
                left: AppDimensions.screenPadding,
                right: AppDimensions.screenPadding,
                top: AppDimensions.screenPadding),
            child: Column(children: [
              CommonHeader(
                screenName: 'Appointment',
              ),
              SizedBox(
                height: AppDimensions.contentGap2,
              ),
              Row(
                spacing: AppDimensions.contentGap3,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      "https://img.freepik.com/free-photo/portrait-experienced-professional-therapist-with-stethoscope-looking-camera_1098-19305.jpg?semt=ais_hybrid&w=740",
                      height: AppDimensions.screenHeight * 0.13,
                      width: AppDimensions.screenHeight * 0.13,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Column(
                    spacing: 2,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Dr. Marcus Horizon",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.colorBlack,
                            fontSize: 16),
                      ),
                      Text(
                        "Cardiologist",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppColors.gray8,
                            fontSize: 10),
                      ),
                      SizedBox(
                        height: AppDimensions.screenHeight * 0.01,
                      ),
                      rating(),
                      distance()
                    ],
                  )
                ],
              ),
              SizedBox(
                height: AppDimensions.contentGap2,
              ),
              heading("Date", true),
              SizedBox(
                height: AppDimensions.screenHeight*0.01,
              ),
              AppointmentDateTimeDisplay(dateTime: DateTime(2021, 6, 23, 10, 0),),
              SizedBox(
                height: AppDimensions.screenHeight*0.01,
              ),
              Divider(
                color: AppColors.starBackgroundColor,
              ),
              SizedBox(
                height: AppDimensions.screenHeight*0.01,
              ),
              heading("Reason", false),
              SizedBox(
                height: AppDimensions.screenHeight*0.01,
              ),
              ReasonSection(
                reason: "Chest pain",
                onReasonChanged: (newReason) {
                  print("Updated reason: $newReason");
                },
              ),
              SizedBox(
                height: AppDimensions.screenHeight*0.01,
              ),
              Divider(
                color: AppColors.starBackgroundColor,
              ),
              SizedBox(
                height: AppDimensions.screenHeight*0.01,
              ),
              heading("Payment Details", false),
              SizedBox(
                height: AppDimensions.screenHeight*0.01,
              ),
              paymentPart("Consultation", "1000.00"),
              SizedBox(
                height: AppDimensions.screenHeight*0.01,
              ),
              paymentPart("Admin Fee", "01.00"),
              SizedBox(
                height: AppDimensions.screenHeight*0.01,
              ),
              paymentPart("Additional Discount ", "__"),
              SizedBox(
                height: AppDimensions.screenHeight*0.01,
              ),
              Divider(
                color: AppColors.starBackgroundColor,
              ),
              SizedBox(
                height: AppDimensions.screenHeight*0.01,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total", style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.colorBlack,
                    fontSize: 14
                  ),),

                  Text("Rs. 1001.00", style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.arrowBackground,
                      fontSize: 14
                  ),)
                ],
              ),
              SizedBox(
                height: AppDimensions.screenHeight*0.01,
              ),
              Divider(
                color: AppColors.starBackgroundColor,
              ),

              SizedBox(height: AppDimensions.contentGap1,),

              CommonButton(
                onTap: (){
                  PopupAfterBooking(title: 'Booking Done', msg: 'Your appointment has been successfully booked. You will receive a confirmation with the details shortly.', context: context);
                },
                  buttonName: "Booking")






            ]))
      ]))),
    );
  }

  Widget rating() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: AppColors.starBackgroundColor),
      child: Padding(
        padding: EdgeInsets.all(4.0),
        child: Row(
          spacing: 4,
          children: [
            Icon(
              Icons.star,
              color: AppColors.starColor,
              size: 14,
            ),
            Text(
              "4.7",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.starColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget distance() {
    return Row(
      spacing: 2,
      children: [
        Icon(
          Icons.location_on,
          color: AppColors.gray8,
          size: 15,
        ),
        Text(
          "800m away",
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.gray8),
        ),
      ],
    );
  }
  
  Widget heading(String text, bool? isVisible){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text, style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.colorBlack
        ),),

        Visibility(
          visible: isVisible?? false,
          child: Bounceable(
            onTap: (){
              Navigator.pop(context);
            },
            child: Text("Change", style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: AppColors.gray8
            ),),
          ),
        )
      ],
    );
  }  
  
  Widget paymentPart(String paymentType, String paymentValue){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(paymentType, style: TextStyle(
          color: AppColors.gray8,
          fontSize: 12,
          fontWeight: FontWeight.w500
        ),),

        Text(" Rs $paymentValue", style: TextStyle(
            color: AppColors.colorBlack,
            fontSize: 12,
            fontWeight: FontWeight.w500
        ),)
      ],
    );
  }
  
}




PopupAfterBooking(
    {required String title,
      required String msg,
      required BuildContext context}) {
  showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0)), //this right here
          child: Container(
            height: ScreenUtils().screenHeight(context) * 0.4,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(25.0),
              ),
              color: Theme.of(context).scaffoldBackgroundColor,
              // boxShadow: [
              //   BoxShadow(
              //     // color:  Colors.blueGrey.withOpacity(0.4),
              //       color: AppColors.colorPrimaryText2.withOpacity(0.2),
              //       offset: Offset(0.0, 5.0),
              //       blurRadius: 10.0)
              // ],
            ),
            child: Padding(
              padding:
              EdgeInsets.all(ScreenUtils().screenWidth(context) * 0.08),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("assets/images/find_doctors/check_mark.png",
                  height: ScreenUtils().screenWidth(context)*0.2,
                    width: ScreenUtils().screenWidth(context)*0.2,
                  ),
                  
                  SizedBox(
                    height: ScreenUtils().screenHeight(context) * 0.02,
                  ),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: AppColors.colorBlack,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: ScreenUtils().screenHeight(context) * 0.02,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Text(
                      msg,
                      style:
                      Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: AppColors.popUpText,
                        fontSize:
                        12,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 7,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  //Spacer(),
                  SizedBox(
                    height: ScreenUtils().screenHeight(context) * 0.05,
                  ),

                  CommonButton(
                    onTap: (){
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                      width: ScreenUtils().screenWidth(context)*0.4,
                      height: ScreenUtils().screenHeight(context)*0.04,
                      buttonName: "Done")


                ],
              ),
            ),
          ),
        );
      });
}
