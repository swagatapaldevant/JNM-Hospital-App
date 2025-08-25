

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jnm_hospital_app/features/admin_report_module/common_widgets/searchable_dropdown.dart';
import 'package:jnm_hospital_app/features/patient_module/model/rate_enquiry/rate_enquiry_model.dart';
import 'package:jnm_hospital_app/features/patient_module/patient_details_module/ui/common_layout.dart';

class RateEnquiryScreen extends StatefulWidget {
  const RateEnquiryScreen({super.key});

  @override
  State<RateEnquiryScreen> createState() => _RateEnquiryScreenState();
}

class _RateEnquiryScreenState extends State<RateEnquiryScreen> {
  List<RateEnquiryModelResponse> _rateEnquiries = [];
  final List<RateEnquiryModel> _selectedItems = [];

  final TextEditingController _discountController = TextEditingController();

  double get totalAmount =>
      _selectedItems.fold(0.0, (sum, item) => sum + (item.finalAmount ?? 0.0));

  double get grandTotal {
    final discount = double.tryParse(_discountController.text) ?? 0.0;
    return totalAmount - discount;
  }

  @override
  void initState() {
    super.initState();
    getRateEnquiries();
  }

  void getRateEnquiries() {
    // TODO: Replace with API
    _rateEnquiries = [
      RateEnquiryModelResponse(id: "1", name: "Service A", rate: 100.0),
      RateEnquiryModelResponse(id: "2", name: "Service B", rate: 200.0),
      RateEnquiryModelResponse(id: "3", name: "Service C", rate: 300.0),
    ];
  }

  void _addItem() {
    setState(() {
      _selectedItems.add(
        RateEnquiryModel(
          rateEnqModel: null, // No default selection
          quantity: 1,
          discountPercentage: 0,
          finalAmount: 0.0, // Start with 0 amount
        ),
      );
    });
  }

  void _removeItem(int index) {
    setState(() => _selectedItems.removeAt(index));
  }

  void _updateItem(int index) {
    final item = _selectedItems[index];
    
    // Only update if a service is selected
    if (item.rateEnqModel == null) {
      setState(() {
        _selectedItems[index] = RateEnquiryModel(
          rateEnqModel: null,
          quantity: item.quantity ?? 1,
          discountPercentage: item.discountPercentage ?? 0,
          finalAmount: 0.0,
        );
      });
      return;
    }
    
    final qty = item.quantity ?? 1;
    final discount = item.discountPercentage ?? 0;
    final discountAmount = (item.rateEnqModel!.rate * qty) * (discount / 100);
    final finalAmount = (item.rateEnqModel!.rate * qty) - discountAmount;

    setState(() {
      _selectedItems[index] = RateEnquiryModel(
        rateEnqModel: item.rateEnqModel,
        quantity: qty,
        discountPercentage: discount,
        finalAmount: finalAmount,
      );
    });
  }

  static const Color textPrimary = Colors.black87;

  @override
  Widget build(BuildContext context) {
    return PatientDetailsScreenLayout(
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Row(
              children: [
                _roundIconButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => Navigator.pop(context)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Rate Enquiry",
                    style: TextStyle(
                      color: textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.2,
                    ),
                    overflow: TextOverflow.ellipsis, // Prevent overflow
                  ),
                ),
              ],
            ),
          ),
        ),
        // sticky summary
        SliverPersistentHeader(
          pinned: true,
          delegate: _SummaryHeaderDelegate(
            child: _buildSummaryCard(),
          ),
        ),

        // form list
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index == _selectedItems.length) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        elevation: 4,
                        backgroundColor: const Color.fromARGB(255, 209, 206, 238),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _addItem,
                      icon: const Icon(Icons.add),
                      label: const Text("Add Rate Item"),
                    ),
                  ),
                );
              }

              final item = _selectedItems[index];
              return _buildFormItem(index, item);
            },
            childCount: _selectedItems.length + 1,
          ),
        ),

        // submit button
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // TODO: handle submit
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Form Submitted ")),
                  );
                },
                child: const Text("Submit", style: TextStyle(fontSize: 16)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _roundIconButton(
      {required IconData icon, required VoidCallback onTap}) {
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
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 16,
                offset: const Offset(0, 6)),
            BoxShadow(
                color: Colors.white.withOpacity(0.85),
                blurRadius: 4,
                offset: const Offset(-2, -2)),
          ],
        ),
        child: Icon(icon, color: textPrimary),
      ),
    );
  }

Widget _buildSummaryCard() {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: _summaryField(
                icon: Icons.attach_money,
                label: "Total",
                value: "₹${totalAmount.toStringAsFixed(0)}",
                readOnly: true,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _summaryField(
                icon: Icons.local_offer,
                label: "Discount",
                controller: _discountController,
                prefixText: "₹",
                onChanged: (_) => setState(() {}),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _summaryField(
          icon: Icons.check_circle,
          label: "Grand Total",
          value: "₹${grandTotal.toStringAsFixed(0)}",
          readOnly: true,
          isBold: true,
        ),
      ],
    ),
  );
}

Widget _summaryField({
  required IconData icon,
  required String label,
  String? value,
  TextEditingController? controller,
  bool readOnly = false,
  void Function(String)? onChanged,
  String? prefixText,
  bool isBold = false,
}) {
  final effectiveController = controller ?? TextEditingController(text: value ?? "");

  return ConstrainedBox(
    constraints: const BoxConstraints(
      minHeight: 48,
      maxHeight: 56,
    ),
    child: TextField(
      controller: effectiveController,
      readOnly: readOnly,
      onChanged: onChanged,
      keyboardType: readOnly ? null : TextInputType.number,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, size: 18, color: Colors.grey[700]),
        labelText: label,
        hintText: readOnly ? null : value, // ✅ show hint only if editable
        prefixText: prefixText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        isDense: true,
        labelStyle: const TextStyle(fontSize: 13),
        floatingLabelBehavior: FloatingLabelBehavior.always, // ✅ keeps label above
      ),
      style: TextStyle(
        fontSize: 14,
        fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
      ),
      maxLines: 1,
    ),
  );
}

  Widget _buildFormItem(int index, RateEnquiryModel item) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonSearchableDropdown<RateEnquiryModelResponse>(
              items: (filter, props) async {
                if (filter.isEmpty) return _rateEnquiries;
                return _rateEnquiries
                    .where((e) =>
                        e.name.toLowerCase().contains(filter.toLowerCase()))
                    .toList();
              },
              hintText: "Charge Name",
              selectedItem: item.rateEnqModel, // Keep the selected item to show current selection
              itemAsString: (e) => "${e.name} (₹${e.rate.toStringAsFixed(2)})",
              
              compareFn: (item1, item2) => item1.id == item2.id,
              onChanged: (val) {
                setState(() {
                  _selectedItems[index] = RateEnquiryModel(
                    rateEnqModel: val,
                    quantity: item.quantity ?? 1,
                    discountPercentage: item.discountPercentage ?? 0,
                    finalAmount: val != null ? val.rate * (item.quantity ?? 1) : 0.0,
                  );
                });
              },
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    key: ValueKey('rate_${index}_${item.rateEnqModel?.id}'), // Force rebuild when service changes
                    initialValue: item.rateEnqModel?.rate?.toString() ?? "0",
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: "Rate",
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    key: ValueKey('quantity_${index}'), // Maintain state for quantity
                    initialValue: item.quantity?.toString() ?? "1",
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Quantity",
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    style: const TextStyle(fontSize: 14),
                    onChanged: (val) {
                      _selectedItems[index].quantity = int.tryParse(val) ?? 1;
                      _updateItem(index);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    key: ValueKey('discount_${index}'), // Maintain state for discount
                    initialValue: item.discountPercentage?.toString() ?? "0",
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Discount (%)",
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                Expanded(
                  child: TextFormField(
                    key: ValueKey('final_${index}_${item.rateEnqModel?.id}_${item.finalAmount}'), // Force rebuild when amount changes
                    initialValue: item.finalAmount?.toStringAsFixed(2) ?? "0.00",
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: "Final Amount",
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeItem(index),
                ),
              ],
            ),
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
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(
      child: Align(
        alignment: Alignment.topCenter,
        child: child,
      ),
    );
  }

  @override
  double get maxExtent => 180; // Enough space for 2 rows + padding
  @override
  double get minExtent => 180;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}
