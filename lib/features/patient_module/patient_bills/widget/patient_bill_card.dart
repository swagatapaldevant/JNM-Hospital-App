import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/locator.dart';
import 'package:jnm_hospital_app/core/services/localStorage/shared_pref.dart';
import 'package:jnm_hospital_app/core/services/routeGenerator/route_generator.dart';
import 'package:jnm_hospital_app/features/patient_module/model/patient_bills/patient_bills_model.dart';

enum DiscountMode { flat, percent }

class PatientBillCard extends StatefulWidget {
  final PatientBillModel bill;

  // Optional: expose this to persist discount in your flow.
  final void Function(
      {required DiscountMode mode,
      required double inputValue, // raw value user typed (₹ or %)
      required double discountAmount, // computed ₹
      required double grandTotal,
      String? reason})? onDiscountChanged;

  const PatientBillCard({
    super.key,
    required this.bill,
    this.onDiscountChanged,
  });

  @override
  State<PatientBillCard> createState() => _PatientBillCardState();
}

class _PatientBillCardState extends State<PatientBillCard> {
  bool _expanded = false;

  // ---- Discount editor state ----

  late DiscountMode _discountMode;
  late TextEditingController _discountCtrl;

// NEW:
  late TextEditingController _discountReasonCtrl;

  String? patientName;

  @override
  void initState() {
    super.initState();

    final total = (widget.bill.total ?? 0).toDouble();
    final discountAmt = (widget.bill.discount ?? 0).toDouble();

    // infer mode from API
    _discountMode = _parseDiscountMode(widget.bill.discountType);

    // decide what the user should see in the input box initially
    double initialInput;
    if (_discountMode == DiscountMode.flat) {
      // show ₹ amount directly
      initialInput = discountAmt;
    } else {
      // show % value derived from amount
      initialInput = total > 0 ? (discountAmt / total) * 100.0 : 0.0;
    }

    _discountCtrl = TextEditingController(
      text: initialInput == 0 ? '' : initialInput.toStringAsFixed(2),
    );

    // If your model has a reason field, prefill here; else keep empty
    _discountReasonCtrl = TextEditingController(
      text: '', // e.g. widget.approvalData.discountReason ?? ''
    );
    loadPatientName();
  }

  loadPatientName() async {
    final SharedPref pref = getIt<SharedPref>();
    patientName = await pref.getName();
  }

  DiscountMode _parseDiscountMode(String? raw) {
    final v = (raw ?? '').trim().toLowerCase();
    if (v.isEmpty) return DiscountMode.flat;
    // Accept a variety of synonyms from API
    const percentTokens = {'percent', 'percentage', '%', 'pct', 'p'};
    const flatTokens = {'flat', 'amount', 'rs', '₹', 'f'};
    if (percentTokens.contains(v)) return DiscountMode.percent;
    if (flatTokens.contains(v)) return DiscountMode.flat;
    // Fallback (unknown value)
    return DiscountMode.flat;
  }

  @override
  void dispose() {
    _discountCtrl.dispose();
    _discountReasonCtrl.dispose();
    super.dispose();
  }

  // ---- Math helpers (live derived values) ----
  double get _baseTotal => (widget.bill.total ?? 0).toDouble();
  double get _paid => (widget.bill.totalPayment ?? 0).toDouble();

  double get _inputValue {
    final v = double.tryParse(_discountCtrl.text.trim());
    return v == null || v.isNaN ? 0 : v;
  }

  double get _discountAmount {
    if (_discountMode == DiscountMode.flat) {
      // ₹ flat (cap at base total)
      return _baseTotal == 0 ? 0 : math.min(_inputValue, _baseTotal);
    } else {
      // % percent (cap 0..100)
      final pct = _inputValue.clamp(0, 100);
      return (_baseTotal * pct) / 100.0;
    }
  }

  double get _grandTotal {
    return (_baseTotal - _discountAmount).clamp(0, double.infinity);
  }

  double get _due {
    return (_grandTotal - _paid).clamp(0, double.infinity);
  }

  String _inr(num v) => "₹${v.toStringAsFixed(2)}";

  @override
  Widget build(BuildContext context) {
    final bill = widget.bill;

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
              // ----- Header -----
              Container(
                padding: const EdgeInsets.all(8),
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
                    _buildBillTypeChip(bill.section ?? ''),
                    Text("Bill ID: ${bill.uid}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.white,
                        )),
                    Text(
                      " ${bill.billDate?.toLocal().toString().split(' ')[0] ?? ''} \n  ${extractTime12h(bill.billDate.toString())}",
                      textAlign: TextAlign.center,
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

              // ----- Patient -----
              Text("Patient: ${patientName ?? "N/A"}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFF1E293B),
                  )),

              const SizedBox(height: 12),

              // ----- Summary (Expandable) -----
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
                ),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(horizontal: 12),
                  childrenPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  title: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      Text(
                        "Bill Summary",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            if (_paid.toStringAsFixed(2) != '0.00')
                              _buildChip(
                                label: "Paid",
                                value: _inr(_paid),
                                color: Colors.green.shade100,
                                textColor: Colors.green.shade700,
                              ),
                            if (_discountAmount.toStringAsFixed(2) != '0.00')
                              _buildChip(
                                label: "Discount",
                                value: _inr(_discountAmount),
                                color: Colors.blue,
                                textColor: Colors.white,
                              ),
                            if (_due.toStringAsFixed(2) != '0.00')
                              _buildChip(
                                label: "Due",
                                value: _inr(_due),
                                color: Colors.red.shade100,
                                textColor: Colors.red.shade700,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  trailing: Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.grey.shade700,
                  ),
                  onExpansionChanged: (expanded) {
                    setState(() => _expanded = expanded);
                  },
                  children: [
                    _buildAmountRow("Total", _inr(_baseTotal), false),

                    // ---- Discount row with edit icon ----
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Discount",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF475569),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(width: 8),
                              Text(
                                _inr(_discountAmount),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const Divider(),

                    _buildAmountRow(
                      "Grand Total",
                      _inr(_grandTotal),
                      true,
                      isGrandTotal: true,
                    ),

                    const Divider(),

                    _buildAmountRow("Payment", _inr(_paid), false),

                    _buildAmountRow(
                      "Due",
                      _inr(_due),
                      false,
                      isDue: true,
                    ),
                    if (_discountReasonCtrl.text.toString() != "")
                      _buildAmountRow(
                        "Reason",
                        _discountReasonCtrl.text,
                        false,
                        isDue: true,
                      )
                    else if (bill.approvalRemark != null &&
                        bill.approvalRemark!.isNotEmpty)
                      _buildAmountRow(
                        "Reason for Discount",
                        bill.approvalRemark!,
                        false,
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // ----- Footer -----
              Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.person_outline,
                          size: 14, color: Color(0xFF64748B)),
                      const SizedBox(width: 4),
                      Text(
                        "By: ${bill.createdName}",
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            RouteGenerator.kBillingDetailsScreen,
                            arguments: {
                              "id": bill.id.toString(),
                              "deptId": bill.section ?? ""
                            },
                          );
                        },
                        icon: const Icon(Icons.receipt_long_rounded,
                            size: 16, color: Colors.white),
                        label: const Text(
                          "View Bill",
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
            ],
          ),
        ),
      ),
    );
  }

  // ---- UI helpers ----

  Widget _buildChip({
    required String label,
    required String value,
    required Color color,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        "$label: $value",
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
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
    Color startColor, endColor;
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

  String getDayNameFromDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('EEEE').format(date);
    } catch (_) {
      return "Invalid date";
    }
  }

  String extractTime12h(String dateTimeString) {
    try {
      final dt = DateTime.parse(dateTimeString).toLocal();
      return DateFormat.jm().format(dt);
    } catch (_) {
      return '';
    }
  }
}
