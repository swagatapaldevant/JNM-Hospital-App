import 'package:flutter/material.dart';
import 'package:jnm_hospital_app/features/approval_system_module/model/approval_system_model.dart';

class ApprovalCard extends StatefulWidget {
  final ApprovalSystemModel approvalData;

  const ApprovalCard({super.key, required this.approvalData});

  @override
  State<ApprovalCard> createState() => _ApprovalCardState();
}

class _ApprovalCardState extends State<ApprovalCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final approvalData = widget.approvalData;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFFFFF), Color(0xFFF8FAFC)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667eea).withOpacity(0.12),
            blurRadius: 15,
            offset: const Offset(0, 6),
            spreadRadius: -3,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildBillTypeChip(approvalData.section ?? ''),
                    Text("Bill Id: ${approvalData.id}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Color.fromARGB(255, 255, 255, 255),
                        )),
                    Text(
                      approvalData.billDate
                              ?.toLocal()
                              .toString()
                              .split(' ')[0] ??
                          '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Bill Information
              // _buildInfoSection(
              //   icon: Icons.receipt_outlined,
              //   title: "Bill ID: ${approvalData.id}",
              //   subtitle: "Patient: ${approvalData.patientName}",
              // ),
              Text("Patient: ${approvalData.patientName}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFF1E293B),
                  )),

              const SizedBox(height: 12),

              // Amount Section (Expandable)
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
                ),
                child: ExpansionTile(
                  tilePadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  childrenPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  title: Text(
                    "Bill Summary",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  trailing: Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.grey.shade700,
                  ),
                  onExpansionChanged: (expanded) {
                    setState(() {
                      _expanded = expanded;
                    });
                  },
                  children: [
                    _buildAmountRow("Total",
                        "₹${approvalData.total?.toStringAsFixed(2)}", false),
                    _buildAmountRow("Discount",
                        "₹${approvalData.discount?.toStringAsFixed(2)}", false),
                    Divider(),
                    _buildAmountRow(
                      "Grand Total",
                      "₹${approvalData.grandTotal?.toStringAsFixed(2)}",
                      true,
                      isGrandTotal: true,
                    ),
                    Divider(),
                    _buildAmountRow(
                        "Payment",
                        "₹${approvalData.totalPayment?.toStringAsFixed(2)}",
                        false),
                    _buildAmountRow(
                      "Due",
                      "₹${approvalData.dueAmount?.toStringAsFixed(2)}",
                      false,
                      isDue: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.person_outline,
                          size: 14, color: Color(0xFF64748B)),
                      const SizedBox(width: 4),
                      Text(
                        "By: ${approvalData.createdBy}",
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // handle approve action
                    },
                    icon: const Icon(Icons.check_circle_outline,
                        size: 16, color: Colors.white),
                    label: const Text(
                      "Approve",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF667eea),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF667eea)),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFF1E293B),
                  )),
              Text(subtitle,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12,
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAmountRow(String label, String amount, bool isBold,
      {bool isGrandTotal = false, bool isDue = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
                color: isGrandTotal
                    ? const Color(0xFF667eea)
                    : const Color(0xFF475569),
              )),
          Text(amount,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
                color: isDue
                    ? const Color(0xFFEF4444)
                    : isGrandTotal
                        ? const Color(0xFF667eea)
                        : const Color(0xFF1E293B),
              )),
        ],
      ),
    );
  }

  Widget _buildBillTypeChip(String type) {
    Color startColor;
    Color endColor;

    switch (type) {
      case "IPD":
        startColor = const Color(0xFF8B5CF6);
        endColor = const Color(0xFF7C3AED);
        break;
      case "OPD":
        startColor = const Color(0xFF06B6D4);
        endColor = const Color(0xFF0891B2);
        break;
      case "DAYCARE":
        startColor = const Color(0xFF3B82F6);
        endColor = const Color(0xFF2563EB);
        break;
      case "INVESTIGATION":
        startColor = const Color(0xFFF59E0B);
        endColor = const Color(0xFFD97706);
        break;
      default:
        startColor = const Color(0xFF6B7280);
        endColor = const Color(0xFF4B5563);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [startColor, endColor]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: startColor.withOpacity(0.25),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        type,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
      ),
    );
  }
}

// class ApprovalCard extends StatelessWidget {
//   final ApprovalSystemModel approvalData;

//   const ApprovalCard({super.key, required this.approvalData});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         gradient: const LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             Color(0xFFFFFFFF),
//             Color(0xFFF8FAFC),
//           ],
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFF667eea).withOpacity(0.12),
//             blurRadius: 12,
//             offset: const Offset(0, 6),
//             spreadRadius: -4,
//           ),
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 6,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(16),
//         child: Padding(
//           padding: const EdgeInsets.all(14), // reduced from 20
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header Row
//               Container(
//                 padding: const EdgeInsets.all(10), // reduced
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   gradient: const LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [Color(0xFF667eea), Color(0xFF764ba2)],
//                   ),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     _buildBillTypeChip(approvalData.section!),
//                     Text(
//                       "Bill ID: ${approvalData.id}",
//                       style: const TextStyle(
//                         fontWeight: FontWeight.w500,
//                         fontSize: 12, // reduced
//                         color: Colors.white,
//                       ),
//                     ),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 8, vertical: 4), // smaller
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.2),
//                         borderRadius: BorderRadius.circular(14),
//                       ),
//                       child: Text(
//                         approvalData.billDate
//                                 ?.toLocal()
//                                 .toString()
//                                 .split(' ')[0] ??
//                             '',
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 11,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 12), // reduced spacing

//               // Patient Name
//               Text(
//                 "Name: ${approvalData.patientName}",
//                 style: const TextStyle(
//                   fontWeight: FontWeight.w600,
//                   fontSize: 13, // reduced
//                   color: Color(0xFF1E293B),
//                 ),
//               ),

//               const SizedBox(height: 12),

//               // Amount Information
//               Container(
//                 padding: const EdgeInsets.all(12), // reduced
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFF1F5F9),
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
//                 ),
//                 child: Column(
//                   children: [
//                     _buildAmountRow("Total",
//                         "₹${approvalData.total?.toStringAsFixed(2)}", false),
//                     const SizedBox(height: 6),
//                     _buildAmountRow("Discount",
//                         "₹${approvalData.discount?.toStringAsFixed(2)}", false),
//                     const SizedBox(height: 6),
//                     Container(
//                       padding: const EdgeInsets.symmetric(vertical: 6),
//                       decoration: const BoxDecoration(
//                         border: Border(
//                           top: BorderSide(color: Color(0xFFE2E8F0), width: 1),
//                           bottom:
//                               BorderSide(color: Color(0xFFE2E8F0), width: 1),
//                         ),
//                       ),
//                       child: _buildAmountRow(
//                         "Grand Total",
//                         "₹${approvalData.grandTotal?.toStringAsFixed(2)}",
//                         true,
//                         isGrandTotal: true,
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     _buildAmountRow(
//                         "Payment",
//                         "₹${approvalData.totalPayment?.toStringAsFixed(2)}",
//                         false),
//                     const SizedBox(height: 6),
//                     _buildAmountRow(
//                       "Due",
//                       "₹${approvalData.dueAmount?.toStringAsFixed(2)}",
//                       false,
//                       isDue: true,
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 14),

//               // Footer
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Container(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFF1F5F9),
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const Icon(Icons.person_outline,
//                             size: 14, color: Color(0xFF64748B)),
//                         const SizedBox(width: 4),
//                         Text(
//                           "Created by: ${approvalData.createdBy}",
//                           style: const TextStyle(
//                             fontSize: 11,
//                             color: Color(0xFF64748B),
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       // handle approve action
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF667eea),
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 18, vertical: 8), // smaller button
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                     ),
//                     child: const Text(
//                       "Approve",
//                       style: TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildAmountRow(String label, String amount, bool isBold,
//       {bool isGrandTotal = false, bool isDue = false}) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 12,
//             fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
//             color: isGrandTotal
//                 ? const Color(0xFF667eea)
//                 : const Color(0xFF475569),
//           ),
//         ),
//         Text(
//           amount,
//           style: TextStyle(
//             fontSize: 12,
//             fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
//             color: isDue
//                 ? const Color(0xFFEF4444)
//                 : isGrandTotal
//                     ? const Color(0xFF667eea)
//                     : const Color(0xFF1E293B),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildBillTypeChip(String type) {
//     Color startColor;
//     Color endColor;

//     switch (type) {
//       case "IPD":
//         startColor = const Color(0xFF8B5CF6);
//         endColor = const Color(0xFF7C3AED);
//         break;
//       case "OPD":
//         startColor = const Color(0xFF06B6D4);
//         endColor = const Color(0xFF0891B2);
//         break;
//       case "DAYCARE":
//         startColor = const Color(0xFF3B82F6);
//         endColor = const Color(0xFF2563EB);
//         break;
//       case "INVESTIGATION":
//         startColor = const Color(0xFFF59E0B);
//         endColor = const Color(0xFFD97706);
//         break;
//       default:
//         startColor = const Color(0xFF6B7280);
//         endColor = const Color(0xFF4B5563);
//     }

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [startColor, endColor],
//         ),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Text(
//         type,
//         style: const TextStyle(
//           color: Colors.white,
//           fontWeight: FontWeight.w600,
//           fontSize: 11,
//         ),
//       ),
//     );
//   }
// }
