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
import 'package:jnm_hospital_app/features/admin_report_module/admin_common_widget/patient_item_data_card.dart';
import 'package:jnm_hospital_app/features/admin_report_module/admin_common_widget/switchable_table_stat.dart';
import 'package:jnm_hospital_app/features/admin_report_module/common_widgets/common_header.dart';
import 'package:jnm_hospital_app/features/admin_report_module/common_widgets/custom_date_picker_field.dart';
import 'package:jnm_hospital_app/features/admin_report_module/dashboard_module/widgets/search_bar.dart';
import 'package:jnm_hospital_app/features/admin_report_module/data/admin_report_usecase.dart';
import 'package:jnm_hospital_app/features/admin_report_module/death_report_module/widgets/death_report_modal_for_death_gender_distribution.dart';
import 'package:jnm_hospital_app/features/admin_report_module/dialysis_patients_report_module/widgets/dialysis_modal_for_advanced_search.dart';
import 'package:jnm_hospital_app/features/admin_report_module/model/dialysis_report/dialysis_patient_report_graph_model.dart';
import 'package:jnm_hospital_app/features/admin_report_module/model/dialysis_report/dialysis_patient_report_model.dart';
import 'package:jnm_hospital_app/features/admin_report_module/model/ipd_report/charge_list_model.dart';
import 'package:jnm_hospital_app/features/admin_report_module/model/ipd_report/tpa_list_model.dart';
import 'package:jnm_hospital_app/features/admin_report_module/model/ipd_report/ward_list_model.dart';
import 'package:jnm_hospital_app/features/admin_report_module/model/opd_patient_report/department_list_model.dart';
import 'package:jnm_hospital_app/features/admin_report_module/model/opd_patient_report/doctor_list_model.dart';
import 'package:jnm_hospital_app/features/admin_report_module/model/opd_patient_report/referral_list_model.dart';
import 'package:jnm_hospital_app/features/admin_report_module/opd_patient_report_module/presentation/opd_patient_report_screen.dart';
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
  //final SharedPref _pref = getIt<SharedPref>();

  List<DialysisPatientReportData> dialysisReportList = [];
  final ScrollController _scrollController = ScrollController();
  int currentPage = 1;

  List<DialysisPatientReportGraphData> graphData = [];
  List<FlSpot> newCount = [];
  List<FlSpot> oldCount = [];
  List<String> departmentName = [];

  // for advanced filter

  String? selectedVisitType = "";

  List<DepartmentListModel> departmentList = [];
  Map<int, String> departmentMap = {};
  String? selectedDepartment = "";

  List<DoctorListModel> consultantDoctorList = [];
  Map<int, String> doctorDataMap = {};
  String? selectedDoctor = "";

  List<ReferralListModel> referralList = [];
  Map<int, String> referralDataMap = {};
  String? selectedReferral = "";

  List<ReferralListModel> marketByList = [];
  Map<int, String> marketByDataMap = {};
  String? selectedMarketByData = "";

  List<ReferralListModel> providerByList = [];
  Map<int, String> providerByDataMap = {};
  String? selectedProviderData = "";

  List<TpaListModel> tpaByList = [];
  Map<int, String> tpaByDataMap = {};
  String? selectedTpaData = "";

  List<WardListModel> wardByList = [];
  Map<int, String> wardByDataMap = {};
  String? selectedWardData = "";

  List<ChargeListModel> chargeByList = [];
  Map<int, String> chargeByDataMap = {};
  String? selectedChargeData = "";

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    selectedFromDate = getCurrentDate();
    selectedToDate = getCurrentDate();
    getDialysisPatientData();
    getAllFilteredListForDialysis();
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
            filterTap: () async {
              final SelectedFilterData? selectedData =
                  await showCommonModalForAdvancedSearchForDialysis(
                      context,
                      {1: "New", 2: "Old"},
                      departmentMap,
                      doctorDataMap,
                      referralDataMap,
                      marketByDataMap,
                      providerByDataMap,
                      tpaByDataMap,
                      wardByDataMap,
                      chargeByDataMap);

              if (selectedData != null) {
                selectedVisitType = selectedData["visitType"]?.value.toString();
                selectedDepartment = selectedData["department"]?.key.toString();
                selectedDoctor = selectedData["doctor"]?.key.toString();
                selectedReferral = selectedData["referral"]?.key.toString();
                selectedMarketByData = selectedData["marketBy"]?.key.toString();
                selectedProviderData = selectedData["provider"]?.key.toString();
                selectedTpaData = selectedData["tpa"]?.key.toString();
                selectedWardData = selectedData["wards"]?.key.toString();
                selectedChargeData = selectedData["charges"]?.key.toString();
                setState(() {
                  dialysisReportList.clear();
                  graphData.clear();
                  newCount.clear();
                  oldCount.clear();
                  departmentName.clear();

                  currentPage = 1;
                  getDialysisPatientData();
                });
              } else {
                print("Modal closed without filtering");
              }
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
                              searchIconOnClick: () {
                                selectedFromDate = "";
                                selectedToDate = "";
                                dialysisReportList.clear();
                                graphData.clear();
                                newCount.clear();
                                oldCount.clear();
                                departmentName.clear();
                                selectedVisitType = "";
                                selectedDepartment = "";
                                selectedDoctor = "";
                                selectedReferral = "";
                                selectedMarketByData = "";
                                selectedProviderData = "";
                                selectedTpaData = "";
                                selectedWardData = "";
                                selectedChargeData = "";
                                currentPage = 1;
                                hasMoreData = true;
                                getDialysisPatientData();
                              },
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
                                    selectedVisitType = "";
                                    selectedDepartment = "";
                                    selectedDoctor = "";
                                    selectedReferral = "";
                                    selectedMarketByData = "";
                                    selectedProviderData = "";
                                    selectedTpaData = "";
                                    selectedWardData = "";
                                    selectedChargeData = "";
                                    currentPage = 1;
                                    hasMoreData = true;
                                    _searchQuery = "";
                                    isVisible = false;
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
                                  ScreenUtils().screenHeight(context) * 0.04),
                          dialysisReportList.isEmpty
                              ? Center(
                                  child: Text(
                                    "No dialysis in this time frame",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.colorBlack),
                                  ),
                                )
                              : Column(
                                  children: [
                                    TableStatsSwitcher(
                                      rows: departmentName,
                                      cols: ["New", "Old"],
                                      isTransposeData: true,
                                      data: [
                                        newCount
                                            .map((e) =>
                                                int.tryParse(e.y.toString()) ??
                                                0)
                                            .toList(),
                                        oldCount
                                            .map((e) =>
                                                int.tryParse(e.y.toString()) ??
                                                0)
                                            .toList(),
                                      ],
                                      headingText:
                                          "Department wise Dialysis Patient",
                                      graphWidget: DepartmentWiseOpdReport(
                                        graphTitle:
                                            "Department wise Dialysis Patient",
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
                                              double.parse(
                                                  maleCount.toString()),
                                              double.parse(
                                                  femaleCount.toString()));
                                        },
                                      ),
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: dialysisReportList.length +
                                          (isLoading && hasMoreData ? 1 : 0),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        if (index < dialysisReportList.length) {
                                          return AnimationConfiguration
                                              .staggeredList(
                                            position: index,
                                            duration: const Duration(
                                                milliseconds: 500),
                                            child: SlideAnimation(
                                              verticalOffset: 50.0,
                                              curve: Curves.easeOut,
                                              child: FadeInAnimation(
                                                curve: Curves.easeIn,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                    bottom: ScreenUtils()
                                                            .screenHeight(
                                                                context) *
                                                        0.02,
                                                  ),
                                                  child: PatientItemData(
                                                    index: index,
                                                    id: dialysisReportList[
                                                            index]
                                                        .id
                                                        .toString(),
                                                    deptId: "dialysis",
                                                    patientName:
                                                        dialysisReportList[
                                                                index]
                                                            .patientName
                                                            .toString(),
                                                    doctor: dialysisReportList[
                                                            index]
                                                        .doctorName,
                                                    department:
                                                        dialysisReportList[
                                                                index]
                                                            .departmentName
                                                            .toString(),
                                                    visitType:
                                                        dialysisReportList[
                                                                index]
                                                            .type
                                                            .toString(),
                                                    info: [
                                                      {
                                                        "gender":
                                                            dialysisReportList[
                                                                    index]
                                                                .gender
                                                                .toString()
                                                      },
                                                      {
                                                        "age":
                                                            dialysisReportList[
                                                                    index]
                                                                .dobYear
                                                                .toString()
                                                      },
                                                      {
                                                        "mobile":
                                                            dialysisReportList[
                                                                    index]
                                                                .phone
                                                                .toString()
                                                      },
                                                      {
                                                        "App. Date":
                                                            dialysisReportList[
                                                                    index]
                                                                .admissionDate
                                                                .toString()
                                                      },
                                                      {
                                                        "wardName":
                                                            dialysisReportList[
                                                                    index]
                                                                .wardName
                                                                .toString()
                                                      },
                                                      {
                                                        "bedName":
                                                            dialysisReportList[
                                                                    index]
                                                                .bedName
                                                                .toString()
                                                      },
                                                      {
                                                        "tpaName":
                                                            dialysisReportList[
                                                                        index]
                                                                    .tpaName ??
                                                                ""
                                                      },
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        } else {
                                          return Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 16),
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                  color: AppColors
                                                      .arrowBackground),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ],
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
      "visit_type": selectedVisitType,
      "department": selectedDepartment,
      "search_data": _searchQuery,
      "doctor": selectedDoctor,
      "referral": selectedReferral,
      "market_by": selectedMarketByData,
      "provider": selectedProviderData,
      'ward': selectedWardData,
      "tpa": selectedTpaData,
      "charge": selectedChargeData,
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

  Future<void> getAllFilteredListForDialysis() async {
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> requestData = {};

    Resource resource = await _adminReportUsecase.getFilteredDataForIpd(
        requestData: requestData);

    if (resource.status == STATUS.SUCCESS) {
      // for department list
      departmentList = (resource.data["department"] as List)
          .map((x) => DepartmentListModel.fromJson(x))
          .toList();
      for (var item in departmentList) {
        if (item.id != null) {
          departmentMap[(item.id ?? 0.0).toInt()] = item.departmentName!;
        }
      }

      // for consultant doctor list

      consultantDoctorList = (resource.data["doctor"] as List)
          .map((x) => DoctorListModel.fromJson(x))
          .toList();
      for (var item in consultantDoctorList) {
        if (item.id != null) {
          doctorDataMap[(item.id ?? 0.0).toInt()] = item.name ?? "";
        }
      }

      // for referral list
      referralList = (resource.data["referral"] as List)
          .map((x) => ReferralListModel.fromJson(x))
          .toList();
      for (var item in referralList) {
        if (item.id != null) {
          referralDataMap[(item.id ?? 0.0).toInt()] = item.referralName ?? "";
        }
      }

      // for market by list
      marketByList = (resource.data["market_by"] as List)
          .map((x) => ReferralListModel.fromJson(x))
          .toList();
      for (var item in marketByList) {
        if (item.id != null) {
          marketByDataMap[(item.id ?? 0.0).toInt()] = item.referralName ?? "";
        }
      }

      // for provider name
      providerByList = (resource.data["provider"] as List)
          .map((x) => ReferralListModel.fromJson(x))
          .toList();
      for (var item in providerByList) {
        if (item.id != null) {
          providerByDataMap[(item.id ?? 0.0).toInt()] = item.referralName ?? "";
        }
      }

      // for tpa name
      tpaByList = (resource.data["tpa"] as List)
          .map((x) => TpaListModel.fromJson(x))
          .toList();
      for (var item in tpaByList) {
        if (item.id != null) {
          tpaByDataMap[(item.id ?? 0.0).toInt()] = item.tpaName ?? "";
        }
      }

      // for wards name
      wardByList = (resource.data["wards"] as List)
          .map((x) => WardListModel.fromJson(x))
          .toList();
      for (var item in wardByList) {
        if (item.id != null) {
          wardByDataMap[(item.id ?? 0.0).toInt()] = item.wardName ?? "";
        }
      }

      // for charges name
      chargeByList = (resource.data["charges"] as List)
          .map((x) => ChargeListModel.fromJson(x))
          .toList();
      for (var item in chargeByList) {
        if (item.id != null) {
          chargeByDataMap[(item.id ?? 0.0).toInt()] = item.chargeName ?? "";
        }
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
