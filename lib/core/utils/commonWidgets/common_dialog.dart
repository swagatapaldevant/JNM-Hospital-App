
import 'package:flutter/material.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/screen_utils.dart';

import 'custom_button.dart';

CommonDialog(
    {required String title,
    required String msg,
    required String activeButtonLabel,
    Color? activeButtonLabelColor,
    Color? activeButtonSolidColor,
    IconData? icon,
    bool isCancelButtonShow = true,
    Function()? activeButtonOnClicked,
    required BuildContext context}) {
  showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0)), //this right here
          child: Container(
            height: ScreenUtils().screenHeight(context) * 0.5 - 25,
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
                  //Spacer(),
                  Container(
                      height: ScreenUtils().screenHeight(context) * 0.1,
                      width: ScreenUtils().screenWidth(context) * 0.2,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                AppColors.colorTomato.withOpacity(0.8),
                                AppColors.colorTomato.withOpacity(0.4)
                              ])),
                      child: Icon(
                        icon,
                        color: AppColors.white,
                      )),
                  SizedBox(
                    height: ScreenUtils().screenHeight(context) * 0.02,
                  ),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontFamily: "Poppins",
                          color: AppColors.colorBlack,
                          fontSize: ScreenUtils().screenWidth(context) * 0.05,
                          fontWeight: FontWeight.w500,
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
                                fontFamily: "Poppins",
                                color: AppColors.darkBlue,
                                fontSize:
                                    ScreenUtils().screenWidth(context) * 0.038,
                                fontWeight: FontWeight.w300,
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
                  Row(
                    children: [
                      Visibility(
                        visible: isCancelButtonShow,
                        child: Expanded(
                          flex: 1,
                          child: CustomButton(
                              borderRadius: 8,
                              //height: 35,
                              labelTextSize:
                                  ScreenUtils().screenWidth(context) * 0.032,
                              verticalPadding:
                                  ScreenUtils().screenWidth(context) * 0.02,
                              horizontalPadding:
                                  ScreenUtils().screenWidth(context) * 0.06,
                              labelTextColor: AppColors.colorTomato,
                              color: AppColors.white,
                              borderColor: AppColors.colorTomato,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              text: "Cancel"),
                        ),
                      ),
                      SizedBox(
                        width: isCancelButtonShow ? 10 : 0,
                      ),
                      Expanded(
                        flex: 1,
                        child: CustomButton(
                            borderRadius: 8,
                            //height: 35,
                            labelTextSize:
                                ScreenUtils().screenWidth(context) * 0.032,
                            verticalPadding:
                                ScreenUtils().screenWidth(context) * 0.02,
                            horizontalPadding:
                                ScreenUtils().screenWidth(context) * 0.06,
                            labelTextColor: AppColors.white,
                            color: AppColors.colorTomato,
                            borderColor: AppColors.colorTomato,
                            onPressed: activeButtonOnClicked,
                            text: "Log Out"),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      });
}
