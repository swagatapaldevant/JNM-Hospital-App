import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:jnm_hospital_app/core/utils/commonWidgets/common_button.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/app_dimensions.dart';
import 'package:jnm_hospital_app/core/utils/helper/screen_utils.dart';
import 'package:jnm_hospital_app/features/admin_report_module/birth_report_module/widgets/male_female_pie_chart.dart';
import 'package:jnm_hospital_app/features/admin_report_module/common_widgets/common_header.dart';
import 'package:jnm_hospital_app/features/admin_report_module/common_widgets/custom_date_picker_field.dart';
import 'package:jnm_hospital_app/features/admin_report_module/dashboard_module/widgets/search_bar.dart';
import 'package:jnm_hospital_app/features/admin_report_module/death_report_module/widgets/doctor_wise_patient_death_count_graph.dart';
import 'package:jnm_hospital_app/features/admin_report_module/opd_patient_report_module/widgets/opd_patient_item_data.dart';


class DeathReportScreen extends StatefulWidget {
  const DeathReportScreen({super.key});

  @override
  State<DeathReportScreen> createState() => _DeathReportScreenState();
}

class _DeathReportScreenState extends State<DeathReportScreen> {
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
            headingName: 'DEATH REPORT',
            onSearchTap: () {
              setState(() {
                isVisible = true;
              });
            },
            isVisibleFilter: false,
            filterTap: () {
              
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


                    SizedBox(height: ScreenUtils().screenHeight(context) * 0.02),

                    DoctorDeathCountLineChart(
                      doctorNames: ["Dr. A", "Dr. B", "Dr. C", "Dr. D"],
                      deathCounts: [3, 1, 5, 2],
                    ),
                    // GenderPieChart(
                    //   maleCount: 120,
                    //   femaleCount: 80,
                    //   labels: ["LUCS", "Normal",],
                    //   lucsCounts: [20, 25,],
                    //   normalCounts: [40, 35,],
                    // ),

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
