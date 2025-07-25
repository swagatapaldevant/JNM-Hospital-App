import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/api_endpoint.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/locator.dart';
import 'package:jnm_hospital_app/core/services/localStorage/shared_pref.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/app_dimensions.dart';
import 'package:jnm_hospital_app/core/utils/helper/common_utils.dart';
import 'package:jnm_hospital_app/core/utils/helper/screen_utils.dart';
import 'package:jnm_hospital_app/features/admin_report_module/dashboard_module/widgets/customer_pie_chart.dart';
import 'package:jnm_hospital_app/features/admin_report_module/dashboard_module/widgets/statistical_graph.dart';
import 'package:jnm_hospital_app/features/admin_report_module/model/dashboard/dashboard_opd_data_model.dart';

class ReportDashboardScreen extends StatefulWidget {
  const ReportDashboardScreen({super.key});

  @override
  State<ReportDashboardScreen> createState() => _ReportDashboardScreenState();
}

class _ReportDashboardScreenState extends State<ReportDashboardScreen> {
  final SharedPref _pref = getIt<SharedPref>();
  final Dio _dio = DioClient().dio;
  bool isLoading = false;

  List<int> newData = [];
  List<int> oldData = [];

  //List<DashboardOpdDataModel> opdData = [];
  String totalCollectionOpd = "";
  String totalPatientOpd = "";
  String newPatientOpd = "";
  String oldPatientOpd = "";

  //List<DashboardOpdDataModel> emgData = [];
  String totalCollectionEmg = "";
  String totalPatientEmg = "";
  String newPatientEmg = "";
  String oldPatientEmg = "";

  //List<DashboardOpdDataModel> ipdData = [];
  String totalCollectionIpd = "";
  String totalPatientIpd = "";
  String newPatientIpd = "";
  String oldPatientIpd = "";

  // List<DashboardOpdDataModel> ipdData = [];
  String totalCollectionDayCare = "";
  String totalPatientDayCare = "";
  String newPatientDayCare = "";
  String oldPatientDayCare = "";

  String totalCollectionInvestigation = "";
  String totalPatientInvestigation = "";
  String newPatientInvestigation = "";
  String oldPatientInvestigation = "";

  String totalCollectionDialysis = "";
  String totalPatientDialysis = "";
  String newPatientDialysis = "";
  String oldPatientDialysis = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDashboardData();
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
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        header(),
                        SizedBox(
                          height: AppDimensions.contentGap1,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: AppDimensions.screenPadding,
                              left: AppDimensions.screenPadding,
                              right: AppDimensions.screenPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              StatisticalGraph(
                                text: "Old New Patient Count per Department",
                                categories: [
                                  "OPD",
                                  "Emergency",
                                  "IPD",
                                  "Daycare",
                                  "Investigation",
                                  "Dialysis"
                                ],
                                newData: newData,
                                oldData: oldData,
                              ),
                              SizedBox(
                                height: AppDimensions.contentGap3,
                              ),
                              Text(
                                "Patient & Billing Reports",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.colorBlack),
                              ),
                              SizedBox(
                                height: AppDimensions.contentGap3,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  dashboardItem(
                                    "assets/images/admin_report/opd.png",
                                    "OPD Patient Report",
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, "/OpdPatientReportScreen");
                                    },
                                  ),
                                  dashboardItem(
                                      "assets/images/admin_report/emg.png",
                                      "EMG Patient Report", onTap: () {
                                    Navigator.pushNamed(
                                        context, "/EmgPatientReportScreen");
                                  }),
                                  dashboardItem(
                                      "assets/images/admin_report/ipd.png",
                                      "IPD/DAYCARE Patient Report", onTap: () {
                                    Navigator.pushNamed(
                                        context, "/IpdPatientReportScreen");
                                  }),
                                ],
                              ),
                              SizedBox(
                                height: AppDimensions.contentGap3,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  dashboardItem(
                                      "assets/images/admin_report/dialysis.png",
                                      "Dialysis Report", onTap: () {
                                    Navigator.pushNamed(context,
                                        "/DialysisPatientsReportScreen");
                                  }),
                                  dashboardItem(
                                      "assets/images/admin_report/billing.png",
                                      "Billing Report", onTap: () {
                                    Navigator.pushNamed(
                                        context, "/BillingReportScreen");
                                  }),
                                  dashboardItem(
                                      "assets/images/admin_report/birth_report.png",
                                      "Birth Report", onTap: () {
                                    Navigator.pushNamed(
                                        context, "/BirthReportScreen");
                                  }),
                                ],
                              ),
                              SizedBox(
                                height: AppDimensions.contentGap3,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  dashboardItem(
                                      "assets/images/admin_report/death_report.png",
                                      "Death Report", onTap: () {
                                    Navigator.pushNamed(
                                        context, "/DeathReportScreen");
                                  }),
                                  dashboardItem(
                                      "assets/images/admin_report/discharge.png",
                                      "Discharge Report", onTap: () {
                                    Navigator.pushNamed(
                                        context, "/DischargeReportScreen");
                                  }),
                                  // dashboardItem(
                                  //     "assets/images/admin_report/edited_bill.png",
                                  //     "Edited Bill Report", onTap: () {
                                  //   Navigator.pushNamed(
                                  //       context, "/EditBillReportScreen");
                                  // }),
                                ],
                              ),
                              SizedBox(
                                height: AppDimensions.contentGap2,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // dashboard header section
  Widget header() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: ScreenUtils().screenHeight(context) * 0.52,
          width: ScreenUtils().screenWidth(context),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
            color: AppColors.overviewCardBgColor,
            boxShadow: [
              BoxShadow(
                color: AppColors.colorBlack.withOpacity(0.25),
                offset: const Offset(
                  0.0,
                  4.0,
                ),
                blurRadius: 4.0,
                spreadRadius: 0.0,
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.screenPadding,
                vertical: AppDimensions.screenWidth * 0.05),
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
                          fontSize: 14),
                    ),
                    Text(
                      "DHIRAJ KHADKA",
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: AppColors.white,
                          fontSize: 18),
                    ),
                    Text(
                      "ADMIN",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: AppColors.white,
                          fontSize: 14),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      "https://www.shutterstock.com/image-photo/head-shot-portrait-close-smiling-600nw-1714666150.jpg",
                      height: AppDimensions.screenHeight * 0.06,
                      width: AppDimensions.screenWidth * 0.15,
                      fit: BoxFit.fill,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Positioned(
          left: AppDimensions.screenWidth * 0.05,
          right: AppDimensions.screenWidth * 0.05,
          //bottom: -AppDimensions.screenHeight * 0.06,
          top: AppDimensions.screenHeight * 0.13,
          child: Container(
            width: AppDimensions.screenWidth * 0.9,
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.colorBlack.withOpacity(0.25),
                  offset: const Offset(
                    0.0,
                    4.0,
                  ),
                  blurRadius: 4.0,
                  spreadRadius: 0.0,
                )
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.screenWidth * 0.03,
                  vertical: AppDimensions.screenWidth * 0.03),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Today's Overview",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.colorBlack),
                  ),
                  SizedBox(
                    height: AppDimensions.screenHeight * 0.01,
                  ),
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
                          isSuffeled: true),
                      overviewCard(
                        isSuffeled: false,
                        text: 'Total Collections Statistics',
                        opdPatients: totalCollectionOpd,
                        emergencyPatients: totalCollectionEmg,
                        ipdPatients: totalCollectionIpd,
                        daycarePatients: totalCollectionDayCare,
                        investigationPatients: totalCollectionInvestigation,
                        dialysisPatients: totalCollectionDialysis,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: AppDimensions.screenWidth * 0.25,
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

  // dashboard card section
  Widget dashBoardCard() {
    return Container(
      width: ScreenUtils().screenWidth(context),
      height: ScreenUtils().screenHeight(context) * 0.2,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColors.colorBlack.withOpacity(0.25),
              offset: const Offset(
                0.0,
                4.0,
              ),
              blurRadius: 4.0,
              spreadRadius: 0.0,
            )
          ],
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.reportDashboardCardGrad1,
                AppColors.reportDashboardCardGrad2,
              ])),
      child: Padding(
        padding: EdgeInsets.only(left: AppDimensions.screenPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Hospital \nInsights & \nAnalytics \nDashboard",
              style: TextStyle(
                  shadows: [
                    Shadow(
                      blurRadius: 4.0, // shadow blur
                      color: AppColors.colorBlack
                          .withOpacity(0.36), // shadow color
                      offset: Offset(0.0, 4.0), // how much shadow will be shown
                    ),
                  ],
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white),
            ),
            Image.asset(
              "assets/images/admin_report/dashboard_card.png",
              width: AppDimensions.screenWidth * 0.55,
            )
          ],
        ),
      ),
    );
  }

  // dashboard item
  Widget dashboardItem(String imageLink, String text,
      {required Function() onTap}) {
    return Bounceable(
      onTap: onTap,
      child: Container(
        height: ScreenUtils().screenHeight(context) * 0.17,
        width: ScreenUtils().screenWidth(context) * 0.27,
        decoration: BoxDecoration(
          color: AppColors.reportDashboardCategoryBg,
          boxShadow: [
            BoxShadow(
              color: AppColors.colorBlack.withOpacity(0.25),
              offset: const Offset(
                0.0,
                4.0,
              ),
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
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.colorBlack,
                    fontSize: 10),
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
    return Container(
      width: ScreenUtils().screenWidth(context) * 0.83,
      decoration: BoxDecoration(
        color: AppColors.overviewCardBgColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.colorBlack.withOpacity(0.25),
            offset: const Offset(
              5.0,
              5.0,
            ),
            blurRadius: 7.0,
            spreadRadius: 0.0,
          ),
          BoxShadow(
            color: AppColors.colorBlack.withOpacity(0.25),
            offset: const Offset(
              1.0,
              3.0,
            ),
            blurRadius: 3.0,
            spreadRadius: 0.0,
          ),
          BoxShadow(
            color: AppColors.white.withOpacity(0.79),
            offset: const Offset(
              -2.0,
              0.0,
            ),
            blurRadius: 4.0,
            spreadRadius: 0.0,
          ),
          BoxShadow(
            color: AppColors.white.withOpacity(0.40),
            offset: const Offset(
              2.0,
              0.0,
            ),
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
                    color: AppColors.white),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            CustomPatientPieChart(
              isSuffeled: isSuffeled,
              opdPatients: double.parse(opdPatients),
              emergencyPatients: double.parse(emergencyPatients),
              ipdPatients: double.parse(ipdPatients),
              daycarePatients: double.parse(daycarePatients),
              investigationPatients: double.parse(investigationPatients),
              dialysisPatients: double.parse(dialysisPatients),
            )
          ],
        ),
      ),
    );
  }

  Future<void> getDashboardData() async {
    setState(() {
      isLoading = true;
    });
    try {
      String token = await _pref.getUserAuthToken();
      final response = await _dio.get(
        ApiEndPoint.dashboard,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        if (response.data["status"] == true) {
          totalCollectionOpd =
              response.data["data"]["opd"]["income"].toString();
          totalPatientOpd =
              response.data["data"]["opd"]["total_patient"].toString();
          newPatientOpd =
              response.data["data"]["opd"]["new_patient"].toString();
          oldPatientOpd =
              response.data["data"]["opd"]["old_patient"].toString();

          totalCollectionIpd =
              response.data["data"]["ipd"]["income"].toString();
          totalPatientIpd =
              response.data["data"]["ipd"]["total_patient"].toString();
          newPatientIpd =
              response.data["data"]["ipd"]["new_patient"].toString();
          oldPatientIpd =
              response.data["data"]["ipd"]["old_patient"].toString();

          totalCollectionEmg =
              response.data["data"]["emergency"]["income"].toString();
          totalPatientEmg =
              response.data["data"]["emergency"]["total_patient"].toString();
          newPatientEmg =
              response.data["data"]["emergency"]["new_patient"].toString();
          oldPatientEmg =
              response.data["data"]["emergency"]["old_patient"].toString();

          totalCollectionDayCare =
              response.data["data"]["daycare"]["income"].toString();
          totalPatientDayCare =
              response.data["data"]["daycare"]["total_patient"].toString();
          newPatientDayCare =
              response.data["data"]["daycare"]["new_patient"].toString();
          oldPatientDayCare =
              response.data["data"]["daycare"]["old_patient"].toString();

          totalCollectionInvestigation =
              response.data["data"]["investigation"]["income"].toString();
          totalPatientInvestigation = response.data["data"]["investigation"]
                  ["total_patient"]
              .toString();
          newPatientInvestigation =
              response.data["data"]["investigation"]["new_patient"].toString();
          oldPatientInvestigation =
              response.data["data"]["investigation"]["old_patient"].toString();

          totalCollectionDialysis =
              response.data["data"]["dialysis"]["income"].toString();
          totalPatientDialysis =
              response.data["data"]["dialysis"]["total_patient"].toString();
          newPatientDialysis =
              response.data["data"]["dialysis"]["new_patient"].toString();
          oldPatientDialysis =
              response.data["data"]["dialysis"]["old_patient"].toString();

          newData.add(int.parse(newPatientOpd));
          newData.add(int.parse(newPatientIpd));
          newData.add(int.parse(newPatientEmg));
          newData.add(int.parse(newPatientDayCare));
          newData.add(int.parse(newPatientInvestigation));
          newData.add(int.parse(newPatientDialysis));

          oldData.add(int.parse(oldPatientOpd));
          oldData.add(int.parse(oldPatientIpd));
          oldData.add(int.parse(oldPatientEmg));
          oldData.add(int.parse(oldPatientDayCare));
          oldData.add(int.parse(oldPatientInvestigation));
          oldData.add(int.parse(oldPatientDialysis));

          setState(() {
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
          CommonUtils().flutterSnackBar(
              context: context, mes: "Api Error", messageType: 4);
        });
      }
    } on DioException catch (e) {
      if (e.response != null) {
        CommonUtils().flutterSnackBar(
            context: context, mes: "Api Error", messageType: 4);
      } else {
        CommonUtils().flutterSnackBar(
            context: context, mes: "Api Error", messageType: 4);
      }
      setState(() {
        isLoading = false;
      });
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
        // Change to your base URL
        connectTimeout: Duration(seconds: 10),
        receiveTimeout: Duration(seconds: 10),
        sendTimeout: Duration(seconds: 10),
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
          print('➡️ REQUEST[${options.method}] => PATH: ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('✅ RESPONSE[${response.statusCode}] => DATA: ${response.data}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          print('❌ ERROR[${e.response?.statusCode}] => MESSAGE: ${e.message}');
          return handler.next(e);
        },
      ),
    );
  }
}
