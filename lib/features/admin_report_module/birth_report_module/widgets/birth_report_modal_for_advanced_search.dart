import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:jnm_hospital_app/core/utils/commonWidgets/common_button.dart';
import 'package:jnm_hospital_app/core/utils/commonWidgets/custom_button.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/screen_utils.dart';
import 'package:jnm_hospital_app/features/admin_report_module/common_widgets/searchable_dropdown.dart';

Future<String?> showCommonModalForAdvancedSearchForBirthReport(BuildContext context) {
  String? selectedFruit;

  final List<String> fruits = [
    "Apple", "Banana", "Cherry", "Date", "Fig", "Grapes", "Mango", "Orange", "Pineapple", "Strawberry", "Watermelon",
  ];

  Future<List<String>> getFruits(String filter, LoadProps? props) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return fruits.where((item) => item.toLowerCase().contains(filter.toLowerCase())).toList();
  }

  return showDialog<String>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext dialogContext) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        child: StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          "Advanced Filter",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: ScreenUtils().screenHeight(context)*0.03),

                      Text("Select Gender", style: TextStyle(
                          fontSize: 12,
                          color: AppColors.colorBlack,
                          fontWeight: FontWeight.w600
                      ),),
                      SizedBox(height: ScreenUtils().screenHeight(context)*0.015),
                      CommonSearchableDropdown<String>(
                        items: getFruits,
                        hintText: "Select your gender",
                        selectedItem: selectedFruit,
                        onChanged: (value) {
                          setState(() {
                            selectedFruit = value;
                          });
                        },
                        itemAsString: (item) => item,
                        //validator: (value) => value == null ? "Please select a fruit" : null,
                      ),
                      SizedBox(height: ScreenUtils().screenHeight(context)*0.02),

                      Text("Select Delivery Mode", style: TextStyle(
                          fontSize: 12,
                          color: AppColors.colorBlack,
                          fontWeight: FontWeight.w600
                      ),),
                      SizedBox(height: ScreenUtils().screenHeight(context)*0.015),
                      CommonSearchableDropdown<String>(
                        items: getFruits,
                        hintText: "Select delivery mode",
                        selectedItem: selectedFruit,
                        onChanged: (value) {
                          setState(() {
                            selectedFruit = value;
                          });
                        },
                        itemAsString: (item) => item,
                        //validator: (value) => value == null ? "Please select a fruit" : null,
                      ),
                      SizedBox(height: ScreenUtils().screenHeight(context)*0.02),



                      SizedBox(height: ScreenUtils().screenHeight(context)*0.04),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonButton(
                              borderRadius: 8,
                              bgColor: AppColors.arrowBackground,
                              height: ScreenUtils().screenHeight(context)*0.05,
                              width: ScreenUtils().screenWidth(context)*0.3,
                              buttonName: "Filter"),

                          CommonButton(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              borderRadius: 8,
                              bgColor: AppColors.redColor,
                              height: ScreenUtils().screenHeight(context)*0.05,
                              width: ScreenUtils().screenWidth(context)*0.3,
                              buttonName: "Close"),
                        ],
                      ),


                      const SizedBox(height: 10),


                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    },
  );
}
