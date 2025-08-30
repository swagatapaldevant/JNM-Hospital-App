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
import 'package:jnm_hospital_app/features/admin_report_module/admin_common_widget/switchable_table_stat.dart';
import 'package:jnm_hospital_app/features/admin_report_module/billing_report_module/widgets/billing_report_bar_chart.dart';
import 'package:jnm_hospital_app/features/admin_report_module/billing_report_module/widgets/billing_report_item_data.dart';
import 'package:jnm_hospital_app/features/admin_report_module/billing_report_module/widgets/billing_report_modal_for_advanced_search.dart';
import 'package:jnm_hospital_app/features/admin_report_module/common_widgets/common_header.dart';
import 'package:jnm_hospital_app/features/admin_report_module/common_widgets/custom_date_picker_field.dart';
import 'package:jnm_hospital_app/features/admin_report_module/dashboard_module/widgets/search_bar.dart';
import 'package:jnm_hospital_app/features/admin_report_module/data/admin_report_usecase.dart';
import 'package:jnm_hospital_app/features/admin_report_module/dialysis_patients_report_module/widgets/dialysis_modal_for_advanced_search.dart';
import 'package:jnm_hospital_app/features/admin_report_module/model/billing_report/bar_chart_report_model.dart';
import 'package:jnm_hospital_app/features/admin_report_module/model/billing_report/billing_report_model.dart';
import 'package:jnm_hospital_app/features/admin_report_module/model/billing_report/charges_list_model.dart';
import 'package:jnm_hospital_app/features/admin_report_module/model/billing_report/section_list_model.dart';
import 'package:jnm_hospital_app/features/admin_report_module/model/billing_report/users_list_model.dart';
import 'package:jnm_hospital_app/features/admin_report_module/model/opd_patient_report/department_list_model.dart';
import 'package:jnm_hospital_app/features/admin_report_module/model/opd_patient_report/doctor_list_model.dart';
import 'package:jnm_hospital_app/features/admin_report_module/model/opd_patient_report/referral_list_model.dart';
import 'package:jnm_hospital_app/features/admin_report_module/opd_patient_report_module/presentation/opd_patient_report_screen.dart';
import 'package:jnm_hospital_app/features/admin_report_module/opd_patient_report_module/widgets/opd_patient_item_data.dart';

class BillingReportScreen extends StatefulWidget {
  const BillingReportScreen({super.key});

  @override
  State<BillingReportScreen> createState() => _BillingReportScreenState();
}

class _BillingReportScreenState extends State<BillingReportScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool isVisible = false;
  String selectedFromDate = "";
  String selectedToDate = "";
  bool isLoading = false;
  bool hasMoreData = true;

  final AdminReportUsecase _adminReportUsecase = getIt<AdminReportUsecase>();
  final SharedPref _pref = getIt<SharedPref>();
  final ScrollController _scrollController = ScrollController();
  int currentPage = 1;
  List<double> total = [];
  List<double> discount = [];
  List<double> grandTotal = [];
  List<double> paid = [];
  List<double> due = [];
  List<String> type = [];

  List<BillingReportModel> billingList = [];
  List<BarchartReportModel> barChartData = [];

  // for advanced filter

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

  List<ChargesListModel> chargeList = [];
  Map<int, String> chargeByDataMap = {};
  String? selectedChargeData = "";

  List<SectionListModel> sectionList = [];
  Map<int, String> sectionByDataMap = {};
  String? selectedSectionData = "";

  List<UsersListModel> userList = [];
  Map<int, String> userByDataMap = {};
  String? selectedUserData = "";

  @override
  void initState() {
    super.initState();
    selectedFromDate = getCurrentDate();
    selectedToDate = getCurrentDate();
    getBillingReportData();
    getAllFilteredListForBillingReport();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !isLoading &&
          hasMoreData) {
        currentPage += 1;
        getBillingReportData();
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
            headingName: 'BILLING REPORT',
            onSearchTap: () {
              setState(() {
                isVisible = true;
              });
            },
            filterTap: () async {
              final SelectedFilterData? selectedData =
                  await showCommonModalForAdvancedSearchForBillingReport(
                      context,
                      userByDataMap,
                      doctorDataMap,
                      chargeByDataMap,
                      sectionByDataMap,
                      referralDataMap,
                      marketByDataMap,
                      providerByDataMap);

              if (selectedData != null) {
                selectedUserData = selectedData["userType"]?.key.toString();
                selectedDoctor = selectedData["doctor"]?.key.toString();
                selectedChargeData = selectedData["charges"]?.key.toString();
                selectedSectionData = selectedData["section"]?.key.toString();
                selectedReferral = selectedData["referral"]?.key.toString();
                selectedMarketByData = selectedData["marketBy"]?.key.toString();
                selectedProviderData = selectedData["provider"]?.key.toString();

                setState(() {
                  billingList.clear();
                  barChartData.clear();
                  total.clear();
                  discount.clear();
                  grandTotal.clear();
                  paid.clear();
                  due.clear();
                  type.clear();
                  currentPage = 1;
                  getBillingReportData();
                });
              } else {
                print("Modal closed without filtering");
              }
            },
          ),
          Expanded(
            child: isLoading && billingList.isEmpty
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
                              searchIconOnClick: (){
                                selectedFromDate = "";
                                selectedToDate = "";
                                billingList.clear();
                                barChartData.clear();
                                total.clear();
                                discount.clear();
                                grandTotal.clear();
                                paid.clear();
                                due.clear();
                                type.clear();
                                selectedUserData = "";
                                selectedDoctor = "";
                                selectedChargeData = "";
                                selectedReferral = "";
                                selectedSectionData = "";
                                selectedMarketByData = "";
                                selectedProviderData = "";
                                currentPage = 1;
                                hasMoreData = true;
                                getBillingReportData();
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
                                  billingList.clear();
                                  barChartData.clear();
                                  total.clear();
                                  discount.clear();
                                  grandTotal.clear();
                                  paid.clear();
                                  due.clear();
                                  type.clear();
                                  currentPage = 1;
                                  hasMoreData = true;
                                  getBillingReportData();
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
                                    billingList.clear();
                                    barChartData.clear();
                                    total.clear();
                                    discount.clear();
                                    grandTotal.clear();
                                    paid.clear();
                                    due.clear();
                                    type.clear();
                                    currentPage = 1;
                                    hasMoreData = true;
                                    getBillingReportData();
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
                                    billingList.clear();
                                    barChartData.clear();
                                    total.clear();
                                    discount.clear();
                                    grandTotal.clear();
                                    paid.clear();
                                    due.clear();
                                    type.clear();
                                    selectedUserData = "";
                                    selectedDoctor = "";
                                    selectedChargeData = "";
                                    selectedReferral = "";
                                    selectedSectionData = "";
                                    selectedMarketByData = "";
                                    selectedProviderData = "";
                                    currentPage = 1;
                                    hasMoreData = true;
                                    _searchQuery = "";
                                    isVisible = false;
                                    getBillingReportData();
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
                          billingList.isEmpty
                              ? Center(
                                  child: Text(
                                    "No billing list is there in this time frame",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.colorBlack),
                                  ),
                                )
                              : Column(
                                  children: [
                                    TableStatsSwitcher(rows: ["Total", "Discount", "Paid", "Due"],
                                    cols: type, 
                                    headingText: "Billing Chart", 
                                    data: [
                                      total,
                                      discount,
                                      paid,
                                      due
                                    ],
                                    graphWidget: BarChartDetails(
                                        type: type,
                                        total: total,
                                        //grandTotal: grandTotal,
                                        discount: discount,
                                        paid: paid,
                                        due: due)),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: billingList.length +
                                          (isLoading && hasMoreData ? 1 : 0),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        if (index < billingList.length) {
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
                                                  child: BillingReportItemData(
                                                    index: index,
                                                    patientName:
                                                        billingList[index]
                                                            .patientName
                                                            .toString(),
                                                    section: billingList[index]
                                                        .section
                                                        .toString(),
                                                    /**WARNING_UHID */
                                                    uhid: billingList[index]
                                                        .patientId
                                                        .toString(),
                                                    billId: billingList[index]
                                                        .id
                                                        .toString(),
                                                    uid: billingList[index]
                                                        .patientId
                                                        .toString(),
                                                    total: billingList[index]
                                                        .total
                                                        .toString(),
                                                    mobile: billingList[index]
                                                        .phone
                                                        .toString(),
                                                    grandTotal:
                                                        billingList[index]
                                                            .grandTotal
                                                            .toString(),
                                                    billingTime:
                                                        billingList[index]
                                                            .billDate
                                                            .toString(),
                                                    appointmentTime:
                                                        billingList[index]
                                                            .creDate
                                                            .toString(),
                                                    doctor: billingList[index]
                                                        .doctorName
                                                        .toString(),
                                                    discountAmount:
                                                        billingList[index]
                                                            .discountAmount
                                                            .toString(),
                                                    totalPayment:
                                                        billingList[index]
                                                            .totalPayment
                                                            .toString(),
                                                    refundAmount:
                                                        billingList[index]
                                                            .refundAmount
                                                            .toString(),
                                                    dueAmount:
                                                        billingList[index]
                                                            .dueAmount
                                                            .toString(),
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

  Future<void> getBillingReportData() async {
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> requestData = {
      "page": currentPage,
      "user": selectedUserData,
      "doctor": selectedDoctor,
      "search_data":_searchQuery,
      "section": selectedSectionData,
      "referral": selectedReferral,
      "market_by": selectedMarketByData,
      "provider": selectedProviderData,
      "from_date": selectedFromDate,
      "to_date": selectedToDate
    };

    Resource resource =
        await _adminReportUsecase.billingReportData(requestData: requestData);

    if (resource.status == STATUS.SUCCESS) {
      List<BillingReportModel> newData = (resource.data["data"] as List)
          .map((x) => BillingReportModel.fromJson(x))
          .toList();

      barChartData = (resource.data["graph_data"] as List)
          .map((x) => BarchartReportModel.fromJson(x))
          .toList();

      for (int i = 0; i < barChartData.length; i++) {
        final item = barChartData[i];
        double t = double.parse(item.total.toString());
        double d = double.parse(item.discountAmount.toString());
        double gt = double.parse(item.grandTotal.toString());
        double p = double.parse(item.totalPayment.toString());
        double du = double.parse(item.dueAmount.toString());
        String dep = item.section.toString();

        total.add(t);
        discount.add(d);
        grandTotal.add(gt);
        paid.add(p);
        due.add(du);
        type.add(dep); //contains department names
      }

      setState(() {
        billingList.addAll(newData);
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

  Future<void> getAllFilteredListForBillingReport() async {
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> requestData = {};

    Resource resource = await _adminReportUsecase
        .getFilteredDataForBillingReport(requestData: requestData);

    if (resource.status == STATUS.SUCCESS) {
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

      // for charges list
      chargeList = (resource.data["charges"] as List)
          .map((x) => ChargesListModel.fromJson(x))
          .toList();
      for (var item in chargeList) {
        if (item.id != null) {
          chargeByDataMap[(item.id ?? 0.0).toInt()] = item.chargeName ?? "";
        }
      }

      // for section list
      sectionList = (resource.data["section"] as List)
          .map((x) => SectionListModel.fromJson(x))
          .toList();
      for (var item in sectionList) {
        if (item.id != null) {
          sectionByDataMap[(item.id ?? 0.0).toInt()] =
              item.chargesSectionName ?? "";
        }
      }

      // for users list
      userList = (resource.data["users"] as List)
          .map((x) => UsersListModel.fromJson(x))
          .toList();
      for (var item in userList) {
        if (item.id != null) {
          userByDataMap[(item.id ?? 0.0).toInt()] = item.name ?? "";
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
