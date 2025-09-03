import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/status.dart';
import 'package:jnm_hospital_app/features/admin_report_module/common_widgets/searchable_dropdown.dart';
import 'package:jnm_hospital_app/features/patient_module/model/rate_enquiry/rate_enquiry_model.dart';
import 'package:jnm_hospital_app/features/patient_module/patient_details_module/ui/common_layout.dart';
import 'package:jnm_hospital_app/features/patient_module/patient_rate_enquiry/data/rate_enquiry_usecases_impl.dart';

import '../patient_details_module/ui/common_header.dart';

class RateEnquiryScreen extends StatefulWidget {
  const RateEnquiryScreen({super.key});

  @override
  State<RateEnquiryScreen> createState() => _RateEnquiryScreenState();
}

class _RateEnquiryScreenState extends State<RateEnquiryScreen> {

  List<RateEnquiryModelResponse> _rateEnquiries = [];

  final List<RateEnquiryModel> _selectedItems = [];

  // Global discount controls
  final TextEditingController _discountController = TextEditingController();
  bool _isGlobalDiscountPercent = false; // toggle between ₹ and %

  static const Color textPrimary = Colors.black87;
  static const Color accent = Color(0xFF4F46E5); // indigo
  static const Color softBg = Color(0xFFF7F8FB);

  @override
  void initState() {
    super.initState();
    getRateEnquiries();
  }

  @override
  void dispose() {
    _discountController.dispose();
    super.dispose();
  }

  void getRateEnquiries() async {
    final rateEnqueryRes = RateEnquiryUsecasesImpl();
    final resource = await rateEnqueryRes.getRateEnquiries();
    if (resource.status == STATUS.SUCCESS) {
      print("Success");
      final response = resource.data as List;
      
      for (final dept in response) {
        _rateEnquiries.add(RateEnquiryModelResponse.fromJson(dept));
      }
      setState(() {});
    } else {
      print("Failed!!");
    }
    
  }

  // ---------- totals ----------
  double get totalAmount =>
      _selectedItems.fold(0.0, (sum, item) => sum + (item.finalAmount ?? 0.0));

  double get _globalDiscountValue {
    final raw = double.tryParse(_discountController.text.trim()) ?? 0.0;
    if (_isGlobalDiscountPercent) {
      final pct = raw.clamp(0, 100);
      return (totalAmount * pct) / 100.0;
    } else {
      // flat discount cannot exceed subtotal
      return raw.clamp(0, totalAmount);
    }
  }

  double get grandTotal {
    final gt = (totalAmount - _globalDiscountValue);
    return gt < 0 ? 0 : gt;
  }

  String _(num v) => "₹${v.toStringAsFixed(0)}";

  // ---------- actions ----------
  void _addItem() {
    setState(() {
      _selectedItems.add(
        RateEnquiryModel(
          rateEnqModel: null,
          quantity: 1,
          discountPercentage: 0,
          finalAmount: 0.0,
        ),
      );
    });
  }

  void _removeItem(int index) {
    HapticFeedback.selectionClick();
    setState(() => _selectedItems.removeAt(index));
  }

  void _updateItem(int index) {
    final item = _selectedItems[index];

    if (item.rateEnqModel == null) {
      setState(() {
        _selectedItems[index] = RateEnquiryModel(
          rateEnqModel: null,
          quantity: (item.quantity ?? 1).clamp(1, 999),
          discountPercentage: (item.discountPercentage ?? 0).clamp(0, 100),
          finalAmount: 0.0,
        );
      });
      return;
    }

    final qty = (item.quantity ?? 1).clamp(1, 999);
    final discountPct = (item.discountPercentage ?? 0).clamp(0, 100);
    final base = (item.rateEnqModel!.chargeAmount * qty);
    final finalAmount = base - (base * (discountPct / 100.0));

    setState(() {
      _selectedItems[index] = RateEnquiryModel(
        rateEnqModel: item.rateEnqModel,
        quantity: qty,
        discountPercentage: discountPct.toDouble(),
        finalAmount: finalAmount,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return PatientDetailsScreenLayout(
      slivers: [
        CommonHeader(title: "Rate Enquiry"),
        // Sticky summary
        SliverPersistentHeader(
          pinned: true,
          delegate: _SummaryHeaderDelegate(
            child: _buildSummaryCard(context),
          ),
        ),

        // Form list
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index == _selectedItems.length) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 22),
                  child: _addItemButton(),
                );
              }

              final item = _selectedItems[index];
              return _buildFormItem(index, item);
            },
            childCount: _selectedItems.length + 1,
          ),
        ),

        // Submit button
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.done_all_rounded),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _selectedItems.isEmpty ? Colors.grey[300] : accent,
                  foregroundColor:
                      _selectedItems.isEmpty ? Colors.black54 : Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 3,
                ),
                onPressed: _selectedItems.isEmpty
                    ? null
                    : () {
                        // TODO: handle submit (use _selectedItems + grandTotal)
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Form submitted"),
                          ),
                        );
                      },
                label: Text(
                  "Submit • ${_(grandTotal)}",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ---------- UI pieces ----------
  Widget _roundIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkResponse(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      radius: 28,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.cyan, width: 2)),
        child: Icon(icon, color: textPrimary),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context) {
    final itemsCount = _selectedItems.length;

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 6, 12, 6),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.95),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: Colors.black12.withOpacity(.06)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top row: Items + Subtotal
          Row(
            children: [
              _miniStat(
                icon: Icons.receipt_long_rounded,
                label: "Items",
                value: "$itemsCount",
              ),
              const SizedBox(width: 10),
              _miniStat(
                icon: Icons.attach_money_rounded,
                label: "Subtotal",
                value: _(totalAmount),
              ),
              const Spacer(),
              // Discount type toggle
              _discountToggle(),
            ],
          ),
          const SizedBox(height: 10),

          // Discount input
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _discountController,
                  onChanged: (_) => setState(() {}),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d{0,2}')),
                  ],
                  decoration: InputDecoration(
                    labelText: _isGlobalDiscountPercent
                        ? "Discount (%)"
                        : "Discount (₹)",
                    prefixIcon: Icon(
                      _isGlobalDiscountPercent
                          ? Icons.percent_rounded
                          : Icons.currency_rupee_rounded,
                      size: 18,
                    ),
                    hintText: _isGlobalDiscountPercent ? "0 - 100" : "0.00",
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Grand total
              _grandTotalBox(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _discountToggle() {
    return Container(
      decoration: BoxDecoration(
        color: softBg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _segBtn(
            selected: !_isGlobalDiscountPercent,
            label: "₹",
            onTap: () {
              if (_isGlobalDiscountPercent) {
                HapticFeedback.selectionClick();
                setState(() => _isGlobalDiscountPercent = false);
              }
            },
          ),
          _segBtn(
            selected: _isGlobalDiscountPercent,
            label: "%",
            onTap: () {
              if (!_isGlobalDiscountPercent) {
                HapticFeedback.selectionClick();
                setState(() => _isGlobalDiscountPercent = true);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _segBtn({
    required bool selected,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? accent : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w700,
            letterSpacing: .2,
          ),
        ),
      ),
    );
  }

  Widget _grandTotalBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: accent.withOpacity(.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accent.withOpacity(.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Grand Total",
            style: TextStyle(
              fontSize: 12,
              color: Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, anim) =>
                FadeTransition(opacity: anim, child: child),
            child: Text(
              _(grandTotal),
              key: ValueKey(grandTotal.toStringAsFixed(0)),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniStat({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: softBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.black87),
          const SizedBox(width: 6),
          Text(
            "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: Colors.black87,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _addItemButton() {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        elevation: 0,
        backgroundColor: Colors.white,
        side: const BorderSide(color: Colors.black12),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: _addItem,
      icon: const Icon(Icons.add_circle_outline_rounded),
      label: const Text(
        "Add Rate Item",
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _buildFormItem(int index, RateEnquiryModel item) {
    final rate = item.rateEnqModel?.chargeAmount ?? 0.0;
    final qty = item.quantity ?? 1;
    final disc = item.discountPercentage ?? 0.0;
    final lineTotal = item.finalAmount ?? 0.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12.withOpacity(.10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        children: [
          // Row 1: Title + delete
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: softBg,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: Colors.black12),
                ),
                child: Text(
                  "Item ${index + 1}",
                  style: const TextStyle(
                      fontWeight: FontWeight.w800, letterSpacing: .2),
                ),
              ),
              const Spacer(),
              IconButton(
                icon:
                    const Icon(Icons.delete_forever_rounded, color: Colors.red),
                onPressed: () => _removeItem(index),
                tooltip: "Remove",
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Row 2: Service picker
          CommonSearchableDropdown<RateEnquiryModelResponse>(
            items: (filter, props) async {
              if (filter.isEmpty) return _rateEnquiries;
              return _rateEnquiries
                  .where((e) =>
                      e.chargeName.toLowerCase().contains(filter.toLowerCase()))
                  .toList();
            },
            hintText: "Charge Name",
            selectedItem: item.rateEnqModel,
            itemAsString: (e) =>
                "${e.chargeName} (₹${e.chargeAmount.toStringAsFixed(2)})",
            compareFn: (a, b) => a.id == b.id,
            onChanged: (val) {
              HapticFeedback.selectionClick();
              _selectedItems[index].rateEnqModel = val;
              _updateItem(index);
            },
          ),
          const SizedBox(height: 12),

          // Row 3: Rate pill + Quantity stepper
          Row(
            children: [
              _pill(
                label: "Rate",
                child: Text(
                  "₹${rate.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _qtyStepper(
                  qty: qty,
                  onDec: () {
                    if (qty > 1) {
                      _selectedItems[index].quantity = qty - 1;
                      _updateItem(index);
                    }
                  },
                  onInc: () {
                    _selectedItems[index].quantity = qty + 1;
                    _updateItem(index);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Row 4: Discount% + Final amount
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  key: ValueKey('discount_${index}'),
                  initialValue: disc.toStringAsFixed(0),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: false),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    labelText: "Discount (%)",
                    prefixIcon: const Icon(Icons.percent_rounded, size: 18),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  style: const TextStyle(fontSize: 14),
                  onChanged: (val) {
                    _selectedItems[index].discountPercentage =
                        double.tryParse(val) ?? 0;
                    _updateItem(index);
                  },
                ),
              ),
              const SizedBox(width: 12),
              _pill(
                label: "Final Amount",
                alignEnd: true,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (c, a) =>
                      FadeTransition(opacity: a, child: c),
                  child: Text(
                    "₹${lineTotal.toStringAsFixed(2)}",
                    key: ValueKey(lineTotal.toStringAsFixed(2)),
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _qtyStepper({
    required int qty,
    required VoidCallback onDec,
    required VoidCallback onInc,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: softBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          _circleIcon(
            icon: Icons.remove_rounded,
            onTap: onDec,
          ),
          Expanded(
            child: Center(
              child: Text(
                "$qty",
                style:
                    const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
              ),
            ),
          ),
          _circleIcon(
            icon: Icons.add_rounded,
            onTap: onInc,
          ),
        ],
      ),
    );
  }

  Widget _circleIcon({required IconData icon, required VoidCallback onTap}) {
    return InkResponse(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      radius: 22,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.06),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Icon(icon, color: textPrimary),
      ),
    );
  }

  Widget _pill({
    required String label,
    required Widget child,
    bool alignEnd = false,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12),
        ),
        child: Column(
          crossAxisAlignment:
              alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            child,
          ],
        ),
      ),
    );
  }
}

class _SummaryHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _SummaryHeaderDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // Keep the card neatly pinned with a soft backdrop
    return Container(
      color:
          _RateEnquiryScreenState.softBg.withOpacity(overlapsContent ? 1 : 0),
      padding: const EdgeInsets.only(bottom: 6),
      child: SizedBox.expand(
        child: Align(
          alignment: Alignment.topCenter,
          child: child,
        ),
      ),
    );
  }

  @override
  double get maxExtent => 190;

  @override
  double get minExtent => 190;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
