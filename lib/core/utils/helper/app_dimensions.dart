import 'package:flutter/widgets.dart';
import 'package:jnm_hospital_app/core/utils/helper/screen_utils.dart';

class AppDimensions {
  static late double screenWidth;
  static late double screenHeight;
  static late double screenPadding;
  static late double buttonHeight;
  static late double contentGap1;
  static late double contentGap2;
  static late double contentGap3;
  static late double contentGap4;


  static void init(BuildContext context) {
    screenWidth = ScreenUtils().screenWidth(context);
    screenHeight = ScreenUtils().screenHeight(context);

    screenPadding = screenWidth*0.05;
    buttonHeight = screenHeight*0.055;
    contentGap1 = screenHeight*0.05;
    contentGap2 = screenHeight*0.03;
    contentGap3 = screenHeight*0.02;
    contentGap4 = screenHeight*0.1;


  }
}