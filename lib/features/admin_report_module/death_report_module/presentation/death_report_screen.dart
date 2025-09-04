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
import 'package:jnm_hospital_app/features/admin_report_module/model/death_report/doctor_by_death_count_model.dart';
import 'package:jnm_hospital_app/features/admin_report_module/model/death_report/patient_death_report_model.dart';

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
  bool isLoading = false;
  bool hasMoreData = true;

  double? maleCount;
  double? femaleCount;

  final AdminReportUsecase _adminReportUsecase = getIt<AdminReportUsecase>();
  final SharedPref _pref = getIt<SharedPref>();
  List<PatientDeathReportModel> deathReportList = [];
  final ScrollController _scrollController = ScrollController();
  int currentPage = 1;

  List<DoctorByDeathCountModel> deathCountByDoctorList = [];
  List<String> doctor = [];
  List<int> totalCount = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedFromDate = getCurrentDate();
    selectedToDate = getCurrentDate();
    getDeathReportData();
    //getBirthChartData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !isLoading &&
          hasMoreData) {
        currentPage += 1;
        getDeathReportData();
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
            headingName: 'DEATH REPORT',
            onSearchTap: () {
              setState(() {
                isVisible = true;
              });
            },
            isVisibleFilter: false,
            filterTap: () {},
          ),
          Expanded(
            child: isLoading && deathReportList.isEmpty
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
                                deathReportList.clear();
                                deathCountByDoctorList.clear();
                                totalCount.clear();
                                doctor.clear();
                                currentPage = 1;
                                hasMoreData = true;
                                getDeathReportData();
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
                                  deathReportList.clear();
                                  deathCountByDoctorList.clear();
                                  totalCount.clear();
                                  doctor.clear();

                                  currentPage = 1;
                                  hasMoreData = true;
                                  getDeathReportData();
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
                                    deathReportList.clear();
                                    deathCountByDoctorList.clear();
                                    totalCount.clear();
                                    doctor.clear();
                                    currentPage = 1;
                                    hasMoreData = true;
                                    getDeathReportData();
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
                                    deathReportList.clear();
                                    deathCountByDoctorList.clear();
                                    totalCount.clear();
                                    doctor.clear();
                                    currentPage = 1;
                                    hasMoreData = true;
                                    _searchQuery = "";
                                    isVisible = false;
                                    getDeathReportData();
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
                          deathReportList.isEmpty
                              ? Center(
                                  child: Text(
                                    "No person is death in this time frame",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.colorBlack),
                                  ),
                                )
                              : Column(
                                  children: [
                                    TableStatsSwitcher(
                                      rows: doctor,
                                      cols: ["Death Count"],
                                      isTransposeData: true,
                                      data: [
                                        deathCountByDoctorList
                                            .map((e) => int.tryParse(
                                                e.totalCount.toString()) ?? 0)
                                            .toList()
                                      ],
                                      headingText: "Gender Distribution",
                                      graphWidget: DoctorDeathCountLineChart(
                                        maleCount: maleCount.toString(),
                                        femaleCount: femaleCount.toString(),
                                        doctorNames: doctor,
                                        deathCounts: totalCount,
                                      ),
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: deathReportList.length +
                                          (isLoading && hasMoreData ? 1 : 0),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        if (index < deathReportList.length) {
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
                                                    hideBtn: true,
                                                    index: index,
                                                    id: deathReportList[index]
                                                            .patientId
                                                            .toString(),
                                                    deptId: "death-report",
                                                    uhid:
                                                        deathReportList[index]
                                                            .patientId
                                                            .toString(),
                                                     doctor:
                                                        deathReportList[index]
                                                            .doctorName
                                                            .toString(),
                                                    patientName:
                                                        deathReportList[index]
                                                            .patientName
                                                            .toString(),
                                                    info: [
                                                      {"gender":
                                                        deathReportList[index]
                                                            .gender
                                                            .toString()},
                                                   { "admDate":
                                                        deathReportList[index]
                                                            .admDate
                                                            .toString()},
                                                    {"disChargeDate":
                                                        deathReportList[index]
                                                            .disDate
                                                            .toString()},
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

  Future<void> getDeathReportData() async {
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> requestData = {
      "page": currentPage,
      "search_data":_searchQuery,
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
        await _adminReportUsecase.deathReportData(requestData: requestData);

    if (resource.status == STATUS.SUCCESS) {
      List<PatientDeathReportModel> newData = (resource.data["records"] as List)
          .map((x) => PatientDeathReportModel.fromJson(x))
          .toList();

      maleCount = double.parse(resource.data["totals"]["gender"][0].toString());
      femaleCount =
          double.parse(resource.data["totals"]["gender"][1].toString());

      deathCountByDoctorList = (resource.data["totalsByDoctor"] as List)
          .map((x) => DoctorByDeathCountModel.fromJson(x))
          .toList();

      for (int i = 0; i < deathCountByDoctorList.length; i++) {
        final item = deathCountByDoctorList[i];
        String d = item.doctorName.toString();
        int count = int.tryParse(item.totalCount.toString()) ?? 0;

        doctor.add(d);
        totalCount.add(count);
      }

      setState(() {
        deathReportList.addAll(newData);
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
