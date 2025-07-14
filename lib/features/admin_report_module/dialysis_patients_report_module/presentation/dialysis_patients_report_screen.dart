import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/locator.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/resource.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/status.dart';
import 'package:jnm_hospital_app/core/services/localStorage/shared_pref.dart';
import 'package:jnm_hospital_app/core/utils/commonWidgets/common_button.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/app_dimensions.dart';
import 'package:jnm_hospital_app/core/utils/helper/common_utils.dart';
import 'package:jnm_hospital_app/core/utils/helper/screen_utils.dart';
import 'package:jnm_hospital_app/features/admin_report_module/common_widgets/common_header.dart';
import 'package:jnm_hospital_app/features/admin_report_module/common_widgets/custom_date_picker_field.dart';
import 'package:jnm_hospital_app/features/admin_report_module/dashboard_module/widgets/search_bar.dart';
import 'package:jnm_hospital_app/features/admin_report_module/data/admin_report_usecase.dart';
import 'package:jnm_hospital_app/features/admin_report_module/death_report_module/widgets/death_report_modal_for_death_gender_distribution.dart';
import 'package:jnm_hospital_app/features/admin_report_module/dialysis_patients_report_module/widgets/dialysis_modal_for_advanced_search.dart';
import 'package:jnm_hospital_app/features/admin_report_module/dialysis_patients_report_module/widgets/dialysis_patient_item.dart';
import 'package:jnm_hospital_app/features/admin_report_module/model/dialysis_report/dialysis_patient_report_graph_model.dart';
import 'package:jnm_hospital_app/features/admin_report_module/model/dialysis_report/dialysis_patient_report_model.dart';
import 'package:jnm_hospital_app/features/admin_report_module/opd_patient_report_module/widgets/department_wise_opd_report.dart';

class DialysisPatientsReportScreen extends StatefulWidget {
  const DialysisPatientsReportScreen({super.key});

  @override
  State<DialysisPatientsReportScreen> createState() =>
      _DialysisPatientsReportScreenState();
}

class _DialysisPatientsReportScreenState
    extends State<DialysisPatientsReportScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool isVisible = false;
  String selectedFromDate = "";
  String selectedToDate = "";
  bool isLoading = false;
  bool hasMoreData = true;

  int? maleCount;
  int? femaleCount;

  final AdminReportUsecase _adminReportUsecase = getIt<AdminReportUsecase>();
  final SharedPref _pref = getIt<SharedPref>();

  List<DialysisPatientReportData> dialysisReportList = [];
  final ScrollController _scrollController = ScrollController();
  int currentPage = 1;

  List<DialysisPatientReportGraphData> graphData = [];
  List<FlSpot> newCount = [];
  List<FlSpot> oldCount = [];
  List<String> departmentName = [];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedFromDate = getCurrentDate();
    selectedToDate = getCurrentDate();
    getDialysisPatientData();
    //getBirthChartData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !isLoading &&
          hasMoreData) {
        currentPage += 1;
        getDialysisPatientData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    AppDimensions.init(context);

    return Scaffold(
      body: Column(
        children: [
          CommonHeaderForReportModule(
            headingName: 'Dialysis PATIENTS REPORT',
            onSearchTap: () {
              setState(() {
                isVisible = true;
              });
            },
            filterTap: () {
              showCommonModalForAdvancedSearchForDialysis(context);
            },
          ),
          Expanded(
            child: isLoading && dialysisReportList.isEmpty
                ? Center(
                    child: CircularProgressIndicator(
                    color: AppColors.arrowBackground,
                  ))
                : SingleChildScrollView(
                    controller: _scrollController,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.screenPadding),
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
                            SizedBox(
                                height:
                                    ScreenUtils().screenHeight(context) * 0.02),
                          ],
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: CustomDatePickerField(
                                  selectedDate: selectedFromDate,
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
                                  selectedDate: selectedToDate,
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
                          SizedBox(
                              height:
                                  ScreenUtils().screenHeight(context) * 0.02),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CommonButton(
                                onTap: () {
                                  dialysisReportList.clear();
                                  graphData.clear();
                                  newCount.clear();
                                  oldCount.clear();
                                  departmentName.clear();
                                  currentPage = 1;
                                  hasMoreData = true;
                                  getDialysisPatientData();
                                },
                                borderRadius: 8,
                                bgColor: AppColors.arrowBackground,
                                height:
                                    ScreenUtils().screenHeight(context) * 0.05,
                                width:
                                    ScreenUtils().screenWidth(context) * 0.28,
                                buttonName: "Filter",
                              ),
                              CommonButton(
                                onTap: () {
                                  setState(() {
                                    selectedFromDate = getCurrentDate();
                                    selectedToDate = getCurrentDate();
                                    dialysisReportList.clear();
                                    graphData.clear();
                                    newCount.clear();
                                    oldCount.clear();
                                    departmentName.clear();
                                    currentPage = 1;
                                    hasMoreData = true;
                                    getDialysisPatientData();
                                  });
                                },
                                borderRadius: 8,
                                bgColor: AppColors.arrowBackground,
                                height:
                                    ScreenUtils().screenHeight(context) * 0.05,
                                width:
                                    ScreenUtils().screenWidth(context) * 0.28,
                                buttonName: "Today",
                              ),
                              CommonButton(
                                onTap: () {
                                  setState(() {
                                    selectedFromDate = "";
                                    selectedToDate = "";
                                    dialysisReportList.clear();
                                    graphData.clear();
                                    newCount.clear();
                                    oldCount.clear();
                                    departmentName.clear();
                                    // selectedVisitType = "";
                                    // selectedDepartment = "";
                                    // selectedDoctor = "";
                                    // selectedReferral = "";
                                    // selectedMarketByData = "";
                                    // selectedProviderData = "";
                                    currentPage = 1;
                                    hasMoreData = true;
                                    getDialysisPatientData();
                                  });
                                },
                                borderRadius: 8,
                                bgColor: AppColors.arrowBackground,
                                height:
                                    ScreenUtils().screenHeight(context) * 0.05,
                                width:
                                    ScreenUtils().screenWidth(context) * 0.28,
                                buttonName: "Reset",
                              ),
                            ],
                          ),
                          SizedBox(
                              height:
                                  ScreenUtils().screenHeight(context) * 0.01),
                          DepartmentWiseOpdReport(
                            graphTitle: "Department wise Dialysis Patient",
                            onTapFullScreen: () {
                              Navigator.pushNamed(context,
                                  "/DepartmentWiseOpdReportLandscapeScreen",
                                  arguments: {
                                    "newCount": newCount,
                                    "oldCount": oldCount,
                                    "departmentName": departmentName
                                  });
                            },
                            yearLabels: departmentName.length > 10
                                ? departmentName.take(10).toList()
                                : departmentName,
                            spotsType1: newCount.length > 10
                                ? newCount.take(10).toList()
                                : newCount,
                            spotsType2: oldCount.length > 10
                                ? oldCount.take(10).toList()
                                : oldCount,
                            onTapPieChart: () {
                              showCommonModalForDeathGenderDistribution(
                                  context,
                                  double.parse(maleCount.toString()),
                                  double.parse(femaleCount.toString()));
                            },
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: dialysisReportList.length +
                                (isLoading && hasMoreData ? 1 : 0),
                            itemBuilder: (BuildContext context, int index) {
                              if (index < dialysisReportList.length) {
                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(milliseconds: 500),
                                  child: SlideAnimation(
                                    verticalOffset: 50.0,
                                    curve: Curves.easeOut,
                                    child: FadeInAnimation(
                                      curve: Curves.easeIn,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          bottom: ScreenUtils()
                                                  .screenHeight(context) *
                                              0.02,
                                        ),
                                        child: DialysisPatientItem(
                                          index: index,
                                          patientName: dialysisReportList[index]
                                              .patientName
                                              .toString(),
                                          department: dialysisReportList[index]
                                              .departmentName
                                              .toString(),
                                          admissionType:
                                              dialysisReportList[index]
                                                  .type
                                                  .toString(),
                                          gender: dialysisReportList[index]
                                              .gender
                                              .toString(),
                                          dobYear: dialysisReportList[index]
                                              .dobYear
                                              .toString(),
                                          mobile: dialysisReportList[index]
                                              .phone
                                              .toString(),
                                          appointmentDate:
                                              dialysisReportList[index]
                                                  .admissionDate
                                                  .toString(),
                                          departmentName:
                                              dialysisReportList[index]
                                                  .departmentName
                                                  .toString(),
                                          wardName: dialysisReportList[index]
                                              .wardName
                                              .toString(),
                                          bedName: dialysisReportList[index]
                                              .bedName
                                              .toString(),
                                          tpaName:
                                              dialysisReportList[index].tpaName,
                                          doctor: dialysisReportList[index]
                                              .doctorName,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                        color: AppColors.arrowBackground),
                                  ),
                                );
                              }
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

  Future<void> getDialysisPatientData() async {
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> requestData = {
      "page": currentPage,
      // "visit_type": selectedVisitType,
      // "department": selectedDepartment,
      // "doctor": selectedDoctor,
      // "referral": selectedReferral,
      // "market_by": selectedMarketByData,
      // "provider": selectedProviderData,
      "from_date": selectedFromDate,
      "to_date": selectedToDate
    };

    Resource resource =
        await _adminReportUsecase.dialysisReportData(requestData: requestData);

    if (resource.status == STATUS.SUCCESS) {
      List<DialysisPatientReportData> newData =
          (resource.data["records"] as List)
              .map((x) => DialysisPatientReportData.fromJson(x))
              .toList();

      graphData = (resource.data["totalsByDept"] as List)
          .map((x) => DialysisPatientReportGraphData.fromJson(x))
          .toList();

      for (int i = 0; i < graphData.length; i++) {
        final item = graphData[i];

        // Safely parse string counts to double
        double newVal = double.tryParse(item.newCount.toString()) ?? 0.0;
        double oldVal = double.tryParse(item.oldCount.toString()) ?? 0.0;
        String dept = item.departmentName.toString();

        newCount.add(FlSpot(i.toDouble(), newVal));
        oldCount.add(FlSpot(i.toDouble(), oldVal));
        departmentName.add(dept);
      }

      maleCount = int.parse(resource.data["totals"]["male_new"].toString()) +
          int.parse(resource.data["totals"]["male_old"].toString());
      femaleCount =
          int.parse(resource.data["totals"]["female_new"].toString()) +
              int.parse(resource.data["totals"]["female_old"].toString());

      setState(() {
        dialysisReportList.addAll(newData);
        isLoading = false;
        if (newData.length < 100) {
          hasMoreData = false;
        }
      });

      if (newData.isEmpty && currentPage > 1) {
        Fluttertoast.showToast(msg: "No more data found");
      }
    } else {
      setState(() {
        isLoading = false;
      });
      CommonUtils().flutterSnackBar(
          context: context, mes: resource.message ?? "", messageType: 4);
    }
  }

  String getCurrentDate() {
    final DateTime now = DateTime.now();
    final String formattedDate =
        "${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    return formattedDate;
  }
}
