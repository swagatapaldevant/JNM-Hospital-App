import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:jnm_hospital_app/core/utils/commonWidgets/common_button.dart';
import 'package:jnm_hospital_app/core/utils/commonWidgets/custom_button.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/screen_utils.dart';
import 'package:jnm_hospital_app/features/admin_report_module/common_widgets/searchable_dropdown.dart';
import 'package:jnm_hospital_app/features/admin_report_module/opd_patient_report_module/presentation/opd_patient_report_screen.dart';

Future<SelectedFilterData?> showCommonModalForAdvancedSearchForBirthReport(
    BuildContext context,
    Map<int, String> genderMap,
    Map<int, String> deliveryModeMap,
    ) {
  final List<MapEntry<int, String>> genderTypeEntries =
  genderMap.entries.toList();
  MapEntry<int, String>? selectedGenderTypeEntry;

  final List<MapEntry<int, String>> deliveryModeEntries =
  deliveryModeMap.entries.toList();
  MapEntry<int, String>? selectedDeliveryEntry;


  return showDialog<SelectedFilterData?>(
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
                      CommonSearchableDropdown<MapEntry<int, String>>(
                        items: (String filter, LoadProps? props) async {
                          await Future.delayed(
                              const Duration(milliseconds: 500));
                          return genderTypeEntries
                              .where((entry) => entry.value
                              .toLowerCase()
                              .contains(filter.toLowerCase()))
                              .toList();
                        },
                        hintText: "Select gender type",
                        selectedItem: selectedGenderTypeEntry,
                        onChanged: (value) {
                          setState(() {
                            selectedGenderTypeEntry = value;
                            // print("Selected ID: ${selectedVisitTypeEntry?.key}");
                            // print("Selected Name: ${selectedVisitTypeEntry?.value}");
                          });
                        },
                        itemAsString: (entry) => entry.value,
                        compareFn: (a, b) => a.key == b.key,
                      ),
                      SizedBox(height: ScreenUtils().screenHeight(context)*0.02),

                      Text("Select Delivery Mode", style: TextStyle(
                          fontSize: 12,
                          color: AppColors.colorBlack,
                          fontWeight: FontWeight.w600
                      ),),
                      SizedBox(height: ScreenUtils().screenHeight(context)*0.015),
                      CommonSearchableDropdown<MapEntry<int, String>>(
                        items: (String filter, LoadProps? props) async {
                          await Future.delayed(
                              const Duration(milliseconds: 500));
                          return deliveryModeEntries
                              .where((entry) => entry.value
                              .toLowerCase()
                              .contains(filter.toLowerCase()))
                              .toList();
                        },
                        hintText: "Select delivery mode",
                        selectedItem: selectedDeliveryEntry,
                        onChanged: (value) {
                          setState(() {
                            selectedDeliveryEntry = value;
                            // print("Selected ID: ${selectedVisitTypeEntry?.key}");
                            // print("Selected Name: ${selectedVisitTypeEntry?.value}");
                          });
                        },
                        itemAsString: (entry) => entry.value,
                        compareFn: (a, b) => a.key == b.key,
                      ),
                      SizedBox(height: ScreenUtils().screenHeight(context)*0.02),



                      SizedBox(height: ScreenUtils().screenHeight(context)*0.04),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonButton(
                            onTap: (){
                              Navigator.pop(context, {
                                "gender": selectedGenderTypeEntry,
                                "deliveryMode": selectedDeliveryEntry,
                              });
                            },
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
