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
import 'package:jnm_hospital_app/features/admin_report_module/ipd_patient_report_module/widgets/ipd_modal_for_advanced_search.dart';
import 'package:jnm_hospital_app/features/admin_report_module/ipd_patient_report_module/widgets/ipd_patient_report_item.dart';
import 'package:jnm_hospital_app/features/admin_report_module/model/ipd_report/ipd_patient_report_graph.dart';
import 'package:jnm_hospital_app/features/admin_report_module/model/ipd_report/ipd_patient_report_model.dart';
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
  bool isLoading = false;
  bool hasMoreData = true;

  int? maleCount;
  int? femaleCount;

  final AdminReportUsecase _adminReportUsecase = getIt<AdminReportUsecase>();
  final SharedPref _pref = getIt<SharedPref>();

  List<IpdPatientReportData> ipdReportList = [];
  final ScrollController _scrollController = ScrollController();
  int currentPage = 1;

  List<IpdPatientReportGraphData> graphData = [];
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
    getIpdPatientData();
    //getBirthChartData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !isLoading &&
          hasMoreData) {
        currentPage += 1;
        getIpdPatientData();
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
            child: isLoading && ipdReportList.isEmpty
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
                                  ipdReportList.clear();
                                  graphData.clear();
                                  newCount.clear();
                                  oldCount.clear();
                                  departmentName.clear();

                                  currentPage = 1;
                                  hasMoreData = true;
                                  getIpdPatientData();
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
                                    ipdReportList.clear();
                                    graphData.clear();
                                    newCount.clear();
                                    oldCount.clear();
                                    departmentName.clear();
                                    currentPage = 1;
                                    hasMoreData = true;
                                    getIpdPatientData();
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
                                    ipdReportList.clear();
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
                                    getIpdPatientData();
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
                            graphTitle: "Department-wise IPD Patient Report",
                            onTapFullScreen: () {
                              Navigator.pushNamed(context,
                                  "/DepartmentWiseOpdReportLandscapeScreen", arguments: {
                                    "newCount": newCount,
                                    "oldCount": oldCount,
                                    "departmentName": departmentName
                                  });
                            },
                            yearLabels: departmentName.length>10?departmentName.take(10).toList():departmentName,
                            spotsType1: newCount.length>10? newCount.take(10).toList():newCount,
                            spotsType2: oldCount.length>10? oldCount.take(10).toList():oldCount,
                            onTapPieChart: (){
                              showCommonModalForDeathGenderDistribution(context, double.parse(maleCount.toString()), double.parse(femaleCount.toString()));
                            },

                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: ipdReportList.length +
                                (isLoading && hasMoreData ? 1 : 0),
                            itemBuilder: (BuildContext context, int index) {
                              if (index < ipdReportList.length) {
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
                                        child: IpdPatientItemData(
                                          index: index,
                                          patientName: ipdReportList[index]
                                              .patientName
                                              .toString(),
                                          department: ipdReportList[index]
                                              .departmentName
                                              .toString(),
                                          admissionType: ipdReportList[index]
                                              .admissionType
                                              .toString(),
                                          gender: ipdReportList[index]
                                              .gender
                                              .toString(),
                                          dobYear: ipdReportList[index]
                                              .dobYear
                                              .toString(),
                                          mobile: ipdReportList[index]
                                              .phone
                                              .toString(),
                                          appointmentDate: ipdReportList[index]
                                              .admissionDate
                                              .toString(),
                                          departmentName: ipdReportList[index]
                                              .departmentName
                                              .toString(),
                                          wardName: ipdReportList[index]
                                              .wardName
                                              .toString(),
                                          bedName: ipdReportList[index]
                                              .bedName
                                              .toString(),
                                          tpaName: ipdReportList[index].tpaName,
                                          doctor:
                                              ipdReportList[index].doctorName,
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

  Future<void> getIpdPatientData() async {
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
        await _adminReportUsecase.ipdReportData(requestData: requestData);

    if (resource.status == STATUS.SUCCESS) {
      List<IpdPatientReportData> newData = (resource.data["records"] as List)
          .map((x) => IpdPatientReportData.fromJson(x))
          .toList();

      graphData = (resource.data["totalsByDept"] as List)
          .map((x) => IpdPatientReportGraphData.fromJson(x))
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

      maleCount = int.parse(resource.data["totals"]["admission_type"][0].toString());
      femaleCount = int.parse(resource.data["totals"]["admission_type"][1].toString());

      setState(() {
        ipdReportList.addAll(newData);
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
