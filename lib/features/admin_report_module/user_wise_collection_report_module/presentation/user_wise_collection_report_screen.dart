import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/locator.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/resource.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/status.dart';
import 'package:jnm_hospital_app/core/services/localStorage/shared_pref.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/app_dimensions.dart';
import 'package:jnm_hospital_app/core/utils/helper/common_utils.dart';
import 'package:jnm_hospital_app/features/admin_report_module/collection_report_module/widget/custom_date_picker_for_collection_module.dart';
import 'package:jnm_hospital_app/features/admin_report_module/common_widgets/common_header.dart';
import 'package:jnm_hospital_app/features/admin_report_module/data/admin_report_usecase.dart';

class UserWiseCollectionReportScreen extends StatefulWidget {
  const UserWiseCollectionReportScreen({super.key});

  @override
  State<UserWiseCollectionReportScreen> createState() => _UserWiseCollectionReportScreenState();
}

class _UserWiseCollectionReportScreenState extends State<UserWiseCollectionReportScreen> {

  final AdminReportUsecase _adminReportUsecase = getIt<AdminReportUsecase>();
  final SharedPref _pref = getIt<SharedPref>();
  bool isLoading = false;
  bool isVisible = false;
  String selectedFromDate = "";
  String selectedToDate = "";
  final ScrollController _scrollController = ScrollController();
  // List<CollectionCardVM> _cards = [];
  // Map<String, double> _deptTotals = {};


  @override
  void initState() {
    super.initState();

    // 1) Pre-fill both pickers with today's date (yyyy-MM-dd)
    final today = _todayYMD();
    selectedFromDate = today;
    selectedToDate = today;

    // 2) Fire the initial search after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUserWiseCollectionReportData();
    });
  }

  /// Helper: today's date as yyyy-MM-dd
  String _todayYMD() {
    final now = DateTime.now();
    final y = now.year.toString().padLeft(4, '0');
    final m = now.month.toString().padLeft(2, '0');
    final d = now.day.toString().padLeft(2, '0');
    return "$y-$m-$d";
  }





  @override
  Widget build(BuildContext context) {
    AppDimensions.init(context);
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      body: Column(
        children: [
          CommonHeaderForReportModule(
            headingName: 'USER WISE COLLECTION REPORT',
            onSearchTap: () {
              setState(() {
                isVisible = true;
              });
            },
            isVisibleFilter: false,
            isVisibleSearch: false,
            filterTap: () {},
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.screenPadding),
                child: Column(
                  children: [
                    SizedBox(height: AppDimensions.contentGap3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomDatePickerFieldForCollectionModule(
                            selectedDate: selectedFromDate,
                            disallowFutureDates: true,
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
                          child: CustomDatePickerFieldForCollectionModule(
                            selectedDate: selectedToDate,
                            disallowFutureDates: true,
                            onDateChanged: (String value) {
                              setState(() {
                                selectedToDate = value;
                              });
                            },
                            placeholderText: 'To date',
                          ),
                        ),
                        SizedBox(width: 10),
                        Bounceable(
                          onTap: () {
                            //geCollectionReportData();
                          },
                          child: Container(
                              padding: EdgeInsets.all(9),
                              decoration: BoxDecoration(
                                color: AppColors.arrowBackground,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 0,
                                    spreadRadius: 1,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.search,
                                color: Colors.white,
                                size: 30,
                              )),
                        )
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


  Future<void> getUserWiseCollectionReportData() async {
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> requestData = {
      "from_date": selectedFromDate,
      "to_date": selectedToDate
    };

    Resource resource = await _adminReportUsecase.getUserWiseCollectionReportDetails(
        requestData: requestData);

    if (resource.status == STATUS.SUCCESS) {
      try {
        // final List<dynamic> rawList = resource.data is String
        //     ? jsonDecode(resource.data as String) as List<dynamic>
        //     : resource.data as List<dynamic>;
        //
        // final cards = buildCollectionCardsVM(
        //   rawList,
        //   subtractRefundFromTotal:
        //   true, // flip to false if you want gross header totals
        // );

        // setState(() {
        //   _cards = cards;
        //   _deptTotals = _aggregateDepartmentTotals(cards);
        //   isLoading = false;
        // });
      } catch (e) {
        setState(() => isLoading = false);
        CommonUtils().flutterSnackBar(
          context: context,
          mes: "Failed to parse response: $e",
          messageType: 4,
        );
      }
    } else {
      setState(() {
        isLoading = false;
      });
      CommonUtils().flutterSnackBar(
          context: context, mes: resource.message ?? "", messageType: 4);
    }
  }



}
