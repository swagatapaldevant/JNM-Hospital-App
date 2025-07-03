import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:jnm_hospital_app/core/utils/commonWidgets/common_button.dart';
import 'package:jnm_hospital_app/core/utils/commonWidgets/custom_button.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/screen_utils.dart';
import 'package:jnm_hospital_app/features/admin_report_module/common_widgets/searchable_dropdown.dart';

Future<String?> showCommonModalForAdvancedSearchForBillingReport(BuildContext context) {
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
              height: MediaQuery.of(context).size.height * 0.9,
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

                      Text("Selection Type", style: TextStyle(
                          fontSize: 12,
                          color: AppColors.colorBlack,
                          fontWeight: FontWeight.w600
                      ),),
                      SizedBox(height: ScreenUtils().screenHeight(context)*0.015),
                      CommonSearchableDropdown<String>(
                        items: getFruits,
                        hintText: "Select billing type",
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

                      Text("User Type", style: TextStyle(
                          fontSize: 12,
                          color: AppColors.colorBlack,
                          fontWeight: FontWeight.w600
                      ),),
                      SizedBox(height: ScreenUtils().screenHeight(context)*0.015),
                      CommonSearchableDropdown<String>(
                        items: getFruits,
                        hintText: "Select user type",
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


                      Text("Doctor", style: TextStyle(
                          fontSize: 12,
                          color: AppColors.colorBlack,
                          fontWeight: FontWeight.w600
                      ),),
                      SizedBox(height: ScreenUtils().screenHeight(context)*0.015),
                      CommonSearchableDropdown<String>(
                        items: getFruits,
                        hintText: "Select doctor",
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

                      Text("Doctor Type", style: TextStyle(
                          fontSize: 12,
                          color: AppColors.colorBlack,
                          fontWeight: FontWeight.w600
                      ),),
                      SizedBox(height: ScreenUtils().screenHeight(context)*0.015),
                      CommonSearchableDropdown<String>(
                        items: getFruits,
                        hintText: "Select doctor type",
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


                      Text("Charge", style: TextStyle(
                          fontSize: 12,
                          color: AppColors.colorBlack,
                          fontWeight: FontWeight.w600
                      ),),
                      SizedBox(height: ScreenUtils().screenHeight(context)*0.015),
                      CommonSearchableDropdown<String>(
                        items: getFruits,
                        hintText: "Select charge",
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


                      Text("Charge Category", style: TextStyle(
                          fontSize: 12,
                          color: AppColors.colorBlack,
                          fontWeight: FontWeight.w600
                      ),),
                      SizedBox(height: ScreenUtils().screenHeight(context)*0.015),
                      CommonSearchableDropdown<String>(
                        items: getFruits,
                        hintText: "Select charge category",
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


                      Text("Charge sub category", style: TextStyle(
                          fontSize: 12,
                          color: AppColors.colorBlack,
                          fontWeight: FontWeight.w600
                      ),),
                      SizedBox(height: ScreenUtils().screenHeight(context)*0.015),
                      CommonSearchableDropdown<String>(
                        items: getFruits,
                        hintText: "Select charge sub category",
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

                      Text("Payment Type", style: TextStyle(
                          fontSize: 12,
                          color: AppColors.colorBlack,
                          fontWeight: FontWeight.w600
                      ),),
                      SizedBox(height: ScreenUtils().screenHeight(context)*0.015),
                      CommonSearchableDropdown<String>(
                        items: getFruits,
                        hintText: "Select payment type",
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


                      Text("Patient Type", style: TextStyle(
                          fontSize: 12,
                          color: AppColors.colorBlack,
                          fontWeight: FontWeight.w600
                      ),),
                      SizedBox(height: ScreenUtils().screenHeight(context)*0.015),
                      CommonSearchableDropdown<String>(
                        items: getFruits,
                        hintText: "Select patient type",
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


                      Text("Discount", style: TextStyle(
                          fontSize: 12,
                          color: AppColors.colorBlack,
                          fontWeight: FontWeight.w600
                      ),),
                      SizedBox(height: ScreenUtils().screenHeight(context)*0.015),
                      CommonSearchableDropdown<String> (
                        items: getFruits,
                        hintText: "Select discount type",
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


                      Text("Discount amount", style: TextStyle(
                          fontSize: 12,
                          color: AppColors.colorBlack,
                          fontWeight: FontWeight.w600
                      ),),
                      SizedBox(height: ScreenUtils().screenHeight(context)*0.015),
                      CommonSearchableDropdown<String>(
                        items: getFruits,
                        hintText: "enter discount amount",
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


                      Text("Referral", style: TextStyle(
                          fontSize: 12,
                          color: AppColors.colorBlack,
                          fontWeight: FontWeight.w600
                      ),),
                      SizedBox(height: ScreenUtils().screenHeight(context)*0.015),
                      CommonSearchableDropdown<String>(
                        items: getFruits,
                        hintText: "Select referral name",
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



                      Text("Market By", style: TextStyle(
                          fontSize: 12,
                          color: AppColors.colorBlack,
                          fontWeight: FontWeight.w600
                      ),),
                      SizedBox(height: ScreenUtils().screenHeight(context)*0.015),
                      CommonSearchableDropdown<String>(
                        items: getFruits,
                        hintText: "Select market by",
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


                      Text("Provider", style: TextStyle(
                          fontSize: 12,
                          color: AppColors.colorBlack,
                          fontWeight: FontWeight.w600
                      ),),
                      SizedBox(height: ScreenUtils().screenHeight(context)*0.015),
                      CommonSearchableDropdown<String>(
                        items: getFruits,
                        hintText: "Select provider name",
                        selectedItem: selectedFruit,
                        onChanged: (value) {
                          setState(() {
                            selectedFruit = value;
                          });
                        },
                        itemAsString: (item) => item,
                        //validator: (value) => value == null ? "Please select a fruit" : null,
                      ),
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
