import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../constants/app_colors.dart';

class CommonUtils {
  static final CommonUtils _instance = CommonUtils._internal();

  factory CommonUtils() {
    return _instance;
  }

  CommonUtils._internal();

  loadingState({required bool isLoading}) {
    if (isLoading) {
    } else {}
  }

  flutterSnackBar(
      {required BuildContext context,
      required String mes,
      required int messageType,
      bool isVisible = true}) {
    // 1 : Congratulations!
    // 2 : Did you know ?
    // 3 : Warning
    // 4 : Something went wrong !

    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).colorScheme.secondary,
                        offset: const Offset(0.0, 3.0),
                        blurRadius: 8.0)
                  ],
                  border: Border.all(
                      color: messageType == 1
                          ? Colors.green
                          : messageType == 2
                              ? Colors.blueAccent
                              : messageType == 3
                                  ? Colors.orange
                                  : messageType == 4
                                      ? Colors.red
                                      : Colors.black), // Colors.black87,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(15.0),
                  ),
                ),
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: messageType == 1
                                ? Colors.green
                                : messageType == 2
                                    ? Colors.blueAccent
                                    : messageType == 3
                                        ? Colors.orange
                                        : messageType == 4
                                            ? Colors.red
                                            : Colors.black),
                        child: Center(
                          child: Icon(
                            messageType == 1
                                ? Icons.verified_user
                                : messageType == 2
                                    ? Icons.info_outlined
                                    : messageType == 3
                                        ? Icons.warning_amber_outlined
                                        : messageType == 4
                                            ? Icons.highlight_remove_sharp
                                            : Icons.verified_user,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Visibility(
                              visible: isVisible,
                              child: Text(
                                messageType == 1
                                    ? "Congratulations!"
                                    : messageType == 2
                                        ? "Did you know ?"
                                        : messageType == 3
                                            ? "Warning"
                                            : messageType == 4
                                                ? "Something went wrong !"
                                                : "Did you know ?",
                                textAlign: TextAlign.left,
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium
                                    ?.copyWith(
                                      color: Colors.black,
                                      //fontFamily: AppFontSize.appFontOpenSans,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              mes,
                              textAlign: TextAlign.left,
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium
                                  ?.copyWith(
                                    color: Colors.black,
                                    fontSize: 13,
                                    //fontFamily: AppFontSize.appFontOpenSans,
                                    fontWeight: FontWeight.w400,
                                  ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      InkWell(
                          onTap: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          },
                          child: const Icon(
                            Icons.clear_rounded,
                            color: Colors.black,
                          )),
                    ]))))));
  }



  static const Map<String, String> regexPatterns = <String, String>{
    'age': r'^100|[1-9]?\d$',
    'phone': r'(^[6-9]\d{9}$)',
    'pan': r'^([A-Z]){5}([0-9]){4}([A-Z]){1}?$',
    'pincode': r'^[1-9][0-9]{5}$',
    'ifsc': r'^[A-Za-z]{4}[a-zA-Z0-9]{7}$',
    'yesBankIfsc': r'^(YESB|yesb)[a-zA-Z0-9]{7}$',
    'otp': r'^(0|[1-9][0-9]*)$',
    'email':
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    'gst':
    r'^([0]{1}[1-9]{1}|[1-2]{1}[0-9]{1}|[3]{1}[0-7]{1})([a-zA-Z]{5}[0-9]{4}[a-zA-Z]{1}[1-9a-zA-Z]{1}[zZ]{1}[0-9a-zA-Z]{1})+$',
    'cin': r'([L|U]{1})([0-9]{5})([A-Za-z]{2})([0-9]{4})([A-Za-z]{3})([0-9]{6})$',
    'bankAccount': r'^\d{9,18}$',
    'positiveInteger': r'^[0-9][1-9][0-9]$',
    'currencyToNumber': r'[₹,]',
    'name': r'^[A-Za-z]+$',
    'fullName': r'^[a-zA-Z ]*$',
    'firstMiddleLastName': r"^([a-zA-Z]{2,}\s[a-zA-z]{1,}'?-?[a-zA-Z]{2,}\s?([a-zA-Z]{1,})?)",
    'whitelistingRegex': '^[a-zA-Z0-9]*',
    'emoticon': r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])',
    'upiId': r'^[\w.-]+@[\w.-]+$',
    'bbpsAmountInput': r'[0-9.]',
    'adhaarCard': r'^[2-9]{1}[0-9]{3}[0-9]{4}[0-9]{4}$',
    'minMaxLength': r'^.{3,26}$',
    'base64': r'^(?:[A-Za-z0-9+\/]{4})*(?:[A-Za-z0-9+\/]{2}==|[A-Za-z0-9+\/]{3}=|[A-Za-z0-9+\/]{4})$'
  };


  static Widget stringToImage({required String value,double width = 0,double height = 0,double radius = 0,BoxFit fit = BoxFit.fill}){
    if(RegExp(regexPatterns['base64']!).hasMatch(value)){
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Image.memory(base64Decode(value)),
      );
    }else if(value.startsWith("http")){
      return     ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Image.network(value,fit:fit,width: width,height :height ,
            errorBuilder: (BuildContext context, Object exception,
                StackTrace? stackTrace) {
              return Image.network("https://www.mikimotoamerica.com/media/wysiwyg/mikimoto_SJC_GLB/spa.gif",fit: fit,width: width,height :height ,);
            },
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) return child;

              return SizedBox(
                width:width,height :height,
                child: Shimmer.fromColors(
                  baseColor: AppColors.gray7,
                  highlightColor: AppColors.gray3,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius:  BorderRadius.circular(radius),
                        color: AppColors.colorPrimaryText
                    ),
                  ),
                ),
                /*  child: Center(
                  child: Transform.scale(
                    scale: 0.5,
                    child: CircularProgressIndicator(
                      valueColor:  const AlwaysStoppedAnimation<Color>(AppColors.colorButton),

                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                ),*/
              );
            }),

      );
    }else if(value.startsWith('assets')){
      return
        ClipRRect(
            borderRadius: BorderRadius.circular(radius),child: Image.asset(value,fit: BoxFit.fill,width: width,height :height,
          errorBuilder: (BuildContext context, Object exception,
              StackTrace? stackTrace) {
            return Image.network("https://www.mikimotoamerica.com/media/wysiwyg/mikimoto_SJC_GLB/spa.gif",fit: BoxFit.fill,width: width,height :height ,);
          },

        ));
    }else{
      return     ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Image.file(File(value,),fit: BoxFit.fill,width: width,height :height,));
    }
  }


  loaderWithShimmerEffect({required double height, required double width, double radius = 0}) {
    return Shimmer.fromColors(
      enabled: true, // Make sure this is set to true
      baseColor: Colors.black, // Set the base color
      highlightColor: Colors.white, // Set the highlight color
      period: Duration(milliseconds: 1500), // You can control the speed of shimmer here
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          color: Colors.grey[300], // Fallback color if shimmer doesn't show
        ),
      ),
    );
  }


  String getCurrentDate() {
    DateTime now = DateTime.now();
    return "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }

  String formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    return DateFormat("d MMMM yyyy").format(dateTime);
  }

  Map<int, String> getPreviousSixMonths() {
    DateTime now = DateTime.now();
    Map<int, String> previousMonths = {};

    for (int i = 0; i <= 5; i++) {
      DateTime previousMonth = DateTime(now.year, now.month - i, 1);
      int monthId = previousMonth.month;
      String monthName = DateFormat('MMMM').format(previousMonth);

      previousMonths[monthId] = monthName;
    }

    return previousMonths;
  }




}
