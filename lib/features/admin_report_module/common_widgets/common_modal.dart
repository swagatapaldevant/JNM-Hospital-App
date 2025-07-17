import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:jnm_hospital_app/core/utils/commonWidgets/common_button.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/screen_utils.dart';
import 'package:jnm_hospital_app/features/admin_report_module/common_widgets/searchable_dropdown.dart';
import 'package:jnm_hospital_app/features/admin_report_module/opd_patient_report_module/presentation/opd_patient_report_screen.dart';

Future<SelectedFilterData?> showCommonModalForAdvancedSearch(
  BuildContext context,
  Map<int, String> visitTypeList,
  Map<int, String> departmentMap,
  Map<int, String> doctorDataMap,
  Map<int, String> referralDataMap,
  Map<int, String> marketByDataMap,
  Map<int, String> providerByDataMap,
) {
  final List<MapEntry<int, String>> visitTypeEntries =
      visitTypeList.entries.toList();
  MapEntry<int, String>? selectedVisitTypeEntry;

  final List<MapEntry<int, String>> departmentEntries =
      departmentMap.entries.toList();
  MapEntry<int, String>? selectedDepartmentEntry;

  final List<MapEntry<int, String>> doctorEntries =
      doctorDataMap.entries.toList();
  MapEntry<int, String>? selectedDoctorEntry;

  final List<MapEntry<int, String>> referralEntries =
      referralDataMap.entries.toList();
  MapEntry<int, String>? selectedReferralEntry;

  final List<MapEntry<int, String>> marketByEntries =
      marketByDataMap.entries.toList();
  MapEntry<int, String>? selectedMarketByEntry;

  final List<MapEntry<int, String>> providerByEntries =
      providerByDataMap.entries.toList();
  MapEntry<int, String>? selectedProviderByEntry;

  return showDialog<SelectedFilterData>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext dialogContext) {
      return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        child: StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.9,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              child: Padding(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
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
                    SizedBox(
                        height: ScreenUtils().screenHeight(context) * 0.03),
                    Text(
                      "Visit Type",
                      style: TextStyle(
                          fontSize: 12,
                          color: AppColors.colorBlack,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                        height: ScreenUtils().screenHeight(context) * 0.015),
                    CommonSearchableDropdown<MapEntry<int, String>>(
                      items: (String filter, LoadProps? props) async {
                        await Future.delayed(const Duration(milliseconds: 500));
                        return visitTypeEntries
                            .where((entry) => entry.value
                                .toLowerCase()
                                .contains(filter.toLowerCase()))
                            .toList();
                      },
                      hintText: "Select visit type",
                      selectedItem: selectedVisitTypeEntry,
                      onChanged: (value) {
                        setState(() {
                          selectedVisitTypeEntry = value;
                          // print("Selected ID: ${selectedVisitTypeEntry?.key}");
                          // print("Selected Name: ${selectedVisitTypeEntry?.value}");
                        });
                      },
                      itemAsString: (entry) => entry.value,
                      compareFn: (a, b) => a.key == b.key,
                    ),
                    SizedBox(
                        height: ScreenUtils().screenHeight(context) * 0.02),
                    Text(
                      "Department",
                      style: TextStyle(
                          fontSize: 12,
                          color: AppColors.colorBlack,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                        height: ScreenUtils().screenHeight(context) * 0.015),
                    CommonSearchableDropdown<MapEntry<int, String>>(
                      items: (String filter, LoadProps? props) async {
                        await Future.delayed(const Duration(milliseconds: 500));
                        return departmentEntries
                            .where((entry) => entry.value
                                .toLowerCase()
                                .contains(filter.toLowerCase()))
                            .toList();
                      },
                      hintText: "Select Department type",
                      selectedItem: selectedDepartmentEntry,
                      onChanged: (value) {
                        setState(() {
                          selectedDepartmentEntry = value;
                        });
                      },
                      itemAsString: (entry) => entry.value,
                      compareFn: (a, b) => a.key == b.key,
                    ),
                    SizedBox(
                        height: ScreenUtils().screenHeight(context) * 0.02),
                    Text(
                      "Consultant doctor",
                      style: TextStyle(
                          fontSize: 12,
                          color: AppColors.colorBlack,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                        height: ScreenUtils().screenHeight(context) * 0.015),
                    CommonSearchableDropdown<MapEntry<int, String>>(
                      items: (String filter, LoadProps? props) async {
                        await Future.delayed(const Duration(milliseconds: 500));
                        return doctorEntries
                            .where((entry) => entry.value
                                .toLowerCase()
                                .contains(filter.toLowerCase()))
                            .toList();
                      },
                      hintText: "Select Doctor name",
                      selectedItem: selectedDoctorEntry,
                      onChanged: (value) {
                        setState(() {
                          selectedDoctorEntry = value;
                        });
                      },
                      itemAsString: (entry) => entry.value,
                      compareFn: (a, b) => a.key == b.key,
                    ),
                    SizedBox(
                        height: ScreenUtils().screenHeight(context) * 0.02),
                    Text(
                      "Referral",
                      style: TextStyle(
                          fontSize: 12,
                          color: AppColors.colorBlack,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                        height: ScreenUtils().screenHeight(context) * 0.015),
                    CommonSearchableDropdown<MapEntry<int, String>>(
                      items: (String filter, LoadProps? props) async {
                        await Future.delayed(const Duration(milliseconds: 500));
                        return referralEntries
                            .where((entry) => entry.value
                                .toLowerCase()
                                .contains(filter.toLowerCase()))
                            .toList();
                      },
                      hintText: "Select Referral name",
                      selectedItem: selectedReferralEntry,
                      onChanged: (value) {
                        setState(() {
                          selectedReferralEntry = value;
                        });
                      },
                      itemAsString: (entry) => entry.value,
                      compareFn: (a, b) => a.key == b.key,
                    ),
                    SizedBox(
                        height: ScreenUtils().screenHeight(context) * 0.02),
                    Text(
                      "Market By",
                      style: TextStyle(
                          fontSize: 12,
                          color: AppColors.colorBlack,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                        height: ScreenUtils().screenHeight(context) * 0.015),
                    CommonSearchableDropdown<MapEntry<int, String>>(
                      items: (String filter, LoadProps? props) async {
                        await Future.delayed(const Duration(milliseconds: 500));
                        return marketByEntries
                            .where((entry) => entry.value
                                .toLowerCase()
                                .contains(filter.toLowerCase()))
                            .toList();
                      },
                      hintText: "Select market by name",
                      selectedItem: selectedMarketByEntry,
                      onChanged: (value) {
                        setState(() {
                          selectedMarketByEntry = value;
                        });
                      },
                      itemAsString: (entry) => entry.value,
                      compareFn: (a, b) => a.key == b.key,
                    ),
                    SizedBox(
                        height: ScreenUtils().screenHeight(context) * 0.02),
                    Text(
                      "Provider",
                      style: TextStyle(
                          fontSize: 12,
                          color: AppColors.colorBlack,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                        height: ScreenUtils().screenHeight(context) * 0.015),
                    CommonSearchableDropdown<MapEntry<int, String>>(
                      items: (String filter, LoadProps? props) async {
                        await Future.delayed(const Duration(milliseconds: 500));
                        return providerByEntries
                            .where((entry) => entry.value
                                .toLowerCase()
                                .contains(filter.toLowerCase()))
                            .toList();
                      },
                      hintText: "Select provider by name",
                      selectedItem: selectedProviderByEntry,
                      onChanged: (value) {
                        setState(() {
                          selectedProviderByEntry = value;
                        });
                      },
                      itemAsString: (entry) => entry.value,
                      compareFn: (a, b) => a.key == b.key,
                    ),
                    SizedBox(
                        height: ScreenUtils().screenHeight(context) * 0.04),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonButton(
                            onTap: () {
                              Navigator.pop(context, {
                                "visitType": selectedVisitTypeEntry,
                                "department": selectedDepartmentEntry,
                                "doctor": selectedDoctorEntry,
                                "referral": selectedReferralEntry,
                                "marketBy": selectedMarketByEntry,
                                "provider": selectedProviderByEntry,
                              });
                            },
                            borderRadius: 8,
                            bgColor: AppColors.arrowBackground,
                            height: ScreenUtils().screenHeight(context) * 0.05,
                            width: ScreenUtils().screenWidth(context) * 0.3,
                            buttonName: "Filter"),
                        CommonButton(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            borderRadius: 8,
                            bgColor: AppColors.redColor,
                            height: ScreenUtils().screenHeight(context) * 0.05,
                            width: ScreenUtils().screenWidth(context) * 0.3,
                            buttonName: "Close"),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            );
          },
        ),
      );
    },
  );
}
