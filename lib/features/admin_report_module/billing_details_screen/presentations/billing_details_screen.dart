import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/locator.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/resource.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/status.dart';
import 'package:jnm_hospital_app/core/utils/helper/app_dimensions.dart';
import 'package:jnm_hospital_app/core/utils/helper/common_utils.dart';
import 'package:jnm_hospital_app/core/utils/helper/screen_utils.dart';
import 'package:jnm_hospital_app/features/admin_report_module/common_widgets/common_header.dart';
import 'package:jnm_hospital_app/features/admin_report_module/data/admin_report_usecase.dart';
import 'package:jnm_hospital_app/features/admin_report_module/model/billing_report/billing_details_model.dart';

class BillingDetailsScreen extends StatefulWidget {
  final Map<String, String> billIdDept;

  const BillingDetailsScreen({super.key, required this.billIdDept});

  @override
  State<BillingDetailsScreen> createState() => _BillingDetailsScreenState();
}

class _BillingDetailsScreenState extends State<BillingDetailsScreen> {
  bool isLoading = false;
  BillingDetailsModel? billingDetails;

  @override
  initState() {
    super.initState();
    print("Init state");
    getBillingDetails();
  }

  String formatDate(String? date) {
    if (date == null || date.isEmpty) return "";
    return DateFormat("dd MMM yyyy, hh:mm a").format(DateTime.parse(date));
  }

  String formatDateTimeShort(String? date) {
    if (date == null || date.isEmpty) return "";
    return DateFormat("dd/MM/yyyy, hh:mma").format(DateTime.parse(date));
  }

  String formatDateShort(String? date) {
    if (date == null || date.isEmpty) return "";
    return DateFormat("dd MMM yyyy").format(DateTime.parse(date));
  }

  Future<void> getBillingDetails() async {
    final billId = widget.billIdDept["id"];
    final deptId = widget.billIdDept["deptId"];

    setState(() {
      isLoading = true;
    });
    final AdminReportUsecase _adminReportUsecase = getIt<AdminReportUsecase>();
    Resource resource = await _adminReportUsecase.getBillingDetails(
        deptId: deptId!, billId: int.parse(billId!));

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

  @override
  Widget build(BuildContext context) {
    final bill = billingDetails?.bill;
    final billInfo = billingDetails?.billInfo;
    final payments = billingDetails?.payments ?? [];
    final patientDetails = billingDetails?.patient;
  AppDimensions.init(context);
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  CommonHeaderForReportModule(
                    headingName: "Billing Details",
                    isVisibleFilter: false,
                    isVisibleSearch: false,
                  ),
                  // Main Bill Container
                  Container(
                    //margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                     // color: Colors.white,
                     // borderRadius: BorderRadius.circular(20),
                    //   boxShadow: [
                    //     BoxShadow(
                    //       color: Colors.black.withOpacity(0.08),
                    //       blurRadius: 20,
                    //       offset: const Offset(0, 4),
                    //     ),
                    //   ],
                     ),
                    child: Padding(
                      padding:  EdgeInsets.symmetric(horizontal: AppDimensions.screenPadding),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          // Hospital Header Section
                          _buildHospitalHeader(bill),
                          SizedBox(
                            height: 8,
                          ),
                          // Patient & Bill Info Section
                          _buildPatientInfoSection(
                              patientDetails, bill?.doctorName, "Dummy dept."),
                          // Services/Items Section
                          _buildServicesSection(billInfo ?? []),
                          // Bill Summary Section
                          _buildBillSummary(bill),
                          // Receipt History Section
                          if (payments.isNotEmpty) _buildPaymentSection(payments),

                          // Footer
                          //_buildFooter(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildHospitalHeader(Bill? bill) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Background Header
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.indigo.shade700, Colors.indigo.shade500],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Bill ID
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "BILL ID",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "#${bill?.id ?? "N/A"}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              // Date
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Date & Time",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    formatDate(bill?.billDate.toString()),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Floating Section Chip
        Positioned(
          top: -14,
          left: ScreenUtils().screenWidth(context) / 2 - 50,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFF8513),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              billingDetails?.section?.toUpperCase() ?? "N/A",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _sectionWithHangingHeader({
    required Widget heading,
    required Widget body,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10,),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topLeft,
        children: [
          // Card body
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
              border: Border.all(color: Colors.grey.shade200),
            ),
            padding:
                const EdgeInsets.only(top: 28, left: 16, right: 16, bottom: 16),
            child: body,
          ),

          // Floating header
          Positioned(
            top: -12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueAccent, Colors.lightBlueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                child: heading,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String formatDoctorName(String? doc) {
    if (doc == null) return "N/A";

    if (doc.toLowerCase().startsWith("dr.")) {
      return doc;
    } else {
      return "Dr. $doc";
    }
  }
//   String  formattedDob(int? dobDay, int? dobMonth, int? dobYear) {
//   if (dobDay == null || dobMonth == null || dobYear == null) {
//     return "N/A";
//   }

//   final day = dobDay.toString().padLeft(2, '0');
//   final month = dobMonth.toString().padLeft(2, '0');
//   final year = dobYear.toString();

//   return "$day-$month-$year";
// }

String formattedDob(int? dobDay, int? dobMonth, int? dobYear) {
  if (dobDay == null || dobMonth == null || dobYear == null) {
    return "N/A";
  }

  try {
    // Handle 2-digit year conversion
    int fullYear = dobYear;
    if (dobYear < 100) {
      // If year is 2-digit, convert to 4-digit
      // Assume years 00-30 are 2000-2030, and 31-99 are 1931-1999
      if (dobYear <= 30) {
        fullYear = 2000 + dobYear;
      } else {
        fullYear = 1900 + dobYear;
      }
    }
    
    // Validate year range (reasonable birth year range)
    if (fullYear < 1900 || fullYear > DateTime.now().year) {
      return "N/A";
    }

    // Validate month and day ranges
    if (dobMonth < 1 || dobMonth > 12) return "N/A";
    if (dobDay < 1 || dobDay > 31) return "N/A";

    final dob = DateTime(fullYear, dobMonth, dobDay);
    final today = DateTime.now();

    // Prevent invalid future DOBs
    if (dob.isAfter(today)) return "N/A";

    // Calculate age
    int age = today.year - dob.year;
    if (today.month < dob.month ||
        (today.month == dob.month && today.day < dob.day)) {
      age--;
    }

    final day = dob.day.toString().padLeft(2, '0');
    final month = dob.month.toString().padLeft(2, '0');
    final year = dob.year.toString();

    return "$day-$month-$year (${age}YRS)";
  } catch (e) {
    print('Error formatting DOB: $e'); // Debug print
    return "N/A";
  }
}

Widget _buildPatientInfoSection(
      Patient? patientDetails, String? doctor, String? department) {
    return _sectionWithHangingHeader(
      heading: Row(
        children: [
          const Icon(Icons.person_outline, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          const Text(
            "Patient Information",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoItem(
            '${patientDetails?.name ?? "N/A"} (${patientDetails?.id ?? "N/A"})',
            Icons.person_outline,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildInfoItem(
                  formattedDob(patientDetails?.dobDay,
                      patientDetails?.dobMonth, patientDetails?.dobYear),
                  Icons.child_care,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildInfoItem(
                  patientDetails?.phone ?? "N/A",
                  Icons.call,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          _buildInfoItem(
            patientDetails?.address ?? "N/A",
            Icons.home_outlined,
          ),
          const SizedBox(height: 4),
          _buildInfoItem(
            '${formatDoctorName(doctor)} (${department ?? "N/A"})',
            Icons.medical_services_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String value, IconData icon, {Color? statusColor}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: statusColor ?? Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'paid':
        return Colors.green[600]!;
      case 'pending':
        return Colors.orange[600]!;
      case 'overdue':
        return Colors.red[600]!;
      default:
        return Colors.black87;
    }
  }

  Widget _buildServicesSection(List<BillInfo> billInfo) {
    return _sectionWithHangingHeader(
      heading: Row(
        children: [
          Icon(Icons.receipt_long_outlined, color: Colors.white, size: 18),
          const SizedBox(width: 4),
          const Text(
            "Services & Charges",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              children: [
                // Items - No header needed since we're using a different layout
                ...billInfo.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  final isLast = index == billInfo.length - 1;

                  return Container(
                    decoration: BoxDecoration(
                      border: isLast
                          ? null
                          : Border(
                              bottom: BorderSide(color: Colors.grey[200]!)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Service name row (full width)
                        Container(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 2),
                          width: double.infinity,
                          child: Text(
                            item.chargeName ?? "",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        // Date and Amount row (two columns)
                        Container(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Text(
                                    //   "Date",
                                    //   style: TextStyle(
                                    //     fontSize: 11,
                                    //     fontWeight: FontWeight.w500,
                                    //     color: Colors.grey[600],
                                    //   ),
                                    // ),
                                    const SizedBox(height: 2),
                                    Text(
                                      formatDateShort(item.date.toString()),
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    // Text(
                                    //   "Amount",
                                    //   style: TextStyle(
                                    //     fontSize: 11,
                                    //     fontWeight: FontWeight.w500,
                                    //     color: Colors.grey[600],
                                    //   ),
                                    // ),
                                    const SizedBox(height: 2),
                                    Text(
                                      "₹${item.amount}",
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildPaymentSection(List<dynamic> payments) {
  //   return _sectionWithHangingHeader(
  //     heading: Row(
  //       children: [
  //         Icon(Icons.payment_outlined, color: Colors.white, size: 18),
  //         const SizedBox(width: 4),
  //         const Text(
  //           "Receipt List",
  //           style: TextStyle(
  //             fontSize: 12,
  //             fontWeight: FontWeight.w600,
  //             color: Colors.white,
  //           ),
  //         ),
  //       ],
  //     ),
  //     body: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Column(
  //           children: payments.map((payment) {
  //             return Container(
  //               padding: const EdgeInsets.fromLTRB(16, 4, 16, 6),
  //               child: Row(
  //                 children: [
  //                   Icon(Icons.check_circle_outline,
  //                       color: Colors.green[700], size: 16),
  //                   const SizedBox(width: 4),
  //                   Expanded(
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             Text(
  //                               "₹${payment.paymentAmount}",
  //                               style: TextStyle(
  //                                 fontSize: 12,
  //                                 fontWeight: FontWeight.bold,
  //                                 color: Colors.green[700],
  //                               ),
  //                             ),
  //                             Container(
  //                               padding: const EdgeInsets.symmetric(
  //                                   horizontal: 8, vertical: 2),
  //                               decoration: BoxDecoration(
  //                                 color: Colors.green[100],
  //                                 borderRadius: BorderRadius.circular(8),
  //                               ),
  //                               child: Text(
  //                                 payment.paymentMode ?? "",
  //                                 style: TextStyle(
  //                                   fontSize: 11,
  //                                   fontWeight: FontWeight.w500,
  //                                   color: Colors.green[700],
  //                                 ),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                         Text(
  //                           "${payment.createdName} • ${formatDate(payment.paymentDate.toString())}",
  //                           style: TextStyle(
  //                             fontSize: 11,
  //                             color: Colors.grey[600],
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             );
  //           }).toList(),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  Widget _buildPaymentSection(List<dynamic> payments) {
    return _sectionWithHangingHeader(
      heading: Row(
        children: [
          Icon(Icons.payment_outlined, color: Colors.white, size: 18),
          const SizedBox(width: 4),
          const Text(
            "Receipt List",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Column(
        children: payments.map((payment) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // First line: Name + Date
                Row(
                  children: [
                    Icon(Icons.check_circle_outline,
                        color: Colors.green[700], size: 16),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        "${payment.createdName}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    Text(
                      formatDate(payment.paymentDate.toString()),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Second line: Amount + Mode (right aligned)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "₹${payment.paymentAmount}",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        payment.paymentMode ?? "",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Colors.green[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBillSummary(Bill? bill) {
    return _sectionWithHangingHeader(
      heading: Row(
        children: [
          const Icon(Icons.receipt_outlined, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          const Text(
            "Bill Summary",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            if ((bill?.miscellaneousAmount ?? 0) > 0) ...[
              _buildSummaryRow("Total", bill?.subTotal,
                  isBold: true, fontSize: 13),
              _buildSummaryRow("Miscellaneous", bill?.miscellaneousAmount,
                  isBold: true, fontSize: 13),
            ] else
              _buildSummaryRow("Total", bill?.total,
                  isBold: true, fontSize: 13),
            const Divider(thickness: 1),
            _buildSummaryRow("Net Amount", bill?.total,
                isBold: true, fontSize: 13),
            if ((bill?.discountAmount ?? 0) > 0)
              _buildSummaryRow("Discount", bill?.discountAmount,
                  isBold: true, fontSize: 13),
            _buildSummaryRow("Total Payable Amount", bill?.grandTotal,
                isBold: true, fontSize: 14),
            _buildSummaryRow("Total Paid Amount", bill?.totalPayment,
                isBold: true, fontSize: 13),
            if ((bill?.refundAmount ?? 0) > 0)
              _buildSummaryRow("Refund Amount", bill?.refundAmount,
                  color: Colors.green[700], isBold: true, fontSize: 13),
            if ((bill?.dueAmount ?? 0) > 0)
              _buildSummaryRow("Due Amount", bill?.dueAmount,
                  color: Colors.red[700], isBold: true, fontSize: 13),
            if ((bill?.craditAmount ?? 0) > 0)
              _buildSummaryRow("Credit Amount", bill?.craditAmount,
                  color: const Color.fromARGB(255, 53, 253, 46),
                  isBold: true,
                  fontSize: 13),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, dynamic value,
      {bool isBold = false, Color? color, double fontSize = 12}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isBold ? FontWeight.w500 : FontWeight.w400,
              color: const Color.fromARGB(221, 34, 34, 34),
            ),
          ),
          Text(
            "₹${value ?? '0'}",
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: color ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          const Divider(),
          const SizedBox(height: 8),
          Text(
            "Thank you for choosing JNM Hospital",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Your health is our priority",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color bgColor;
  final Color color;
  const _Chip(
      {required this.label, required this.bgColor, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          letterSpacing: .6,
          color: color,
          height: 1.0,
        ),
      ),
    );
  }
}
