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
import 'package:jnm_hospital_app/features/admin_report_module/death_report_module/widgets/doctor_wise_patient_death_count_graph.dart';
import 'package:jnm_hospital_app/features/admin_report_module/discharge_report_module/widgets/discrage_report_modal_for_advanced_search.dart';
import 'package:jnm_hospital_app/features/admin_report_module/model/discharge_report/discharge_report_graph_model.dart';
import 'package:jnm_hospital_app/features/admin_report_module/model/discharge_report/discharge_report_model.dart';
import 'package:jnm_hospital_app/features/admin_report_module/opd_patient_report_module/presentation/opd_patient_report_screen.dart';

class DischargeReportScreen extends StatefulWidget {
  const DischargeReportScreen({super.key});

  @override
  State<DischargeReportScreen> createState() => _DischargeReportScreenState();
}

class _DischargeReportScreenState extends State<DischargeReportScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool isVisible = false;
  String selectedFromDate = "";
  String selectedToDate = "";
  bool isLoading = false;
  bool hasMoreData = true;

  double? maleCount;
  double? femaleCount;

  final AdminReportUsecase _adminReportUsecase = getIt<AdminReportUsecase>();
  final SharedPref _pref = getIt<SharedPref>();
  List<DischargeReportModel> dischargeReportList = [];
  final ScrollController _scrollController = ScrollController();
  int currentPage = 1;

  List<DischargeReportGraphModel> dischargeReportGraphData = [];
  List<String> type = [];
  List<int> totalCount = [];

  // for advanced filter
  String? selectedDischargeStatus = "";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedFromDate = getCurrentDate();
    selectedToDate = getCurrentDate();
    getDischargeReportData();
    //getBirthChartData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent &&
          !isLoading &&
          hasMoreData) {
        currentPage += 1;
        getDischargeReportData();
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
            headingName: 'DISCHARGE REPORT',
            onSearchTap: () {
              setState(() {
                isVisible = true;
              });
            },
            isVisibleFilter: true,
            filterTap: () async {
              final SelectedFilterData? selectedData =
              await showCommonModalForAdvancedSearchForDischargeReport(context,
                  {1: "Death", 2: "Refferal", 3: "Normal", 4: "LAMA", 5: "DORB", 6:"DMA"},
              );

              if (selectedData != null) {
                selectedDischargeStatus = selectedData["dischargeStatus"]?.value.toString();
                setState(() {
                  dischargeReportList.clear();
                  type.clear();
                  totalCount.clear();
                  currentPage = 1;
                  getDischargeReportData();
                });
              } else {
                print("Modal closed without filtering");
              }
            },
          ),
          Expanded(
            child:isLoading && dischargeReportList.isEmpty
                ? Center(
                child: CircularProgressIndicator(
                  color: AppColors.arrowBackground,
                ))
                : SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppDimensions.screenPadding),
                child: Column(
                  children: [
                    SizedBox(height: AppDimensions.contentGap3),

                    if (isVisible) ...[
                      CommonSearchBar(
                        searchIconOnClick: (){
                          selectedFromDate = "";
                          selectedToDate = "";
                          dischargeReportList.clear();
                          selectedDischargeStatus = "";
                          //deathCountByDoctorList.clear();
                          totalCount.clear();
                          type.clear();
                          currentPage = 1;
                          hasMoreData = true;
                          getDischargeReportData();
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
                      SizedBox(height: ScreenUtils().screenHeight(context) * 0.02),
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
                    SizedBox(height: ScreenUtils().screenHeight(context) * 0.02),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonButton(
                          onTap: () {
                            dischargeReportList.clear();
                           // deathCountByDoctorList.clear();
                            totalCount.clear();
                            type.clear();

                            currentPage = 1;
                            hasMoreData = true;
                            getDischargeReportData();
                          },
                          borderRadius: 8,
                          bgColor: AppColors.arrowBackground,
                          height: ScreenUtils().screenHeight(context) * 0.05,
                          width: ScreenUtils().screenWidth(context) * 0.28,
                          buttonName: "Filter",
                        ),
                        CommonButton(
                          onTap: () {
                            setState(() {
                              selectedFromDate = getCurrentDate();
                              selectedToDate = getCurrentDate();
                              dischargeReportList.clear();
                             // deathCountByDoctorList.clear();
                              totalCount.clear();
                              type.clear();
                              currentPage = 1;
                              hasMoreData = true;
                              getDischargeReportData();
                            });
                          },
                          borderRadius: 8,
                          bgColor: AppColors.arrowBackground,
                          height: ScreenUtils().screenHeight(context) * 0.05,
                          width: ScreenUtils().screenWidth(context) * 0.28,
                          buttonName: "Today",
                        ),
                        CommonButton(
                          onTap: () {
                            setState(() {
                              selectedFromDate = "";
                              selectedToDate = "";
                              dischargeReportList.clear();
                              selectedDischargeStatus = "";
                              //deathCountByDoctorList.clear();
                              totalCount.clear();
                              type.clear();
                              currentPage = 1;
                              hasMoreData = true;
                              _searchQuery = "";
                              isVisible = false;
                              getDischargeReportData();
                            });
                          },
                          borderRadius: 8,
                          bgColor: AppColors.arrowBackground,
                          height: ScreenUtils().screenHeight(context) * 0.05,
                          width: ScreenUtils().screenWidth(context) * 0.28,
                          buttonName: "Reset",
                        ),

                      ],
                    ),


                    SizedBox(height: ScreenUtils().screenHeight(context) * 0.04),

                    dischargeReportList.isEmpty?Center(
                      child: Text("No discharge are there in that timeframe", style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.colorBlack
                      ),),
                    ):
                    Column(
                      children: [
                        TableStatsSwitcher(
                          rows: type,
                          cols: ["Discharge Count"],
                          isTransposeData: true,
                          data: [
                            totalCount
                          ],
                          headingText: "Discharge Report Status",
                          graphWidget: DoctorDeathCountLineChart(
                            title: "Discharge Report Status",
                            lineColor: AppColors.colorGreen,
                            grad1: AppColors.colorGreen.withOpacity(0.6),
                            grad2: AppColors.colorGreen.withOpacity(0.1),
                            doctorNames:type,
                            deathCounts:totalCount,
                            maleCount:maleCount.toString() ,
                            femaleCount: femaleCount.toString(),
                          ),
                        ),

                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: dischargeReportList.length +
                              (isLoading && hasMoreData ? 1 : 0),
                          itemBuilder:
                              (BuildContext context, int index) {
                            if (index < dischargeReportList.length) {
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
                                        hideBtn: true,
                                        id: dischargeReportList[index].billId.toString(),
                                        // WARNING_UHID: PatientId is being passed in place of UHID
                                        uhid: dischargeReportList[index].patientId.toString(),
                                        deptId: "discharge-report",
                                        patientName: dischargeReportList[index].patientName.toString(),
                                        info: [
                                          {"gender": dischargeReportList[index].gender.toString()},
                                          {"admDate": dischargeReportList[index].admDate.toString()},
                                          {"disChargeDate": dischargeReportList[index].disDate.toString()},
                                          {"billLink": dischargeReportList[index].billLink.toString()},
                                          {"dischargeType": dischargeReportList[index].dischargeType.toString()},
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

  Future<void> getDischargeReportData() async {
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> requestData = {
      "page": currentPage,
      "search_data":_searchQuery,
      "discharge_status": selectedDischargeStatus,
      "from_date": selectedFromDate,
      "to_date": selectedToDate
    };

    Resource resource =
    await _adminReportUsecase.dischargeReportData(requestData: requestData);

    if (resource.status == STATUS.SUCCESS) {
      List<DischargeReportModel> newData = (resource.data["records"] as List)
          .map((x) => DischargeReportModel.fromJson(x))
          .toList();

      maleCount = double.parse(resource.data["totals"]["gender"][0].toString());
      femaleCount =
          double.parse(resource.data["totals"]["gender"][1].toString());
      //
      dischargeReportGraphData = (resource.data["totalsByType"] as List)
          .map((x) => DischargeReportGraphModel.fromJson(x))
          .toList();

      for (int i = 0; i < dischargeReportGraphData.length; i++) {
        final item = dischargeReportGraphData[i];
        String t = item.dischargeType.toString();
        int count = int.tryParse(item.totalCount.toString()) ?? 0;

        type.add(t);
        totalCount.add(count);
      }

      setState(() {
        dischargeReportList.addAll(newData);
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
