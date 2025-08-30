// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:jnm_hospital_app/features/admin_report_module/common_widgets/common_header.dart';
// import 'package:jnm_hospital_app/features/admin_report_module/model/billing_report/billing_details_model.dart';

// class BillingDetailsScreen extends StatelessWidget {
//   final BillingDetailsModel billingDetails;

//   const BillingDetailsScreen({super.key, required this.billingDetails});

//   String formatDate(String? date) {
//     if (date == null || date.isEmpty) return "";
//     return DateFormat("dd MMM yyyy, hh:mm a").format(DateTime.parse(date));
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bill = billingDetails.bill;
//     final billInfo = billingDetails.billInfo;
//     final payments = billingDetails.payments;

//     return Scaffold(
//       body: SingleChildScrollView(

//         //padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             CommonHeaderForReportModule(headingName: "Billing Details"),
//             Card(
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//               elevation: 4,
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Header
//                     Center(
//                       child: Column(
//                         children: [
//                           const Text(
//                             "🏥 JNM Hospital",
//                             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             "Bill ID: #${bill?.id}   |   ${formatDate(bill?.billDate.toString())}",
//                             style: const TextStyle(fontSize: 14),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const Divider(height: 30, thickness: 1),

//                     // Patient & Doctor Info
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         _infoTile("Patient ID", "${bill?.patientId}"),
//                         _infoTile("Doctor", bill?.doctorName ?? "N/A"),
//                       ],
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         _infoTile("Created By", bill?.createdName ?? ""),
//                         _infoTile("Status", bill?.status ?? ""),
//                       ],
//                     ),

//                     const Divider(height: 30, thickness: 1),

//                     // Bill Items
//                     const Text(
//                       "Bill Items",
//                       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 8),
//                     Table(
//                       border: TableBorder.all(color: Colors.grey.shade300),
//                       columnWidths: const {
//                         0: FlexColumnWidth(3),
//                         1: FlexColumnWidth(1),
//                         2: FlexColumnWidth(2),
//                       },
//                       children: [
//                         TableRow(
//                           decoration: BoxDecoration(color: Colors.grey.shade200),
//                           children:  [
//                             _tableHeader("Item"),
//                             _tableHeader("Qty"),
//                             _tableHeader("Amount"),
//                           ],
//                         ),
//                         ...billInfo.map((item) {
//                           return TableRow(
//                             children: [
//                               _tableCell(item.chargeName ?? ""),
//                               _tableCell("${item.qty}"),
//                               _tableCell("₹${item.amount}"),
//                             ],
//                           );
//                         }),
//                       ],
//                     ),

//                     const SizedBox(height: 20),

//                     // Payments
//                     if (payments.isNotEmpty) ...[
//                       const Text(
//                         "Payments",
//                         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 8),
//                       Column(
//                         children: payments.map((p) {
//                           return ListTile(
//                             dense: true,
//                             contentPadding: EdgeInsets.zero,
//                             leading: const Icon(Icons.payments, color: Colors.green),
//                             title: Text("₹${p.paymentAmount} - ${p.paymentMode}"),
//                             subtitle: Text("By ${p.createdName} on ${formatDate(p.paymentDate.toString())}"),
//                           );
//                         }).toList(),
//                       ),
//                       const Divider(height: 30, thickness: 1),
//                     ],

//                     // Totals
//                     Align(
//                       alignment: Alignment.centerRight,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           _totalRow("Subtotal", bill?.subTotal),
//                           _totalRow("Discount", bill?.discountAmount),
//                           _totalRow("Miscellaneous", bill?.miscellaneousAmount),
//                           const Divider(),
//                           _totalRow("Grand Total", bill?.grandTotal, isBold: true),
//                           _totalRow("Paid", bill?.totalPayment, isBold: true),
//                           _totalRow("Due", bill?.dueAmount, isBold: true, color: Colors.red),
//                         ],
//                       ),
//                     ),

//                     const SizedBox(height: 20),

//                     // Footer
//                     Center(
//                       child: Text(
//                         "Thank you for visiting!",
//                         style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey.shade700),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _infoTile(String label, String value) {
//     return Expanded(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
//           Text(value, style: const TextStyle(fontSize: 14)),
//         ],
//       ),
//     );
//   }

//   static Widget _tableHeader(String text) {
//     return Padding(
//       padding: EdgeInsets.all(8.0),
//       child: Text(
//         text,
//         style: const TextStyle(fontWeight: FontWeight.bold),
//         textAlign: TextAlign.center,
//       ),
//     );
//   }

//   static Widget _tableCell(String text) {
//     return Padding(
//       padding: EdgeInsets.all(8.0),
//       child: Text(text, textAlign: TextAlign.center),
//     );
//   }

//   Widget _totalRow(String label, dynamic value, {bool isBold = false, Color? color}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 2),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             "$label: ",
//             style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
//           ),
//           Text(
//             "₹$value",
//             style: TextStyle(
//               fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
//               color: color,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jnm_hospital_app/features/admin_report_module/common_widgets/common_header.dart';
import 'package:jnm_hospital_app/features/admin_report_module/model/billing_report/billing_details_model.dart';

class BillingDetailsScreen extends StatelessWidget {
  final BillingDetailsModel billingDetails;

  const BillingDetailsScreen({super.key, required this.billingDetails});

  String formatDate(String? date) {
    if (date == null || date.isEmpty) return "";
    return DateFormat("dd MMM yyyy, hh:mm a").format(DateTime.parse(date));
  }

  String formatDateShort(String? date) {
    if (date == null || date.isEmpty) return "";
    return DateFormat("dd MMM yyyy").format(DateTime.parse(date));
  }

  @override
  Widget build(BuildContext context) {
    final bill = billingDetails.bill;
    final billInfo = billingDetails.billInfo;
    final payments = billingDetails.payments;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          children: [
            CommonHeaderForReportModule(headingName: "Billing Details"),
            // Main Bill Container
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Hospital Header Section
                  _buildHospitalHeader(bill),

                  // Patient & Bill Info Section
                  _buildPatientInfoSection(bill),

                  // Services/Items Section
                  _buildServicesSection(billInfo),                 

                  // Bill Summary Section
                  _buildBillSummary(bill),

                  // Receipt History Section
                  if (payments.isNotEmpty) _buildPaymentSection(payments),

                  // Footer
                  _buildFooter(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHospitalHeader(Bill? bill) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[700]!, Colors.blue[600]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "BILL ID",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "#${bill?.id}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                _Chip(label: billingDetails.section!, 
                bgColor: const Color.fromARGB(255, 255, 133, 19)!, color: Colors.white),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "DATE",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatDateShort(bill?.billDate.toString()),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  

  Widget _buildPatientInfoSection(Bill? bill) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person_outline, color: Colors.grey[600], size: 20),
              const SizedBox(width: 8),
              const Text(
                "Patient Information",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              children: [
              
                _buildInfoItem(
                    "Name",
                    '${bill?.createdName}(${bill?.patientId})',
                    Icons.person_outline),
                  SizedBox(height: 4,),
                _buildInfoItem("Doctor", bill?.doctorName ?? "N/A",
                    Icons.medical_services_outlined),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon,
      {Color? statusColor}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.receipt_long_outlined,
                  color: Colors.grey[600], size: 20),
              const SizedBox(width: 8),
              const Text(
                "Services & Charges",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Expanded(
                          flex: 3,
                          child: Text("Ser",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 12))),
                      Expanded(
                          flex: 1,
                          child: Text("Date",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 12),
                              textAlign: TextAlign.center)),
                      Expanded(
                          flex: 2,
                          child: Text("Amt",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 12),
                              textAlign: TextAlign.right)),
                    ],
                  ),
                ),
                // Items
                ...billInfo.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  final isLast = index == billInfo.length - 1;

                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: isLast
                          ? null
                          : Border(
                              bottom: BorderSide(color: Colors.grey[200]!)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            item.chargeName ?? "",
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "${item.date}",
                            style: const TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "₹${item.amount}",
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.right,
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

  Widget _buildPaymentSection(List<dynamic> payments) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.payment_outlined, color: Colors.grey[600], size: 20),
              const SizedBox(width: 8),
              const Text(
                "Receipt List",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green[200]!),
            ),
            child: Column(
              children: payments.map((payment) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.check_circle_outline,
                            color: Colors.green[700], size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "₹${payment.paymentAmount}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green[700],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.green[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    payment.paymentMode ?? "",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.green[700],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Received by ${payment.createdName} • ${formatDate(payment.paymentDate.toString())}",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillSummary(Bill? bill) {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey[50]!, Colors.grey[100]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.receipt_outlined, color: Colors.grey[600], size: 20),
              const SizedBox(width: 8),
              const Text(
                "Bill Summary",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSummaryRow("Subtotal", bill?.subTotal),
          if(bill?.miscellaneousAmount != null)
            _buildSummaryRow("Miscellaneous", bill?.miscellaneousAmount),
          if(bill?.discountAmount != null)
             _buildSummaryRow("Discount", bill?.discountAmount),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(thickness: 1),
          ),

          _buildSummaryRow("Payable", bill?.grandTotal,
              isBold: true, fontSize: 16),
          _buildSummaryRow("Total", bill?.totalPayment,
              color: Colors.green[600], isBold: true),
          if(bill?.dueAmount != null)
            _buildSummaryRow("Due Amount", bill?.dueAmount,
              color: Colors.red[600], isBold: true),
          if(bill?.craditAmount != null)
            _buildSummaryRow("Credit Amount", bill?.craditAmount,
              color: Colors.blue[600], isBold: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, dynamic value,
      {bool isBold = false, Color? color, double fontSize = 14}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
              color: Colors.black87,
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
