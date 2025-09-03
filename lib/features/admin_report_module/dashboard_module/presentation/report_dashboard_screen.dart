import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/api_endpoint.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/locator.dart';
import 'package:jnm_hospital_app/core/services/localStorage/shared_pref.dart';
import 'package:jnm_hospital_app/core/utils/commonWidgets/common_dialog.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/app_dimensions.dart';
import 'package:jnm_hospital_app/core/utils/helper/common_utils.dart';
import 'package:jnm_hospital_app/core/utils/helper/screen_utils.dart';
import 'package:jnm_hospital_app/features/admin_report_module/admin_common_widget/switchable_table_stat.dart';
import 'package:jnm_hospital_app/features/admin_report_module/dashboard_module/widgets/customer_pie_chart.dart';
import 'package:jnm_hospital_app/features/admin_report_module/dashboard_module/widgets/statistical_graph.dart';

class ReportDashboardScreen extends StatefulWidget {
  const ReportDashboardScreen({super.key});

  @override
  State<ReportDashboardScreen> createState() => _ReportDashboardScreenState();
}

class _ReportDashboardScreenState extends State<ReportDashboardScreen> {
  final SharedPref _pref = getIt<SharedPref>();
  final Dio _dio = DioClient().dio;

  bool isLoading = false;

  String userName = "";
  String profilePhoto = "";

  /// Bar chart series (order must match categories below)
  /// Categories: ["OPD","Emergency","IPD","Daycare","Investigation","Dialysis"]
  List<int> newData = [];
  List<int> oldData = [];

  // OPD
  String totalCollectionOpd = "0";
  String totalPatientOpd = "0";
  String newPatientOpd = "0";
  String oldPatientOpd = "0";

  // EMG
  String totalCollectionEmg = "0";
  String totalPatientEmg = "0";
  String newPatientEmg = "0";
  String oldPatientEmg = "0";

  // IPD
  String totalCollectionIpd = "0";
  String totalPatientIpd = "0";
  String newPatientIpd = "0";
  String oldPatientIpd = "0";

  // Daycare
  String totalCollectionDayCare = "0";
  String totalPatientDayCare = "0";
  String newPatientDayCare = "0";
  String oldPatientDayCare = "0";

  // Investigation
  String totalCollectionInvestigation = "0";
  String totalPatientInvestigation = "0";
  String newPatientInvestigation = "0";
  String oldPatientInvestigation = "0";

  // Dialysis
  String totalCollectionDialysis = "0";
  String totalPatientDialysis = "0";
  String newPatientDialysis = "0";
  String oldPatientDialysis = "0";

  static const List<String> departments = [
    "OPD",
    "EMR",
    "IPD",
    "Daycare",
    "INV",
    "DIA",
  ];

  @override
  void initState() {
    super.initState();
    userData();
    getDashboardData();
  }

  Future<void> userData() async {
    userName = await _pref.getUserName() ?? "";
    profilePhoto = await _pref.getProfileImage() ?? "";
    if (mounted) setState(() {});
  }

  Future<void> _onRefresh() async {
    // pulls fresh data without showing the big loader
    await getDashboardData(showLoader: false);
  }

  @override
  Widget build(BuildContext context) {
    AppDimensions.init(context);
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: ScreenUtils().screenHeight(context) * 0.04,
            width: ScreenUtils().screenWidth(context),
            color: AppColors.overviewCardBgColor,
          ),
          Expanded(
            child: isLoading
                ? Center(
              child: CircularProgressIndicator(
                color: AppColors.arrowBackground,
              ),
            )
                : RefreshIndicator(
              onRefresh: _onRefresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    header(userName, profilePhoto),
                    SizedBox(height: AppDimensions.contentGap1),
                    Padding(
                      padding: EdgeInsets.only(
                        top: AppDimensions.screenPadding,
                        left: AppDimensions.screenPadding,
                        right: AppDimensions.screenPadding,
                      ),
                      
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 30,),
                          TableStatsSwitcher(
                            rows: departments,
                            cols: ["New", "Old"],
                            data:  [newData, oldData],
                            isTransposeData: true,
                            headingText: "Old New patient count per department",
                            graphWidget: StatisticalGraph(
                              key: ValueKey(
                                '${newData.join(",")}::${oldData.join(",")}',
                              ),
                              text: "Old New patient count per department",
                              categories: departments,
                              newData: newData,
                              oldData: oldData,
                            ),
                          ),
                          SizedBox(height: AppDimensions.contentGap3),
                          Text(
                            "Patient & Billing Reports",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.colorBlack,
                            ),
                          ),
                          SizedBox(height: AppDimensions.contentGap3),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceAround,
                            children: [
                              dashboardItem(
                                "assets/images/admin_report/opd.png",
                                "OPD Patient Report",
                                onTap: () {
                                  Navigator.pushNamed(context,
                                      "/OpdPatientReportScreen");
                                },
                              ),
                              dashboardItem(
                                "assets/images/admin_report/emg.png",
                                "EMG Patient Report",
                                onTap: () {
                                  Navigator.pushNamed(context,
                                      "/EmgPatientReportScreen");
                                },
                              ),
                              dashboardItem(
                                "assets/images/admin_report/ipd.png",
                                "IPD/DAYCARE Patient Report",
                                onTap: () {
                                  Navigator.pushNamed(context,
                                      "/IpdPatientReportScreen");
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: AppDimensions.contentGap3),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              dashboardItem(
                                "assets/images/admin_report/dialysis.png",
                                "Dialysis Report",
                                onTap: () {
                                  Navigator.pushNamed(context,
                                      "/DialysisPatientsReportScreen");
                                },
                              ),
                              dashboardItem(
                                "assets/images/admin_report/billing.png",
                                "Billing Report",
                                onTap: () {
                                  Navigator.pushNamed(context,
                                      "/BillingReportScreen");
                                },
                              ),
                              dashboardItem(
                                "assets/images/admin_report/birth_report.png",
                                "Birth Report",
                                onTap: () {
                                  Navigator.pushNamed(context,
                                      "/BirthReportScreen");
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: AppDimensions.contentGap3),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              dashboardItem(
                                "assets/images/admin_report/death_report.png",
                                "Death Report",
                                onTap: () {
                                  Navigator.pushNamed(context,
                                      "/DeathReportScreen");
                                },
                              ),
                              dashboardItem(
                                "assets/images/admin_report/discharge.png",
                                "Discharge Report",
                                onTap: () {
                                  Navigator.pushNamed(context,
                                      "/DischargeReportScreen");
                                },
                              ),

                              dashboardItem(
                                "assets/images/admin_report/opd.png",
                                "Collection Report",
                                onTap: () {
                                  Navigator.pushNamed(context,
                                      "/CollectionReportScreen");
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: AppDimensions.contentGap3),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              dashboardItem(
                                "assets/images/admin_report/death_report.png",
                                "User wise Collection Report",
                                onTap: () {
                                  Navigator.pushNamed(context,
                                      "/UserWiseCollectionReportScreen");
                                },
                              ),

                              dashboardItem(
                                "assets/images/admin_report/death_report.png",
                                "Doctors Payout",
                                onTap: () {
                                  Navigator.pushNamed(context,
                                      "/DoctorsPayoutScreen");
                                },
                              ),

                            ],
                          ),
                          SizedBox(height: AppDimensions.contentGap2),
                        ],
                      ),
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

  // dashboard header section
  Widget header(String userName, String profilePhoto) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: ScreenUtils().screenHeight(context) * 0.52,
          width: ScreenUtils().screenWidth(context),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            color: AppColors.overviewCardBgColor,
            boxShadow: [
              BoxShadow(
                color: AppColors.colorBlack.withOpacity(0.25),
                offset: const Offset(0.0, 4.0),
                blurRadius: 4.0,
                spreadRadius: 0.0,
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.screenPadding,
              vertical: AppDimensions.screenWidth * 0.05,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      //"John Doe",
                      userName,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: AppColors.white,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "Admin",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: AppColors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Row(
                  spacing: 15,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          "https://www.shutterstock.com/image-photo/head-shot-portrait-close-smiling-600nw-1714666150.jpg",
                          // (profilePhoto.isEmpty || profilePhoto == "null")
                          //     ? "https://www.shutterstock.com/image-photo/head-shot-portrait-close-smiling-600nw-1714666150.jpg"
                          //     : profilePhoto,
                          height: AppDimensions.screenHeight * 0.07,
                          width: AppDimensions.screenWidth * 0.15,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Bounceable(
                        onTap: () {
                          CommonDialog(
                            icon: Icons.logout,
                            title: "Log Out",
                            msg:
                            "You are about to logout of your account. Please confirm.",
                            activeButtonLabel: "Log Out",
                            context: context,
                            activeButtonOnClicked: () {
                              _pref.clearOnLogout();
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                "/PatientLoginScreen",
                                    (route) => false,
                              );
                            },
                          );
                        },
                        child: Icon(
                          Icons.logout,
                          size: 30,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Positioned(
          left: AppDimensions.screenWidth * 0.05,
          right: AppDimensions.screenWidth * 0.05,
          top: AppDimensions.screenHeight * 0.13,
          child: Container(
            width: AppDimensions.screenWidth * 0.9,
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.colorBlack.withOpacity(0.25),
                  offset: const Offset(0.0, 4.0),
                  blurRadius: 4.0,
                  spreadRadius: 0.0,
                )
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.screenWidth * 0.03,
                vertical: AppDimensions.screenWidth * 0.03,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Today's Overview",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.colorBlack,
                    ),
                  ),
                  SizedBox(height: AppDimensions.screenHeight * 0.01),
                  Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      overviewCard(
                        text: 'Total Patients Statistics',
                        opdPatients: totalPatientOpd,
                        emergencyPatients: totalPatientEmg,
                        ipdPatients: totalPatientIpd,
                        daycarePatients: totalPatientDayCare,
                        investigationPatients: totalPatientInvestigation,
                        dialysisPatients: totalPatientDialysis,
                        isSuffeled: true,
                      ),
                      overviewCard(
                        isSuffeled: false,
                        text: 'Total Collections Statistics',
                        opdPatients: totalCollectionOpd,
                        emergencyPatients: totalCollectionEmg,
                        ipdPatients: totalCollectionIpd,
                        daycarePatients: totalCollectionDayCare,
                        investigationPatients: totalCollectionInvestigation,
                        dialysisPatients: totalCollectionDialysis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: AppDimensions.screenWidth * 0.35,
          child: Image.asset(
            "assets/images/admin_report/stethoscope.png",
            height: ScreenUtils().screenHeight(context) * 0.1,
            width: ScreenUtils().screenWidth(context) * 0.1,
          ),
        ),
        Positioned(
          top: 0,
          left: AppDimensions.screenWidth * 0.3,
          child: Image.asset(
            "assets/images/admin_report/medical.png",
            height: ScreenUtils().screenHeight(context) * 0.06,
            width: ScreenUtils().screenWidth(context) * 0.06,
          ),
        ),
        Positioned(
          top: AppDimensions.screenHeight * 0.06,
          left: AppDimensions.screenWidth * 0.45,
          child: Image.asset(
            "assets/images/admin_report/pills.png",
            height: ScreenUtils().screenHeight(context) * 0.07,
            width: ScreenUtils().screenWidth(context) * 0.07,
          ),
        )
      ],
    );
  }

  // dashboard item
  Widget dashboardItem(String imageLink, String text,
      {required Function() onTap}) {
    return Bounceable(
      onTap: onTap,
      child: Container(
        height: ScreenUtils().screenHeight(context) * 0.19,
        width: ScreenUtils().screenWidth(context) * 0.28,
        decoration: BoxDecoration(
          color: AppColors.reportDashboardCategoryBg,
          boxShadow: [
            BoxShadow(
              color: AppColors.colorBlack.withOpacity(0.25),
              offset: const Offset(0.0, 4.0),
              blurRadius: 4.0,
              spreadRadius: 0.0,
            )
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(ScreenUtils().screenWidth(context) * 0.03),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset(imageLink),
              ),
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.colorBlack,
                  fontSize: 10,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget overviewCard({
    required String text,
    required String opdPatients,
    required String emergencyPatients,
    required String ipdPatients,
    required String daycarePatients,
    required String investigationPatients,
    required String dialysisPatients,
    required bool isSuffeled,
  }) {
    double safeParse(String v) {
      if (v.isEmpty) return 0.0;
      return double.tryParse(v) ?? 0.0;
    }

    return Container(
      width: ScreenUtils().screenWidth(context) * 0.83,
      decoration: BoxDecoration(
        color: AppColors.overviewCardBgColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.colorBlack.withOpacity(0.25),
            offset: const Offset(5.0, 5.0),
            blurRadius: 7.0,
            spreadRadius: 0.0,
          ),
          BoxShadow(
            color: AppColors.colorBlack.withOpacity(0.25),
            offset: const Offset(1.0, 3.0),
            blurRadius: 3.0,
            spreadRadius: 0.0,
          ),
          BoxShadow(
            color: AppColors.white.withOpacity(0.79),
            offset: const Offset(-2.0, 0.0),
            blurRadius: 4.0,
            spreadRadius: 0.0,
          ),
          BoxShadow(
            color: AppColors.white.withOpacity(0.40),
            offset: const Offset(2.0, 0.0),
            blurRadius: 6.0,
            spreadRadius: 0.0,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(ScreenUtils().screenWidth(context) * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: AppColors.white,
                ),
              ),
            ),
            const SizedBox(height: 5),
            CustomPatientPieChart(
              isSuffeled: isSuffeled,
              opdPatients: safeParse(opdPatients),
              emergencyPatients: safeParse(emergencyPatients),
              ipdPatients: safeParse(ipdPatients),
              daycarePatients: safeParse(daycarePatients),
              investigationPatients: safeParse(investigationPatients),
              dialysisPatients: safeParse(dialysisPatients),
            )
          ],
        ),
      ),
    );
  }

  /// Fetch dashboard data
  /// showLoader=true -> big page loader; false -> only pull-to-refresh spinner
  Future<void> getDashboardData({bool showLoader = true}) async {
    if (showLoader) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      // prepare arrays (avoid duplicates on refresh)
      newData = [];
      oldData = [];

      final String token = await _pref.getUserAuthToken();
      final response = await _dio.get(
        ApiEndPoint.dashboard,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200 && response.data["success"] == true) {
        // OPD
        totalCollectionOpd =
            response.data["data"]["opd"]["income"].toString();
        totalPatientOpd =
            response.data["data"]["opd"]["total_patient"].toString();
        newPatientOpd =
            response.data["data"]["opd"]["new_patient"].toString();
        oldPatientOpd =
            response.data["data"]["opd"]["old_patient"].toString();

        // EMG
        totalCollectionEmg =
            response.data["data"]["emergency"]["income"].toString();
        totalPatientEmg =
            response.data["data"]["emergency"]["total_patient"].toString();
        newPatientEmg =
            response.data["data"]["emergency"]["new_patient"].toString();
        oldPatientEmg =
            response.data["data"]["emergency"]["old_patient"].toString();

        // IPD
        totalCollectionIpd =
            response.data["data"]["ipd"]["income"].toString();
        totalPatientIpd =
            response.data["data"]["ipd"]["total_patient"].toString();
        newPatientIpd =
            response.data["data"]["ipd"]["new_patient"].toString();
        oldPatientIpd =
            response.data["data"]["ipd"]["old_patient"].toString();

        // Daycare
        totalCollectionDayCare =
            response.data["data"]["daycare"]["income"].toString();
        totalPatientDayCare =
            response.data["data"]["daycare"]["total_patient"].toString();
        newPatientDayCare =
            response.data["data"]["daycare"]["new_patient"].toString();
        oldPatientDayCare =
            response.data["data"]["daycare"]["old_patient"].toString();

        // Investigation
        totalCollectionInvestigation =
            response.data["data"]["investigation"]["income"].toString();
        totalPatientInvestigation = response.data["data"]["investigation"]
        ["total_patient"]
            .toString();
        newPatientInvestigation = response
            .data["data"]["investigation"]["new_patient"]
            .toString();
        oldPatientInvestigation = response
            .data["data"]["investigation"]["old_patient"]
            .toString();

        // Dialysis
        totalCollectionDialysis =
            response.data["data"]["dialysis"]["income"].toString();
        totalPatientDialysis =
            response.data["data"]["dialysis"]["total_patient"].toString();
        newPatientDialysis =
            response.data["data"]["dialysis"]["new_patient"].toString();
        oldPatientDialysis =
            response.data["data"]["dialysis"]["old_patient"].toString();

        // Maintain same order as chart categories
        newData.addAll([
          int.tryParse(newPatientOpd) ?? 0,
          int.tryParse(newPatientEmg) ?? 0,
          int.tryParse(newPatientIpd) ?? 0,
          int.tryParse(newPatientDayCare) ?? 0,
          int.tryParse(newPatientInvestigation) ?? 0,
          int.tryParse(newPatientDialysis) ?? 0,
        ]);

        oldData.addAll([
          int.tryParse(oldPatientOpd) ?? 0,
          int.tryParse(oldPatientEmg) ?? 0,
          int.tryParse(oldPatientIpd) ?? 0,
          int.tryParse(oldPatientDayCare) ?? 0,
          int.tryParse(oldPatientInvestigation) ?? 0,
          int.tryParse(oldPatientDialysis) ?? 0,
        ]);

        print(newData);
        print(oldData);

      } else {
        CommonUtils().flutterSnackBar(
          context: context,
          mes: "Api Error",
          messageType: 4,
        );
      }
    } on DioException {
      CommonUtils().flutterSnackBar(
        context: context,
        mes: "Api Error",
        messageType: 4,
      );
    } finally {
      if (mounted) {
        if (showLoader) {
          setState(() {
            isLoading = false;
          });
        } else {
          // just rebuild to reflect fresh data; no big loader
          setState(() {});
        }
      }
    }
  }
}

class DioClient {
  static final DioClient _instance = DioClient._internal();
  late final Dio _dio;

  factory DioClient() {
    return _instance;
  }

  DioClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndPoint.baseurl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
        responseType: ResponseType.json,
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    _initializeInterceptors();
  }

  Dio get dio => _dio;

  void _initializeInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // ignore: avoid_print
          print('➡️ REQUEST[${options.method}] => PATH: ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // ignore: avoid_print
          print('✅ RESPONSE[${response.statusCode}] => DATA: ${response.data}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          // ignore: avoid_print
          print('❌ ERROR[${e.response?.statusCode}] => MESSAGE: ${e.message}');
          return handler.next(e);
        },
      ),
    );
  }
}
