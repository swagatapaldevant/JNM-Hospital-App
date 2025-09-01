import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/locator.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/resource.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/status.dart';
import 'package:jnm_hospital_app/core/services/localStorage/shared_pref.dart';
import 'package:jnm_hospital_app/core/utils/commonWidgets/common_button.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/app_dimensions.dart';
import 'package:jnm_hospital_app/core/utils/helper/common_utils.dart';
import 'package:jnm_hospital_app/core/utils/helper/screen_utils.dart';
import 'package:jnm_hospital_app/features/admin_report_module/admin_common_widget/switchable_table_stat.dart';
import 'package:jnm_hospital_app/features/admin_report_module/common_widgets/common_header.dart';
import 'package:jnm_hospital_app/features/admin_report_module/common_widgets/custom_date_picker_field.dart';
import 'package:jnm_hospital_app/features/admin_report_module/dashboard_module/widgets/search_bar.dart';
import 'package:jnm_hospital_app/features/admin_report_module/data/admin_report_usecase.dart';
import 'package:jnm_hospital_app/features/admin_report_module/death_report_module/widgets/death_report_modal_for_death_gender_distribution.dart';
import 'package:jnm_hospital_app/features/admin_report_module/ipd_patient_report_module/widgets/ipd_modal_for_advanced_search.dart';
import 'package:jnm_hospital_app/features/admin_report_module/ipd_patient_report_module/widgets/ipd_patient_report_item.dart';
import 'package:jnm_hospital_app/features/admin_report_module/model/ipd_report/charge_list_model.dart';
import 'package:jnm_hospital_app/features/admin_report_module/model/ipd_report/ipd_patient_report_graph.dart';
import 'package:jnm_hospital_app/features/admin_report_module/model/ipd_report/ipd_patient_report_model.dart';
import 'package:jnm_hospital_app/features/admin_report_module/model/ipd_report/tpa_list_model.dart';
import 'package:jnm_hospital_app/features/admin_report_module/model/ipd_report/ward_list_model.dart';
import 'package:jnm_hospital_app/features/admin_report_module/model/opd_patient_report/department_list_model.dart';
import 'package:jnm_hospital_app/features/admin_report_module/model/opd_patient_report/doctor_list_model.dart';
import 'package:jnm_hospital_app/features/admin_report_module/model/opd_patient_report/referral_list_model.dart';
import 'package:jnm_hospital_app/features/admin_report_module/opd_patient_report_module/presentation/opd_patient_report_screen.dart';
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

  String getOneMonthBeforeDate() {
    final now = DateTime.now();
    int year = now.year;
    int month = now.month - 1;
    if (month < 1) {
      month = 12;
      year -= 1;
    }
    final lastDayPrevMonth =
        DateTime(year, month + 1, 0).day; // day 0 = last day of prev month
    final day = now.day > lastDayPrevMonth ? lastDayPrevMonth : now.day;
    final dt = DateTime(year, month, day);
    return _formatYMD(dt);
  }

  String _formatYMD(DateTime d) =>
      "${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

  //String getCurrentDate() => _formatYMD(DateTime.now());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedFromDate = getOneMonthBeforeDate();
    selectedToDate = getCurrentDate();
    getIpdPatientData();
    getAllFilteredListForIpd();
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
            filterTap: () async {
              final SelectedFilterData? selectedData =
                  await showCommonModalForAdvancedSearchForIpdDaycare(
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
                  ipdReportList.clear();
                  graphData.clear();
                  newCount.clear();
                  oldCount.clear();
                  departmentName.clear();

                  currentPage = 1;
                  getIpdPatientData();
                });
              } else {
                print("Modal closed without filtering");
              }
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
                              searchIconOnClick: () {
                                selectedFromDate = "";
                                selectedToDate = "";
                                ipdReportList.clear();
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
                                getIpdPatientData();
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
                          ipdReportList.isEmpty
                              ? Center(
                                  child: Text(
                                    "No IPD patient is there in this time frame",
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
                                      cols:  ["New", "Old"],
                                      isTransposeData: true,
                                      data: [
                                        graphData
                                            .map((e) =>
                                                int.tryParse(
                                                    e.newCount.toString()) ??
                                                0)
                                            .toList(),
                                        graphData
                                            .map((e) =>
                                                int.tryParse(
                                                    e.oldCount.toString()) ??
                                                0)
                                            .toList(),
                                      ],
                                      headingText:
                                          "Department-wise IPD Patient Report",
                                      graphWidget: DepartmentWiseOpdReport(
                                        graphTitle:
                                            "Department-wise IPD Patient Report",
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
                                      itemCount: ipdReportList.length +
                                          (isLoading && hasMoreData ? 1 : 0),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        if (index < ipdReportList.length) {
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
                                                  child: IpdPatientItemData(
                                                    index: index,
                                                    visitType:
                                                        ipdReportList[index]
                                                            .type
                                                            .toString(),
                                                    patientName:
                                                        ipdReportList[index]
                                                            .patientName
                                                            .toString(),
                                                    department:
                                                        ipdReportList[index]
                                                            .departmentName
                                                            .toString(),
                                                    admissionType:
                                                        ipdReportList[index]
                                                            .admissionType
                                                            .toString(),
                                                    gender: ipdReportList[index]
                                                        .gender
                                                        .toString(),
                                                    age: ipdReportList[index]
                                                        .dobYear
                                                        .toString(),
                                                    mobile: ipdReportList[index]
                                                        .phone
                                                        .toString(),
                                                    appointmentDate:
                                                        formatAnyTimestampString(
                                                            ipdReportList[index]
                                                                .admissionDate
                                                                .toString()),
                                                    wardName:
                                                        ipdReportList[index]
                                                            .wardName
                                                            .toString(),
                                                    bedName:
                                                        ipdReportList[index]
                                                            .bedName
                                                            .toString(),
                                                    tpaName:
                                                        ipdReportList[index]
                                                            .tpaName,
                                                    doctor: ipdReportList[index]
                                                        .doctorName,
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

  Future<void> getIpdPatientData() async {
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> requestData = {
      "page": currentPage,
      "visit_type": selectedVisitType,
      "search_data": _searchQuery,
      "department": selectedDepartment,
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

      maleCount =
          int.parse(resource.data["totals"]["admission_type"][0].toString());
      femaleCount =
          int.parse(resource.data["totals"]["admission_type"][1].toString());

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

  Future<void> getAllFilteredListForIpd() async {
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

  String formatAnyTimestampString(
    String timestamp, {
    String pattern = 'dd MMM yyyy, h:mm a',
    String? locale,
    bool toLocalTime = true,
  }) {
    if (timestamp.trim().isEmpty) return '';

    DateTime? dt;

    // Try numeric epoch first
    final intVal = int.tryParse(timestamp);
    if (intVal != null) {
      final absVal = intVal.abs();
      int ms;
      if (absVal >= 1000000000000000000) {
        // ns -> ms
        ms = intVal ~/ 1000000;
      } else if (absVal >= 1000000000000000) {
        // µs -> ms
        ms = intVal ~/ 1000;
      } else if (absVal >= 1000000000000) {
        // ms
        ms = intVal;
      } else {
        // s -> ms
        ms = intVal * 1000;
      }
      dt = DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true); // safe default
    } else {
      // ISO-8601 parse (handles Z / ±HH:MM)
      try {
        dt = DateTime.parse(timestamp);
      } catch (_) {
        return '';
      }
    }

    final display = toLocalTime
        ? (dt.isUtc ? dt.toLocal() : dt)
        : (dt.isUtc ? dt : dt.toUtc());

    return DateFormat(pattern, locale).format(display);
  }
}
