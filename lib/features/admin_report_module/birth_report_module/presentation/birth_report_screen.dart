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
import 'package:jnm_hospital_app/features/admin_report_module/birth_report_module/widgets/birth_report_item.dart';
import 'package:jnm_hospital_app/features/admin_report_module/birth_report_module/widgets/birth_report_modal_for_advanced_search.dart';
import 'package:jnm_hospital_app/features/admin_report_module/birth_report_module/widgets/male_female_pie_chart.dart';
import 'package:jnm_hospital_app/features/admin_report_module/common_widgets/common_header.dart';
import 'package:jnm_hospital_app/features/admin_report_module/common_widgets/custom_date_picker_field.dart';
import 'package:jnm_hospital_app/features/admin_report_module/dashboard_module/widgets/search_bar.dart';
import 'package:jnm_hospital_app/features/admin_report_module/data/admin_report_usecase.dart';
import 'package:jnm_hospital_app/features/admin_report_module/model/birth_chart_report/birth_report_model.dart';
import 'package:jnm_hospital_app/features/admin_report_module/model/birth_chart_report/delivery_mode_model.dart';
import 'package:jnm_hospital_app/features/admin_report_module/opd_patient_report_module/presentation/opd_patient_report_screen.dart';

class BirthReportScreen extends StatefulWidget {
  const BirthReportScreen({super.key});

  @override
  State<BirthReportScreen> createState() => _BirthReportScreenState();
}

class _BirthReportScreenState extends State<BirthReportScreen> {
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
  List<BirthReportModel> birthReportList = [];
  final ScrollController _scrollController = ScrollController();
  int currentPage = 1;

  List<DeliveryModeModel> deliveryTypeList = [];
  List<String> type = [];
  List<int> totalCount = [];

// for advanced filter

  String? selectedGenderType = "";
  String? selectedDeliveryModeType = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedFromDate = getCurrentDate();
    selectedToDate = getCurrentDate();
    getBirthChartData();
    //getBirthChartData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !isLoading &&
          hasMoreData) {
        currentPage += 1;
        getBirthChartData();
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
            headingName: 'BIRTH REPORT',
            onSearchTap: () {
              setState(() {
                isVisible = true;
              });
            },
            filterTap: () async {
              final SelectedFilterData? selectedData =
                  await showCommonModalForAdvancedSearchForBirthReport(context,
                      {1: "Male", 2: "Female"}, {1: "LUCS", 2: "NORMAL"});

              if (selectedData != null) {
                selectedGenderType = selectedData["gender"]?.value.toString();
                selectedDeliveryModeType = selectedData["deliveryMode"]?.key.toString();
                setState(() {
                  birthReportList.clear();
                  deliveryTypeList.clear();
                  type.clear();
                  totalCount.clear();
                  currentPage = 1;
                  getBirthChartData();
                });
              } else {
                print("Modal closed without filtering");
              }
            },
          ),
          Expanded(
            child: isLoading && birthReportList.isEmpty
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
                                birthReportList.clear();
                                type.clear();
                                totalCount.clear();
                                selectedGenderType = "";
                                selectedDeliveryModeType = "";
                                currentPage = 1;
                                hasMoreData = true;
                                getBirthChartData();
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
                                  birthReportList.clear();
                                  type.clear();
                                  totalCount.clear();
                                  // oldCount.clear();

                                  currentPage = 1;
                                  hasMoreData = true;
                                  getBirthChartData();
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
                                    birthReportList.clear();
                                    type.clear();
                                    totalCount.clear();
                                    // oldCount.clear();
                                    currentPage = 1;
                                    hasMoreData = true;
                                    getBirthChartData();
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
                                    birthReportList.clear();
                                    type.clear();
                                    totalCount.clear();
                                    selectedGenderType = "";
                                    selectedDeliveryModeType = "";
                                    currentPage = 1;
                                    hasMoreData = true;
                                    _searchQuery = "";
                                    isVisible = false;
                                    getBirthChartData();
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
                                  ScreenUtils().screenHeight(context) * 0.02),
                          birthReportList.isEmpty
                              ? Center(
                                  child: Text(
                                    "No baby is born in this time frame",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.colorBlack),
                                  ),
                                )
                              : Column(
                                  children: [
                                    GenderPieChart(
                                      maleCount: maleCount ?? 0,
                                      femaleCount: femaleCount ?? 0,
                                      labels: type,
                                      lucsCounts: totalCount,
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: birthReportList.length +
                                          (isLoading && hasMoreData ? 1 : 0),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        if (index < birthReportList.length) {
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
                                                  child: BirthReportItem(
                                                      index: index,
                                                      name: birthReportList[index]
                                                          .name,
                                                      gender:
                                                          birthReportList[index]
                                                              .gender,
                                                      address: birthReportList[index]
                                                          .address,
                                                      guardianName:
                                                          birthReportList[index]
                                                              .guardianName,
                                                      doctorName:
                                                          birthReportList[index]
                                                              .doctorName,
                                                      dob: birthReportList[index]
                                                          .dateOfBirth,
                                                      weight:
                                                          birthReportList[index]
                                                              .weight,
                                                      diagnosis:
                                                          birthReportList[index]
                                                              .diagnosis,
                                                      operation:
                                                          birthReportList[index]
                                                              .operation,
                                                      deliveryMode:
                                                          birthReportList[index]
                                                              .deliveryMode,
                                                      creDate:
                                                          birthReportList[index]
                                                              .creDate),
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

  Future<void> getBirthChartData() async {
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> requestData = {
      "page": currentPage,
      "search_data":_searchQuery,
      "gender":selectedGenderType,
      "delivery_mode": selectedDeliveryModeType == "1" ?"LUCS":selectedDeliveryModeType =="2" ?"NORMAL": "",
      "from_date": selectedFromDate,
      "to_date": selectedToDate
    };

    Resource resource =
        await _adminReportUsecase.birthReportData(requestData: requestData);

    if (resource.status == STATUS.SUCCESS) {
      List<BirthReportModel> newData = (resource.data["records"] as List)
          .map((x) => BirthReportModel.fromJson(x))
          .toList();

      maleCount = int.parse(resource.data["totals"]["gender"][0].toString());
      femaleCount = int.parse(resource.data["totals"]["gender"][1].toString());

      deliveryTypeList = (resource.data["totalsByMode"] as List)
          .map((x) => DeliveryModeModel.fromJson(x))
          .toList();

      for (int i = 0; i < deliveryTypeList.length; i++) {
        final item = deliveryTypeList[i];
        String t = item.deliveryMode.toString() == "null"
            ? "other"
            : item.deliveryMode.toString();
        int count = int.tryParse(item.totalCount.toString()) ?? 0;

        type.add(t);
        totalCount.add(count);
      }

      setState(() {
        birthReportList.addAll(newData);
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
