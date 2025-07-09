import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
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
import 'package:jnm_hospital_app/features/admin_report_module/billing_report_module/widgets/billing_report_bar_chart.dart';
import 'package:jnm_hospital_app/features/admin_report_module/billing_report_module/widgets/billing_report_modal_for_advanced_search.dart';
import 'package:jnm_hospital_app/features/admin_report_module/common_widgets/common_header.dart';
import 'package:jnm_hospital_app/features/admin_report_module/common_widgets/custom_date_picker_field.dart';
import 'package:jnm_hospital_app/features/admin_report_module/dashboard_module/widgets/search_bar.dart';
import 'package:jnm_hospital_app/features/admin_report_module/data/admin_report_usecase.dart';
import 'package:jnm_hospital_app/features/admin_report_module/model/billing_report/bar_chart_report_model.dart';
import 'package:jnm_hospital_app/features/admin_report_module/model/billing_report/billing_report_model.dart';
import 'package:jnm_hospital_app/features/admin_report_module/model/opd_patient_report/department_list_model.dart';
import 'package:jnm_hospital_app/features/admin_report_module/model/opd_patient_report/doctor_list_model.dart';
import 'package:jnm_hospital_app/features/admin_report_module/model/opd_patient_report/referral_list_model.dart';
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

  @override
  void initState() {
    super.initState();
    selectedFromDate = getCurrentDate();
    selectedToDate = getCurrentDate();
    getBillingReportData();
    // getAllFilteredList();
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
            filterTap: () {
              showCommonModalForAdvancedSearchForBillingReport(context);
            },
          ),
          Expanded(
            child: isLoading && billingList.isEmpty
                ? Center(
                    child: CircularProgressIndicator(
                    color: AppColors.arrowBackground,
                  ))
                : SingleChildScrollView(
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
                                    selectedVisitType = "";
                                    selectedDepartment = "";
                                    selectedDoctor = "";
                                    selectedReferral = "";
                                    selectedMarketByData = "";
                                    selectedProviderData = "";
                                    currentPage = 1;
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
                          BarChartDetails(
                              type: type,
                              total: total,
                              grandTotal: grandTotal,
                              discount: discount,
                              paid: paid,
                              due: due),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: 10,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    bottom:
                                        ScreenUtils().screenHeight(context) *
                                            0.02),
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

  Future<void> getBillingReportData() async {
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> requestData = {
      "page": currentPage,
      "visit_type": selectedVisitType,
      "department": selectedDepartment,
      "doctor": selectedDoctor,
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
        type.add(dep);
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

  String getCurrentDate() {
    final DateTime now = DateTime.now();
    final String formattedDate =
        "${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    return formattedDate;
  }
}
