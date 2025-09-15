import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/locator.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/status.dart';
import 'package:jnm_hospital_app/features/patient_module/model/patient_bills/patient_bills_model.dart';
import 'package:jnm_hospital_app/features/patient_module/patient_bills/data/patient_bills_usecases.dart';
import 'package:jnm_hospital_app/features/patient_module/patient_bills/widget/patient_bill_card.dart';
import 'package:jnm_hospital_app/features/patient_module/patient_details/ui/common_layout.dart';

import '../../patient_details/ui/common_header.dart';

class PatientBillsScreen extends StatefulWidget {
  const PatientBillsScreen({super.key});

  @override
  State<PatientBillsScreen> createState() => _PatientBillsScreenState();
}

class _PatientBillsScreenState extends State<PatientBillsScreen> {
  final ScrollController _scrollController = ScrollController();
bool _filtersExpanded = false;

  final List<PatientBillModel> _bills = [];
  bool _isInitialLoading = false;
  bool _isPageLoading = false;
  bool _hasMore = true;
  int _page = 1;

  DateTime? _fromDate;
  DateTime? _toDate;

  @override
  void initState() {
    super.initState();
    _fetchBills(initial: true);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100 &&
          !_isPageLoading &&
          _hasMore) {
        _fetchBills();
      }
    });
  }

  Future<void> _fetchBills({bool initial = false}) async {
    if (initial) {
      setState(() {
        _isInitialLoading = true;
        _page = 1;
        _bills.clear();
        _hasMore = true;
      });
    } else {
      setState(() => _isPageLoading = true);
    }

    try {
      final requestData = {
        "page": _page.toString(),
        if (_fromDate != null)
          "from_date": DateFormat("yyyy-MM-dd").format(_fromDate!),
        if (_toDate != null)
          "to_date": DateFormat("yyyy-MM-dd").format(_toDate!),
      };

      final response =
          await getIt<PatientBillsUsecases>().getPatientBills(requestData);

      if (response.status == STATUS.SUCCESS) {
        print(response.data);
        final rawData = response.data as List<dynamic>;

        final fetched = rawData.map((data) => PatientBillModel.fromJson(data));

        setState(() {
          if (initial) {
            _bills.clear();
          }
          _bills.addAll(fetched);
          _hasMore = fetched.isNotEmpty;
          if (_hasMore) _page++;
        });
      } else {
        setState(() => _hasMore = false);
      }
    } finally {
      if (initial) {
        setState(() => _isInitialLoading = false);
      } else {
        setState(() => _isPageLoading = false);
      }
    }
  }

  Future<void> _pickDate(bool isFrom) async {
    final now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isFrom ? (_fromDate ?? now) : (_toDate ?? now),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isFrom) {
          _fromDate = picked;
        } else {
          _toDate = picked;
        }
      });
      
    }
  }

  void _clearDate(bool isFrom) {
    setState(() {
      if (isFrom) {
        _fromDate = null;
      } else {
        _toDate = null;
      }
    });
    _fetchBills(initial: true);
  }

  @override
  Widget build(BuildContext context) {
    return PatientDetailsScreenLayout(
      slivers: [
        const CommonHeader(title: "Bills"),

        // Filter Section
        SliverToBoxAdapter(
  child: _ExpandableFilterCard(
    expanded: _filtersExpanded,
    onToggle: () {
      setState(() {
        _filtersExpanded = !_filtersExpanded;
      });
    },
    filters: _buildDateRangeFilter(),
  ),
),

        // Content
        if (_isInitialLoading)
          const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          )
        else if (_bills.isEmpty)
          const SliverFillRemaining(
            child: Center(child: Text("No bills found")),
          )
        else
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index == _bills.length) {
                  return _isPageLoading
                      ? const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : const SizedBox();
                }
                final bill = _bills[index];
                return PatientBillCard(bill: bill);
              },
              childCount: _bills.length + 1,
            ),
          ),
      ],
    );
  }
  
Widget _buildDateRangeFilter() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Date Fields Row
      Row(
        children: [
          Expanded(
            child: _buildDateField(
              label: "From Date",
              date: _fromDate,
              onTap: () => _pickDate(true),
              onClear: () => _clearDate(true),
              icon: Icons.calendar_today,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Icon(
              Icons.arrow_forward,
              color: Colors.grey[400],
              size: 20,
            ),
          ),
          Expanded(
            child: _buildDateField(
              label: "To Date",
              date: _toDate,
              onTap: () => _pickDate(false),
              onClear: () => _clearDate(false),
              icon: Icons.event,
            ),
          ),
        ],
      ),
      
      const SizedBox(height: 20),
      
      // Submit Button
      SizedBox(
        width: double.infinity,
        height: 46,
        child: ElevatedButton(
          onPressed: _isValidDateRange() ? _onSubmit : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            disabledBackgroundColor: Colors.grey[300],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.filter_alt,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                "Apply Filter",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
      
      // Helper Text
      if (_fromDate != null || _toDate != null)
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 12,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  _getHelperText(),
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        ),
    ],
  );
}

// Simplified Date Field Widget (removes the card styling since it's now in the expandable card)
Widget _buildDateField({
  required String label,
  required DateTime? date,
  required VoidCallback onTap,
  required VoidCallback onClear,
  required IconData icon,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Colors.grey[600],
          letterSpacing: 0.3,
        ),
      ),
      const SizedBox(height: 6),
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: date != null ? Colors.indigo : Colors.grey[300]!,
              width: date != null ? 1.2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
            color: date != null 
                ? Colors.indigo.withOpacity(0.04)
                : Colors.grey[50],
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: date != null 
                    ? Colors.indigo 
                    : Colors.grey[400],
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  date != null 
                      ? DateFormat('MMM dd, yyyy').format(date)
                      : "Select date",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: date != null ? FontWeight.w500 : FontWeight.w400,
                    color: date != null ? Colors.grey[800] : Colors.grey[500],
                  ),
                ),
              ),
              if (date != null)
                GestureDetector(
                  onTap: onClear,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    child: Icon(
                      Icons.close,
                      size: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    ],
  );
}

// Helper Methods (same as before)
bool _isValidDateRange() {
  if (_fromDate == null || _toDate == null) return false;
  if (_fromDate != null && _toDate != null) {
    return _fromDate!.isBefore(_toDate!) || _fromDate!.isAtSameMomentAs(_toDate!);
  }
  return true;
}

String _getHelperText() {
  if (_fromDate != null && _toDate != null) {
    final difference = _toDate!.difference(_fromDate!).inDays;
    return "Selected range: ${difference + 1} day${difference != 0 ? 's' : ''}";
  } else if (_fromDate != null) {
    return "Select end date to complete range";
  } else if (_toDate != null) {
    return "Select start date to complete range";
  }
  return "";
}

void _onSubmit() {
  // Add your submit logic here
  print("Submitting date range: ${_fromDate} to ${_toDate}");
  
  // Optionally collapse the filter after submitting
  setState(() {
    _filtersExpanded = false;
  });
  
  
  _fetchBills();
  
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Text("Filter applied successfully!", style: TextStyle(fontSize: 13)),
        ],
      ),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      margin: EdgeInsets.all(16),
    ),
  );
}
}
class _ExpandableFilterCard extends StatelessWidget {
  final bool expanded;
  final VoidCallback onToggle;
  final Widget filters;

  const _ExpandableFilterCard({
    required this.expanded,
    required this.onToggle,
    required this.filters,
  });

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header row (tap to toggle)
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  const Icon(Icons.tune_rounded,
                      size: 20, color: Colors.indigo),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Filters',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    duration: const Duration(milliseconds: 200),
                    turns: expanded ? 0.5 : 0.0, // 0 -> down, 0.5 -> up
                    child: const Icon(Icons.keyboard_arrow_down_rounded,
                        size: 22, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),

          // Animated expand area (no search field)
          AnimatedCrossFade(
            firstCurve: Curves.easeOut,
            secondCurve: Curves.easeOut,
            sizeCurve: Curves.easeOut,
            duration: const Duration(milliseconds: 220),
            crossFadeState:
                expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            firstChild: const SizedBox(height: 0),
            secondChild: Column(
              children: [
                const SizedBox(height: 8),
                _softDivider(),
                const SizedBox(height: 12),
                filters,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _softDivider() => Container(
        height: 1,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black.withOpacity(0.06), Colors.transparent],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
      );
}
class _WhiteCard extends StatelessWidget {
  final Widget child;
  const _WhiteCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.15), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}