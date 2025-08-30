import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/locator.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/resource.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/status.dart';
import 'package:jnm_hospital_app/core/services/localStorage/shared_pref.dart';
import 'package:jnm_hospital_app/core/services/routeGenerator/route_generator.dart';
import 'package:jnm_hospital_app/core/utils/commonWidgets/common_button.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/app_dimensions.dart';
import 'package:jnm_hospital_app/core/utils/helper/common_utils.dart';
import 'package:jnm_hospital_app/core/utils/helper/screen_utils.dart';
import 'package:jnm_hospital_app/features/admin_report_module/admin_common_widget/switchable_table_stat.dart';
import 'package:jnm_hospital_app/features/admin_report_module/common_widgets/common_header.dart';
import 'package:jnm_hospital_app/features/admin_report_module/common_widgets/common_modal.dart';
import 'package:jnm_hospital_app/features/admin_report_module/common_widgets/custom_date_picker_field.dart';
import 'package:jnm_hospital_app/features/admin_report_module/dashboard_module/widgets/search_bar.dart';
import 'package:jnm_hospital_app/features/admin_report_module/data/admin_report_usecase.dart';
import 'package:jnm_hospital_app/features/admin_report_module/model/billing_report/billing_details_model.dart';
import 'package:jnm_hospital_app/features/admin_report_module/model/opd_patient_report/department_list_model.dart';
import 'package:jnm_hospital_app/features/admin_report_module/model/opd_patient_report/doctor_list_model.dart';
import 'package:jnm_hospital_app/features/admin_report_module/model/opd_patient_report/opd_patient_graph_data_model.dart';
import 'package:jnm_hospital_app/features/admin_report_module/model/opd_patient_report/opd_patient_report_data_model.dart';
import 'package:jnm_hospital_app/features/admin_report_module/model/opd_patient_report/referral_list_model.dart';
import 'package:jnm_hospital_app/features/admin_report_module/opd_patient_report_module/widgets/department_wise_opd_report.dart';
import 'package:jnm_hospital_app/features/admin_report_module/opd_patient_report_module/widgets/opd_patient_item_data.dart';

class OpdPatientReportScreen extends StatefulWidget {
  const OpdPatientReportScreen({super.key});

  @override
  State<OpdPatientReportScreen> createState() => _OpdPatientReportScreenState();
}

class _OpdPatientReportScreenState extends State<OpdPatientReportScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool isVisible = false;
  String selectedFromDate = "";
  String selectedToDate = "";
  bool isLoading = false;
  bool hasMoreData = true;

  final AdminReportUsecase _adminReportUsecase = getIt<AdminReportUsecase>();
  final SharedPref _pref = getIt<SharedPref>();
  List<OpdPatientReportDataModel> patientList = [];
  final ScrollController _scrollController = ScrollController();
  int currentPage = 1;
  List<OpdPatientGraphDataModel> graphData = [];
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
  BillingDetailsModel? billingDetails;



  @override
  void initState() {
    super.initState();
    selectedFromDate = getCurrentDate();
    selectedToDate = getCurrentDate();
    getOpdPatientData(1);
    getAllFilteredList();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !isLoading &&
          hasMoreData) {
        currentPage += 1;
        getOpdPatientData(currentPage);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppDimensions.init(context);

    return Scaffold(
      body: Column(
        children: [
          CommonHeaderForReportModule(
            headingName: 'OPD PATIENTS REPORT',
            onSearchTap: () {
              setState(() {
                isVisible = true;
              });
            },
            filterTap: () async {
              final SelectedFilterData? selectedData =
                  await showCommonModalForAdvancedSearch(
                context,
                {1: "New", 2: "Old"},
                departmentMap,
                doctorDataMap,
                referralDataMap,
                marketByDataMap,
                providerByDataMap,
              );

              if (selectedData != null) {
                selectedVisitType = selectedData["visitType"]?.value.toString();
                selectedDepartment = selectedData["department"]?.key.toString();
                selectedDoctor = selectedData["doctor"]?.key.toString();
                selectedReferral = selectedData["referral"]?.key.toString();
                selectedMarketByData = selectedData["marketBy"]?.key.toString();
                selectedProviderData = selectedData["provider"]?.key.toString();
                setState(() {
                  patientList.clear();
                  graphData.clear();
                  newCount.clear();
                  oldCount.clear();
                  departmentName.clear();

                  currentPage = 1;
                  getOpdPatientData(currentPage);
                });
              } else {
                print("Modal closed without filtering");
              }
            },
          ),
          Expanded(
            child: isLoading && patientList.isEmpty
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
                                patientList.clear();
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
                                currentPage = 1;
                                hasMoreData = true;
                                getOpdPatientData(currentPage);
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
                                  patientList.clear();
                                  graphData.clear();
                                  newCount.clear();
                                  oldCount.clear();
                                  departmentName.clear();
                                  currentPage = 1;
                                  hasMoreData = true;
                                  getOpdPatientData(currentPage);
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
                                    patientList.clear();
                                    graphData.clear();
                                    newCount.clear();
                                    oldCount.clear();
                                    departmentName.clear();
                                    currentPage = 1;
                                    hasMoreData = true;
                                    getOpdPatientData(currentPage);
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
                                    patientList.clear();
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
                                    currentPage = 1;
                                    hasMoreData = true;
                                    _searchQuery = "";
                                    isVisible = false;
                                    getOpdPatientData(currentPage);
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
                          patientList.isEmpty
                              ? Center(
                                  child: Text(
                                    "No opd patient is there in this time frame",
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
                                            .toList()
                                      ],
                                      headingText: "Department Wise OPD Report",
                                      graphWidget: DepartmentWiseOpdReport(
                                        isVisible: false,
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
                                      ),
                                    ),


                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: patientList.length +
                                          (isLoading && hasMoreData ? 1 : 0),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        if (index < patientList.length) {
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
                                                  child: OpdPatientItemData(
                                                    index: index,
                                                    patientName:
                                                        patientList[index]
                                                            .patientName
                                                            .toString(),
                                                    department:
                                                        patientList[index]
                                                            .departmentName
                                                            .toString(),
                                                    uhid: patientList[index]
                                                        .patientId
                                                        .toString(),
                                                    opdId: patientList[index]
                                                        .id
                                                        .toString(),
                                                    gender: patientList[index]
                                                        .gender
                                                        .toString(),
                                                    age: patientList[index]
                                                        .dobYear
                                                        .toString(),
                                                    mobile: patientList[index]
                                                        .phone
                                                        .toString(),
                                                    visitType:
                                                        patientList[index]
                                                            .type
                                                            .toString(),
                                                    appointmentDate:
                                                        patientList[index]
                                                            .creDate
                                                            .toString(),
                                                    appointmentTime:
                                                        patientList[index]
                                                            .appointmentDate
                                                            .toString(),
                                                    doctor: patientList[index]
                                                        .doctorName
                                                        .toString(),
                                                    onTap: ()async {
                                                      await getBillingDetails(
                                                          "opd",
                                                          patientList[index]
                                                              .id!);
                                                        Navigator.pushNamed(
                                                            context,
                                                            RouteGenerator
                                                                .kBillingDetailsScreen,
                                                            arguments: billingDetails);
                                                    },
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

  Future<void> getOpdPatientData(int currentPage) async {
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
      "from_date": selectedFromDate,
      "to_date": selectedToDate
    };

    Resource resource = await _adminReportUsecase.opdPatientReportData(
        requestData: requestData);

    if (resource.status == STATUS.SUCCESS) {
      List<OpdPatientReportDataModel> newData = (resource.data["data"] as List)
          .map((x) => OpdPatientReportDataModel.fromJson(x))
          .toList();

      graphData = (resource.data["graph_data"] as List)
          .map((x) => OpdPatientGraphDataModel.fromJson(x))
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

      setState(() {
        patientList.addAll(newData);
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

  Future<void> getAllFilteredList() async {
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> requestData = {};

    Resource resource =
        await _adminReportUsecase.getFilterData(requestData: requestData);

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

  Future<void> getBillingDetails(String deptId, int billId) async {
    setState(() {
      isLoading = true;
    });
  
    Resource resource = await _adminReportUsecase.getBillingDetails(
        deptId: deptId, billId: billId);
  
    if (resource.status == STATUS.SUCCESS) {
      // Handle successful response
      print(resource.data);
      setState(() {
        isLoading = false;
        billingDetails = BillingDetailsModel.fromJson(resource.data);
      });
    } else {
      setState(() {
        isLoading = false;
      });
      CommonUtils().flutterSnackBar(
          context: context, mes: resource.message ?? "", messageType: 4);
    }
  }
}

typedef SelectedFilterData = Map<String, MapEntry<int, String>?>;
