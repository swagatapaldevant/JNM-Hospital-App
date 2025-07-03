import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:jnm_hospital_app/core/utils/commonWidgets/common_button.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/app_dimensions.dart';
import 'package:jnm_hospital_app/core/utils/helper/screen_utils.dart';
import 'package:jnm_hospital_app/features/admin_report_module/common_widgets/common_header.dart';
import 'package:jnm_hospital_app/features/admin_report_module/common_widgets/custom_date_picker_field.dart';
import 'package:jnm_hospital_app/features/admin_report_module/dashboard_module/widgets/search_bar.dart';
import 'package:jnm_hospital_app/features/admin_report_module/ipd_patient_report_module/widgets/ipd_modal_for_advanced_search.dart';
import 'package:jnm_hospital_app/features/admin_report_module/opd_patient_report_module/widgets/department_wise_opd_report.dart';
import 'package:jnm_hospital_app/features/admin_report_module/opd_patient_report_module/widgets/opd_patient_item_data.dart';

class IpdPatientReportScreen extends StatefulWidget {
  const IpdPatientReportScreen({super.key});

  @override
  State<IpdPatientReportScreen> createState() => _IpdPatientReportScreenState();
}

class _IpdPatientReportScreenState extends State<IpdPatientReportScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool isVisible = false;
  String selectedFromDate = "";
  String selectedToDate = "";

  final List<FlSpot> spotsType1 = [
    FlSpot(0, 3), // x: 0 (could be "Monday"), y: 3 patients
    FlSpot(1, 5),
    FlSpot(2, 2),
    FlSpot(3, 7),
    FlSpot(4, 6),
    FlSpot(5, 4),
    FlSpot(6, 8),
    FlSpot(7, 7),
    FlSpot(8, 6),
    FlSpot(9, 4),
    FlSpot(10, 8),
  ];
  final List<FlSpot> spotsType2 = [
    FlSpot(0, 8), // x: 0 (could be "Monday"), y: 3 patients
    FlSpot(1, 1),
    FlSpot(2, 9),
    FlSpot(3, 3),
    FlSpot(4, 8),
    FlSpot(5, 4),
    FlSpot(6, 8),
    FlSpot(7, 6),
    FlSpot(8, 6),
    FlSpot(9, 5),
    FlSpot(10, 8),
  ];

// Example department names
  final List<String> departmentName = [
    "General Medicine",
    "Orthopaedics",
    "Gynaecology",
    "Pediatrics",
    "ENT",
    "Dermatology",
    "Cardiology",
    "Pediatrics",
    "ENT",
    "Dermatology",
    "Cardiology",
  ];


  @override
  Widget build(BuildContext context) {
    AppDimensions.init(context);

    return Scaffold(
      body: Column(
        children: [
          CommonHeaderForReportModule(
            headingName: 'IPD PATIENTS REPORT',
            onSearchTap: () {
              setState(() {
                isVisible = true;
              });
            },
            filterTap: () {
              showCommonModalForAdvancedSearchForIpdDaycare(context);
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppDimensions.screenPadding),
                child: Column(
                  children: [
                    SizedBox(height: AppDimensions.contentGap3),

                    if (isVisible) ...[
                      CommonSearchBar(
                        controller: _searchController,
                        hintText: "Search something...",
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                        onTap: () {
                          setState(() {
                            isVisible = false;
                          });
                        },
                      ),
                      SizedBox(height: ScreenUtils().screenHeight(context) * 0.02),
                    ],

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomDatePickerField(
                            onDateChanged: (String value) {
                              setState(() {
                                selectedFromDate = value;
                              });
                            },
                            placeholderText: 'From date',
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: CustomDatePickerField(
                            onDateChanged: (String value) {
                              setState(() {
                                selectedToDate = value;
                              });
                            },
                            placeholderText: 'To date',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: ScreenUtils().screenHeight(context) * 0.02),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonButton(
                          borderRadius: 8,
                          bgColor: AppColors.arrowBackground,
                          height: ScreenUtils().screenHeight(context) * 0.05,
                          width: ScreenUtils().screenWidth(context) * 0.28,
                          buttonName: "Filter",
                        ),
                        CommonButton(
                          borderRadius: 8,
                          bgColor: AppColors.arrowBackground,
                          height: ScreenUtils().screenHeight(context) * 0.05,
                          width: ScreenUtils().screenWidth(context) * 0.28,
                          buttonName: "Today",
                        ),
                        CommonButton(
                          borderRadius: 8,
                          bgColor: AppColors.arrowBackground,
                          height: ScreenUtils().screenHeight(context) * 0.05,
                          width: ScreenUtils().screenWidth(context) * 0.28,
                          buttonName: "Reset",
                        ),

                      ],
                    ),


                    SizedBox(height: ScreenUtils().screenHeight(context) * 0.01),

                    DepartmentWiseOpdReport(
                      graphTitle: "Department-wise IPD Patient Report",
                      onTapFullScreen: (){
                        Navigator.pushNamed(context, "/DepartmentWiseOpdReportLandscapeScreen");
                      },
                      yearLabels: departmentName, spotsType1: spotsType1, spotsType2: spotsType2,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 10,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding:  EdgeInsets.only(bottom: ScreenUtils().screenHeight(context)*0.02),
                          child: OpdPatientItemData(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
