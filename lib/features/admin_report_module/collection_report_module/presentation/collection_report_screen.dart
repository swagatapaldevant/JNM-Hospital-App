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
import 'package:jnm_hospital_app/core/utils/helper/screen_utils.dart';
import 'package:jnm_hospital_app/features/admin_report_module/collection_report_module/widget/collection_expandable_card.dart';
import 'package:jnm_hospital_app/features/admin_report_module/collection_report_module/widget/custom_date_picker_for_collection_module.dart';
import 'package:jnm_hospital_app/features/admin_report_module/collection_report_module/widget/department_bar_chart.dart';
import 'package:jnm_hospital_app/features/admin_report_module/common_widgets/common_header.dart';
import 'package:jnm_hospital_app/features/admin_report_module/data/admin_report_usecase.dart';

class CollectionReportScreen extends StatefulWidget {
  const CollectionReportScreen({super.key});

  @override
  State<CollectionReportScreen> createState() => _CollectionReportScreenState();
}

class _CollectionReportScreenState extends State<CollectionReportScreen> {
  final AdminReportUsecase _adminReportUsecase = getIt<AdminReportUsecase>();
  final SharedPref _pref = getIt<SharedPref>();
  bool isLoading = false;
  bool isVisible = false;
  String selectedFromDate = "";
  String selectedToDate = "";
  final ScrollController _scrollController = ScrollController();
  List<CollectionCardVM> _cards = [];
  Map<String, double> _deptTotals = {};

  @override
  void initState() {
    super.initState();

    // 1) Pre-fill both pickers with today's date (yyyy-MM-dd)
    final today = _todayYMD();
    selectedFromDate = today;
    selectedToDate = today;

    // 2) Fire the initial search after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      geCollectionReportData();
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
            headingName: 'COLLECTION REPORT',
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
                            geCollectionReportData();
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
                    SizedBox(
                        height: ScreenUtils().screenHeight(context) * 0.02),
                    if (!isLoading && _deptTotals.isNotEmpty) ...[
                      DepartmentBarChart(
                        totals: _deptTotals,
                        subtitle: (selectedFromDate.isNotEmpty &&
                                selectedToDate.isNotEmpty)
                            ? "$selectedFromDate - $selectedToDate"
                            : null,
                      ),
                      //const SizedBox(height: 12),
                    ],
                    isLoading
                        ? Center(child: CircularProgressIndicator())
                        : _cards.isEmpty
                            ? Center(
                                child: Text(
                                  "Please use proper date range",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: _cards.length,
                                itemBuilder: (BuildContext context, int i) {
                                  final vm = _cards[i];
                                  return CollectionExpandableCard(
                                    date: vm.displayDate,
                                    totalCollection: vm.totalCollection,
                                    departmentData: vm.departmentData,
                                  );
                                }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Convert the raw API list (decoded JSON) into strongly-typed and aggregated VMs.
  List<CollectionCardVM> buildCollectionCardsVM(
    List<dynamic> raw, {
    bool subtractRefundFromTotal =
        true, // set false if you want gross totals on the header
  }) {
    final List<DayCollection> days = raw
        .map((e) => DayCollection.fromJson(e as Map<String, dynamic>))
        .toList();

    return days.map((day) {
      // department wise: cash/bank/total
      final Map<String, Map<String, double>> dept = {};

      double grossDayTotal = 0.0;

      for (final p in day.payments) {
        final dep = p.section.isEmpty ? 'Unknown' : p.section;
        dept.putIfAbsent(dep, () => {"cash": 0.0, "bank": 0.0, "total": 0.0});

        if (_isCash(p.mode)) {
          dept[dep]!["cash"] = (dept[dep]!["cash"] ?? 0) + p.amount;
        } else if (_isBankLike(p.mode)) {
          dept[dep]!["bank"] = (dept[dep]!["bank"] ?? 0) + p.amount;
        }

        // total per dept = cash + bank
        dept[dep]!["total"] =
            (dept[dep]!["cash"] ?? 0) + (dept[dep]!["bank"] ?? 0);
        grossDayTotal += p.amount;
      }

      // date-level total: gross or net (after refund)
      final double dateTotal = subtractRefundFromTotal
          ? (grossDayTotal - day.refund).clamp(0, double.infinity)
          : grossDayTotal;

      return CollectionCardVM(
        displayDate: _formatDisplayDate(day.rawDate),
        totalCollection: dateTotal,
        departmentData: dept,
      );
    }).toList();
  }

  Map<String, double> _aggregateDepartmentTotals(List<CollectionCardVM> cards) {
    final Map<String, double> totals = {};
    for (final c in cards) {
      c.departmentData.forEach((dep, vals) {
        final t = (vals['total'] ?? 0).toDouble();
        totals[dep] = (totals[dep] ?? 0) + t;
      });
    }
    return totals;
  }

  Future<void> geCollectionReportData() async {
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> requestData = {
      "from_date": selectedFromDate,
      "to_date": selectedToDate
    };

    Resource resource = await _adminReportUsecase.getCollectionReportDetails(
        requestData: requestData);

    if (resource.status == STATUS.SUCCESS) {
      try {
        final List<dynamic> rawList = resource.data is String
            ? jsonDecode(resource.data as String) as List<dynamic>
            : resource.data as List<dynamic>;

        final cards = buildCollectionCardsVM(
          rawList,
          subtractRefundFromTotal:
              true, // flip to false if you want gross header totals
        );

        setState(() {
          _cards = cards;
          _deptTotals = _aggregateDepartmentTotals(cards);
          isLoading = false;
        });
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

/// ---------- MODELS ----------
class Payment {
  final String section;
  final double amount;
  final String mode;
  final DateTime dateTime;

  Payment({
    required this.section,
    required this.amount,
    required this.mode,
    required this.dateTime,
  });

  factory Payment.fromJson(Map<String, dynamic> j) {
    return Payment(
      section: (j['section'] ?? '').toString().trim(),
      amount: (j['payment_amount'] as num?)?.toDouble() ?? 0.0,
      mode: (j['payment_mode'] ?? '').toString().trim(),
      dateTime: DateTime.tryParse(j['payment_date'] ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}

class DayCollection {
  final String rawDate; // "01-08-2025"
  final double refund; // per-day refund
  final List<Payment> payments;

  DayCollection({
    required this.rawDate,
    required this.refund,
    required this.payments,
  });

  factory DayCollection.fromJson(Map<String, dynamic> j) {
    final payments = (j['payments'] as List? ?? [])
        .map((e) => Payment.fromJson(e as Map<String, dynamic>))
        .toList();

    return DayCollection(
      rawDate: (j['date'] ?? '').toString(),
      refund: (j['payment_refund'] as num?)?.toDouble() ?? 0.0,
      payments: payments,
    );
  }
}

/// ---------- AGGREGATE RESULT FOR UI ----------
class CollectionCardVM {
  final String displayDate; // e.g. "01 Aug 2025"
  final double totalCollection; // date-level total (gross or net)
  final Map<String, Map<String, double>> departmentData;

  CollectionCardVM({
    required this.displayDate,
    required this.totalCollection,
    required this.departmentData,
  });
}

/// ---------- HELPERS ----------
bool _isCash(String mode) {
  return mode.toLowerCase() == 'cash';
}

bool _isBankLike(String mode) {
  final m = mode.toLowerCase();
  if (_isCash(mode)) return false;
  return true;
}

DateTime? _parseDdmmyyyy(String ddMMyyyy) {
  try {
    final parts = ddMMyyyy.split('-');
    if (parts.length != 3) return null;
    final dd = int.parse(parts[0]);
    final mm = int.parse(parts[1]);
    final yyyy = int.parse(parts[2]);
    return DateTime(yyyy, mm, dd);
  } catch (_) {
    return null;
  }
}

String _formatDisplayDate(String raw) {
  final dt = _parseDdmmyyyy(raw);
  if (dt == null) return raw;
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  return '${dt.day.toString().padLeft(2, '0')} ${months[dt.month - 1]} ${dt.year}';
}

String formatINR(double v) {
  return '₹${v.toStringAsFixed(2)}';
}
