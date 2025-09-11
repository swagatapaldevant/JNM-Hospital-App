import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:jnm_hospital_app/core/services/routeGenerator/route_generator.dart';
import 'package:jnm_hospital_app/core/utils/helper/common_utils.dart';
import 'package:jnm_hospital_app/features/approval_system_module/model/approval_system_model.dart';

enum DiscountMode { flat, percent }

class ApprovalCard extends StatefulWidget {
  final ApprovalSystemModel approvalData;
  final Function(int) onApprove;
  final bool? isApproved;
  // Optional: expose this to persist discount in your flow.
  final void Function(
      {required DiscountMode mode,
      required double inputValue, // raw value user typed (₹ or %)
      required double discountAmount, // computed ₹
      required double grandTotal,
      String? reason})? onDiscountChanged;

  const ApprovalCard({
    super.key,
    required this.approvalData,
    required this.onApprove,
    this.isApproved,
    this.onDiscountChanged,
  });

  @override
  State<ApprovalCard> createState() => _ApprovalCardState();
}

class _ApprovalCardState extends State<ApprovalCard> {
  bool _expanded = false;

  // ---- Discount editor state ----
  bool _editingDiscount = false;
  late DiscountMode _discountMode;
  late TextEditingController _discountCtrl;

// NEW:
  late TextEditingController _discountReasonCtrl;
  late double _initialDiscountAmount; // from API, in ₹
  String? _discountError; // input validation error
  String? _reasonError; // reason validation error

  @override
  void initState() {
    super.initState();

    final total = (widget.approvalData.total ?? 0).toDouble();
    final discountAmt = (widget.approvalData.discount ?? 0).toDouble();

    _initialDiscountAmount = discountAmt;

    // infer mode from API
    _discountMode = _parseDiscountMode(widget.approvalData.discountType);

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
  double get _baseTotal => (widget.approvalData.total ?? 0).toDouble();
  double get _paid => (widget.approvalData.totalPayment ?? 0).toDouble();

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

  bool get _discountChanged =>
      (_discountAmount - _initialDiscountAmount).abs() > 0.009;

  bool _validateDiscountEdit() {
    _discountError = null;
    _reasonError = null;

    if (_discountChanged) {
      // Discount value must be provided when edited
      if (_discountCtrl.text.trim().isEmpty) {
        _discountError = "Enter a discount value";
      }
      // Reason mandatory when edited
      if (_discountReasonCtrl.text.trim().isEmpty) {
        _reasonError = "Reason is required when discount is changed";
      }
    }
    setState(() {}); // refresh errorText
    return _discountError == null && _reasonError == null;
  }

  void _notifyDiscountChange() {
    widget.onDiscountChanged?.call(
        mode: _discountMode,
        inputValue: _inputValue,
        discountAmount: _discountAmount,
        grandTotal: _grandTotal,
        reason: _discountReasonCtrl.text);
  }

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
                    _buildBillTypeChip(approvalData.section ?? ''),
                    Text("Bill ID: ${approvalData.uid}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.white,
                        )),
                    Text(
                      " ${approvalData.billDate?.toLocal().toString().split(' ')[0] ?? ''} \n  ${extractTime12h(approvalData.billDate.toString())}",
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
              Text("Patient: ${approvalData.patientName}",
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
                              if (widget.isApproved != true)
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  tooltip: _editingDiscount
                                      ? 'Close'
                                      : 'Edit discount',
                                  onPressed: () {
                                    setState(() {
                                      _editingDiscount = !_editingDiscount;
                                    });
                                  },
                                  icon: Icon(
                                    _editingDiscount
                                        ? Icons.close_rounded
                                        : Icons.edit_outlined,
                                    size: 18,
                                    color: const Color(0xFF667eea),
                                  ),
                                ),
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

                    // ---- Inline discount editor ----
                    if (_editingDiscount) _buildDiscountEditor(context),

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
                    if(_discountReasonCtrl.text.toString() != "")
                      _buildAmountRow(
                        "Reason",
                        _discountReasonCtrl.text,
                        false,
                        isDue: true,
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
                        "By: ${approvalData.createdByName}",
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
                      if (widget.isApproved != true)
                        ElevatedButton.icon(
                          // onPressed: () => widget.onApprove(approvalData.id),
                          onPressed: () {
                            if (!_validateDiscountEdit()) {
                              CommonUtils().flutterSnackBar(
                                  context: context,
                                  mes:
                                      "Please enter the reason for changing discount",
                                  messageType: 4);
                              return;
                            }

                            widget.onApprove(approvalData.id);
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
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            RouteGenerator.kBillingDetailsScreen,
                            arguments: {
                              "id": approvalData.id.toString(),
                              "deptId": approvalData.section ?? ""
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

  Widget _buildDiscountEditor(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8, top: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Mode toggle
          Row(
            children: [
              _modeChip(
                selected: _discountMode == DiscountMode.flat,
                label: "Flat",
                onTap: () {
                  setState(() {
                    _discountMode = DiscountMode.flat;
                    // keep value; just re-evaluate math
                  });
                  _notifyDiscountChange();
                },
              ),
              const SizedBox(width: 8),
              _modeChip(
                selected: _discountMode == DiscountMode.percent,
                label: "Percentage",
                onTap: () {
                  setState(() {
                    _discountMode = DiscountMode.percent;
                    // if switching from big flat values, keep text but clamp via getter
                  });
                  _notifyDiscountChange();
                },
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Amount input
          TextField(
            controller: _discountCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
            onChanged: (_) {
              setState(() {}); // live recompute
              _notifyDiscountChange();
            },
            decoration: InputDecoration(
              isDense: true,
              prefixIcon: _discountMode == DiscountMode.flat
                  ? const Icon(Icons.currency_rupee_outlined, size: 18)
                  : const Icon(Icons.percent, size: 18),
              hintText: _discountMode == DiscountMode.flat
                  ? _discountAmount.toString()
                  : "${widget.approvalData.discount.toString()}%",
              helperText: _discountMode == DiscountMode.percent
                  ? "0–100%. Discount: ${_inr(_discountAmount)}"
                  : "Max ${_inr(_baseTotal)}. Discount: ${_inr(_discountAmount)}",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),

          const SizedBox(height: 14),
          if(_discountChanged)
            TextField(
              controller: _discountReasonCtrl,
              maxLength: 160,
              onChanged: (_) {
                _validateDiscountEdit();
                _notifyDiscountChange();
              },
              decoration: InputDecoration(
                isDense: true,
                prefixIcon: const Icon(Icons.note_alt_outlined, size: 18),
                labelText: "Reason for discount",
                hintText: "e.g. Loyalty, package adjustment, rounding off…",
                hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
                helperText: _discountChanged
                    ? "Required because discount was edited"
                    : "Optional (unchanged from original)",
                errorText: _reasonError,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
        ],
      ),
    );
  }

  Widget _modeChip({
    required bool selected,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF667eea) : const Color(0xFFE5E7EB),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : const Color(0xFF111827),
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

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
