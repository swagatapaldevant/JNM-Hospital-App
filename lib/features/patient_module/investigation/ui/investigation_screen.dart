import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/services.dart';
import 'package:jnm_hospital_app/features/patient_module/model/investigation_report/investigation_report_model.dart';
import 'package:jnm_hospital_app/features/patient_module/patient_details_module/ui/common_layout.dart';

class InvestigationScreen extends StatefulWidget {
  const InvestigationScreen({super.key});

  @override
  State<InvestigationScreen> createState() => _InvestigationScreenState();
}

class _InvestigationScreenState extends State<InvestigationScreen> {
  bool _filterExpanded = false;

  List<InvstReportResModel> _reports = [];
  List<InvstReportResModel> _filteredReports = [];

  // Current filters
  FilterData _activeFilters = const FilterData(
    status: ReportStatus.all,
  );

  @override
  void initState() {
    super.initState();
    _fetchReports();
  }

  void _fetchReports() {
    // TODO: Replace with API
    _reports = [
      InvstReportResModel(
        billNo: 101,
        billDate: DateTime.now().subtract(const Duration(days: 1)),
        patientName: "John Doe",
        age: "30Y 5M 10D",
        doctorName: "Dr. Xyz",
        status: "Delivered",
      ),
      InvstReportResModel(
        billNo: 102,
        billDate: DateTime.now().subtract(const Duration(days: 3)),
        patientName: "Anita Sharma",
        age: "41Y 2M",
        doctorName: "Dr. Gupta",
        status: "Not Delivered",
      ),
      InvstReportResModel(
        billNo: 103,
        billDate: DateTime.now().subtract(const Duration(days: 9)),
        patientName: "Rahul Kumar",
        age: "26Y",
        doctorName: "Dr. Xyz",
        status: "Delivered",
      ),
    ];
    _applyFilters(); // initialize filtered list
  }

  void _applyFilters([FilterData? data]) {
    final f = data ?? _activeFilters;
    List<InvstReportResModel> list = [..._reports];

    // Status filter
    if (f.status == ReportStatus.delivered) {
      list = list.where((r) => (r.status ?? '').toLowerCase().contains('deliver')).toList();
    } else if (f.status == ReportStatus.notDelivered) {
      list = list.where((r) => !(r.status ?? '').toLowerCase().contains('deliver')).toList();
    }

    // Date range filter
    if (f.fromDate != null) {
      list = list.where((r) {
        final d = r.billDate;
        return d != null && !d.isBefore(DateTime(f.fromDate!.year, f.fromDate!.month, f.fromDate!.day));
      }).toList();
    }
    if (f.toDate != null) {
      list = list.where((r) {
        final d = r.billDate;
        // include the whole day
        final end = DateTime(f.toDate!.year, f.toDate!.month, f.toDate!.day, 23, 59, 59);
        return d != null && !d.isAfter(end);
      }).toList();
    }

    // Multi-tags (example usage – if you later map tags to reports, plug in here)
    if (f.tags.isNotEmpty) {
      // Placeholder logic: keep all; or implement your own tag mapping.
      // list = list.where((r) => yourTagCondition).toList();
    }

    setState(() {
      _activeFilters = f;
      _filteredReports = list;
    });
  }

  void _resetFilters() {
    setState(() {
      _activeFilters = const FilterData(status: ReportStatus.all);
    });
    _applyFilters();
  }

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
                  onTap: () => Navigator.pop(context),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    "Ready Reports",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Filters (NO search field)
        SliverToBoxAdapter(
          child: _ExpandableFilterCard(
            expanded: _filterExpanded,
            onToggle: () => setState(() => _filterExpanded = !_filterExpanded),
            filters: FilterForm(
              initial: _activeFilters,
              onApply: (f) => _applyFilters(f),
              onReset: _resetFilters,
            ),
          ),
        ),

        // List
        SliverList(
          delegate: SliverChildListDelegate.fixed([
            const SizedBox(height: 16),
            if (_filteredReports.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: _EmptyState(
                  title: "No results",
                  subtitle: "Try adjusting filters or date range.",
                ),
              ),
            ..._filteredReports.map(
                  (report) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: InvestigationCard(
                  onTap: () {
                    // TODO: handle open details
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Open bill #${report.billNo ?? ''}")),
                    );
                  },
                  report: report,
                ),
              ),
            ),
            const SizedBox(height: 12),
          ]),
        ),
      ],
    );
  }

  Widget _roundIconButton({required IconData icon, required VoidCallback onTap}) {
    return InkResponse(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      radius: 28,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.cyan, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.06),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.black87),
      ),
    );
  }
}

/* ===========================================================
 * Models & Filter types
 * ===========================================================
*/

enum ReportStatus { all, delivered, notDelivered }

class FilterData {
  final ReportStatus status;
  final DateTime? fromDate;
  final DateTime? toDate;
  final List<String> tags;

  const FilterData({
    this.status = ReportStatus.all,
    this.fromDate,
    this.toDate,
    this.tags = const [],
  });

  FilterData copyWith({
    ReportStatus? status,
    DateTime? fromDate,
    DateTime? toDate,
    List<String>? tags,
  }) {
    return FilterData(
      status: status ?? this.status,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      tags: tags ?? this.tags,
    );
  }
}

/* ===========================================================
 * Filter Form (no search)
 * ===========================================================
*/

class FilterForm extends StatefulWidget {
  const FilterForm({
    super.key,
    required this.initial,
    required this.onApply,
    required this.onReset,
  });

  final FilterData initial;
  final ValueChanged<FilterData> onApply;
  final VoidCallback onReset;

  @override
  State<FilterForm> createState() => _FilterFormState();
}

class _FilterFormState extends State<FilterForm> {
  late FilterData _data;
  String? selectedValue;
  final TextEditingController fieldValue = TextEditingController();
  final List<String> options = ["Patient Name",
    "UHID",
    "Phone number",];
  
  // Dummy tags for multi-select
    final List<String> _dummyValues = const [
    "Option A",
    "Option B",
    "Option C",
  ];

  @override
  void initState() {
    super.initState();
    _data = widget.initial;
  }

  Future<void> _pickDate(BuildContext context, bool isFrom) async {
    final now = DateTime.now();
    final base = isFrom ? (_data.fromDate ?? now) : (_data.toDate ?? now);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: base,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          _data = _data.copyWith(fromDate: picked);
        } else {
          _data = _data.copyWith(toDate: picked);
        }
      });
    }
  }

  void _clearDate(bool isFrom) {
    setState(() {
      if (isFrom) {
        _data = _data.copyWith(fromDate: null);
      } else {
        _data = _data.copyWith(toDate: null);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(6, 0, 6, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status chips
                    // Dropdown
          DropdownButtonFormField<String>(
            value: selectedValue,
            decoration: InputDecoration(
              labelText: "Select an option",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            items: options.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (val) => setState(() => selectedValue = val),
          ),
          const SizedBox(height: 16),

          // Text Field
          TextFormField(
            controller: fieldValue,
            decoration: InputDecoration(
              labelText: "Enter Field Value",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const Text(
            "Status",
            style: TextStyle(fontWeight: FontWeight.w800, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              _choiceChip(
                label: "All",
                selected: _data.status == ReportStatus.all,
                onSelected: () => setState(() => _data = _data.copyWith(status: ReportStatus.all)),
              ),
              _choiceChip(
                label: "Delivered",
                selected: _data.status == ReportStatus.delivered,
                onSelected: () => setState(() => _data = _data.copyWith(status: ReportStatus.delivered)),
              ),
              _choiceChip(
                label: "Not Delivered",
                selected: _data.status == ReportStatus.notDelivered,
                onSelected: () => setState(() => _data = _data.copyWith(status: ReportStatus.notDelivered)),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Date range
          const Text(
            "Date Range",
            style: TextStyle(fontWeight: FontWeight.w800, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _dateField(
                  label: "From",
                  date: _data.fromDate,
                  onTap: () => _pickDate(context, true),
                  onClear: () => _clearDate(true),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _dateField(
                  label: "To",
                  date: _data.toDate,
                  onTap: () => _pickDate(context, false),
                  onClear: () => _clearDate(false),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Tags (optional)
          const Text(
            "Tags (optional)",
            style: TextStyle(fontWeight: FontWeight.w800, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          CommonMultiSelectDropdown<String>(
            hintText: "Select tags",
            items: (filter, props) async {
              if (filter.isEmpty) return _dummyValues;
              return _dummyValues
                  .where((e) => e.toLowerCase().contains(filter.toLowerCase()))
                  .toList();
            },
            selectedItems: _data.tags,
            itemAsString: (item) => item,
            onChanged: (values) {
              setState(() => _data = _data.copyWith(tags: values));
            },
            popupProps: PopupPropsMultiSelection.menu(
              showSearchBox: true,
              showSelectedItems: true,
              menuProps: MenuProps(
                backgroundColor: Colors.white,
                elevation: 4,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => widget.onApply(_data),
                  icon: const Icon(Icons.filter_alt),
                  label: const Text("Apply Filters"),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: widget.onReset,
                  icon: const Icon(Icons.refresh),
                  label: const Text("Reset"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _choiceChip({
    required String label,
    required bool selected,
    required VoidCallback onSelected,
  }) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      labelStyle: TextStyle(
        fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
        color: selected ? Colors.white : Colors.black87,
      ),
      selectedColor: const Color(0xFF4F46E5),
      backgroundColor: Colors.white,
      shape: StadiumBorder(
        side: BorderSide(color: selected ? const Color(0xFF4F46E5) : Colors.black12),
      ),
    );
  }

  Widget _dateField({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
    required VoidCallback onClear,
  }) {
    final text = date == null ? "Select date" : _formatDate(date);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          suffixIcon: date == null
              ? const Icon(Icons.event, size: 18)
              : IconButton(
            tooltip: "Clear",
            icon: const Icon(Icons.close, size: 18),
            onPressed: onClear,
          ),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
        child: Text(text),
      ),
    );
  }

  String _formatDate(DateTime d) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return "${d.day.toString().padLeft(2, '0')} ${months[d.month - 1]} ${d.year}";
  }
}

/* ===========================================================
 * Common Multi-Select (kept)
 * ===========================================================
*/

class CommonMultiSelectDropdown<T> extends StatelessWidget {
  final FutureOr<List<T>> Function(String, LoadProps?) items;
  final String hintText;
  final List<T>? selectedItems;
  final void Function(List<T>)? onChanged;
  final String Function(T)? itemAsString;
  final bool Function(T, String)? filterFn;
  final bool Function(T, T)? compareFn;
  final Future<bool?> Function(List<T>?, List<T>?)? onBeforeChange;
  final Future<bool?> Function(List<T>?)? onBeforePopupOpening;
  final void Function(List<T>?)? onSaved;
  final String? Function(List<T>?)? validator;
  final Widget Function(BuildContext, List<T>?)? dropdownBuilder;
  final DropDownDecoratorProps? decoratorProps;
  final PopupPropsMultiSelection<T>? popupProps;
  final bool enabled;
  final AutovalidateMode? autoValidateMode;

  const CommonMultiSelectDropdown({
    super.key,
    required this.items,
    this.hintText = "Select items",
    this.selectedItems,
    this.onChanged,
    this.itemAsString,
    this.filterFn,
    this.compareFn,
    this.onBeforeChange,
    this.onBeforePopupOpening,
    this.onSaved,
    this.validator,
    this.dropdownBuilder,
    this.decoratorProps,
    this.popupProps,
    this.enabled = true,
    this.autoValidateMode = AutovalidateMode.disabled,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DropdownSearch<T>.multiSelection(
      items: items,
      selectedItems: selectedItems ?? [],
      onChanged: onChanged,
      itemAsString: itemAsString,
      filterFn: filterFn,
      compareFn: compareFn,
      onBeforeChange: onBeforeChange,
      onBeforePopupOpening: onBeforePopupOpening,
      onSaved: onSaved,
      validator: validator,
      dropdownBuilder: dropdownBuilder ??
              (context, selectedItems) {
            if (selectedItems == null || selectedItems.isEmpty) {
              return const Text(
                "None",
                style: TextStyle(fontSize: 12, color: Colors.black54),
              );
            }
            return Wrap(
              spacing: 4,
              runSpacing: -8,
              children: selectedItems
                  .map((e) => Chip(
                label: Text(
                  itemAsString?.call(e) ?? e.toString(),
                  style: const TextStyle(fontSize: 12),
                ),
                visualDensity: VisualDensity.compact,
              ))
                  .toList(),
            );
          },
      popupProps: popupProps ??
          PopupPropsMultiSelection.menu(
            showSearchBox: true,
            showSelectedItems: true,
            menuProps: MenuProps(
              backgroundColor: Colors.white,
              elevation: 4,
              borderRadius: BorderRadius.circular(8),
            ),
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                hintText: "Search tags...",
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                ),
                hintStyle: const TextStyle(fontSize: 12),
              ),
              style: const TextStyle(fontSize: 12),
            ),
          ),
      enabled: enabled,
      autoValidateMode: autoValidateMode,
      decoratorProps: decoratorProps ??
          DropDownDecoratorProps(
            decoration: InputDecoration(
              labelText: hintText,
              labelStyle: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500),
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w600),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.redAccent),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.redAccent, width: 2),
              ),
            ),
          ),
    );
  }
}

/* ===========================================================
 * Cards & UI shells
 * ===========================================================
*/

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
                  const Icon(Icons.tune_rounded, size: 20, color: Colors.indigo),
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
                    child: const Icon(Icons.keyboard_arrow_down_rounded, size: 22, color: Colors.black54),
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
            crossFadeState: expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
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

class _EmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  const _EmptyState({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      child: Column(
        children: [
          const Icon(Icons.inbox_rounded, size: 56, color: Colors.indigo),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class InvestigationCard extends StatelessWidget {
  final InvstReportResModel report;
  final VoidCallback onTap;
  const InvestigationCard({required this.report, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final status = (report.status ?? '').toLowerCase().contains('deliver');
    final statusColor = status ? Colors.green : Colors.orange;
    final dateText = _formatDateTime(report.billDate);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
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
        child: Row(
          children: [
            // Leading circular gradient with bill no
            Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF00C2FF), Color(0xFF7F5AF0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Text(
                  (report.billNo ?? '—').toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + status
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          (report.patientName ?? 'Unknown Patient'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w800,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: statusColor.withOpacity(0.4)),
                        ),
                        child: Text(
                          status ? 'Delivered' : 'Not Delivered',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Doctor
                  Text(
                    "Dr ${report.doctorName ?? 'NA'}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13.5,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Date row
                  Row(
                    children: [
                      const Icon(Icons.event, size: 16, color: Colors.blueGrey),
                      const SizedBox(width: 6),
                      Text(
                        dateText,
                        style: const TextStyle(fontSize: 12.5, color: Colors.black54),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _formatDateTime(DateTime? d) {
    if (d == null) return '—';
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    final dd = d.day.toString().padLeft(2, '0');
    final mm = months[d.month - 1];
    final yyyy = d.year.toString();
    final hh = d.hour.toString().padLeft(2, '0');
    final min = d.minute.toString().padLeft(2, '0');
    return '$dd $mm $yyyy • $hh:$min';
  }
}
