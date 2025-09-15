import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/resource.dart';
import 'package:jnm_hospital_app/core/utils/helper/common_utils.dart';
import 'package:jnm_hospital_app/features/patient_module/investigation/data/investigation_usecases_impl.dart';
import 'package:jnm_hospital_app/features/patient_module/model/investigation_report/investigation_report_model.dart';
import 'package:jnm_hospital_app/features/patient_module/patient_details/ui/common_header.dart';
import 'package:jnm_hospital_app/features/patient_module/patient_details/ui/common_layout.dart';

class InvestigationScreen extends StatefulWidget {
  const InvestigationScreen({super.key});

  @override
  State<InvestigationScreen> createState() => _InvestigationScreenState();
}

class _InvestigationScreenState extends State<InvestigationScreen> {
  bool _filterExpanded = false;
  bool isLoading = false;

  List<InvstReportResModel> _reports = [];
  List<InvstReportResModel> _filteredReports = [];

  // Current filters
  FilterData _activeFilters = const FilterData(
    status: ReportStatus.all,
  );

  @override
  void initState() {
    super.initState();
    _fetchReports({});
  }

  void _fetchReports(Map<String, String> filters) async {
    setState(() {
      isLoading = true;
    });
    // final now = DateTime.now();
    // final String today = DateFormat("yyyy-MM-dd").format(now);
    // final oneYearAgo = DateTime(now.year - 1, now.month, now.day);
    // final String oneYearAgoStr = DateFormat("yyyy-MM-dd").format(oneYearAgo);

    // String fromDate = oneYearAgoStr;
    // String toDate = today;

    try {
      Resource resource =
          await InvestigationUsecasesImpl().getInvestigationReport(filters);

      final data = resource.data as List;
      _reports.clear();
      for (final item in data) {
        _reports.add(InvstReportResModel.fromJson(item));
      }
    } catch (err) {
      print(err);
      if (!mounted) return;

      CommonUtils().flutterSnackBar(
          context: context, mes: "Please retry!", messageType: 4);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _applyFilters([FilterData? data]) {
    print("apply");
    _fetchReports(data?.toJson() ?? {});
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
        const CommonHeader(title: "Ready Reports"),

        // Filters
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
        isLoading
            ? const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : _reports.isEmpty
                ? SliverPadding(
                   padding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  sliver: SliverToBoxAdapter(
                    child: _EmptyState(
                      title: "No results",
                      subtitle: "Try adjusting filters or date range.",
                    ),
                  ),
                )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final report = _reports[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: InvestigationCard(
                            onTap: () {
                              // handle details
                            },
                            report: report,
                          ),
                        );
                      },
                      childCount: _reports.length,
                    ),
                  ),
      ],
    );
  }

}

/* ===========================================================
 * Models & Filter types
 * ===========================================================
*/


class FilterData {
  final ReportStatus status;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String? fieldName;
  final String? fieldValue;

  const FilterData({
    this.status = ReportStatus.all,
    this.fromDate,
    this.toDate,
    this.fieldName,
    this.fieldValue,
  });

  FilterData copyWith({
    ReportStatus? status,
    DateTime? fromDate,
    DateTime? toDate,
    String? fieldName,
    String? fieldValue,
  }) {
    return FilterData(
      status: status ?? this.status,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      fieldName: fieldName ?? this.fieldName,
      fieldValue: fieldValue ?? this.fieldValue,
    );
  }

  Map<String, String> toJson() {
    final dateFormatter = DateFormat("yyyy-MM-dd");
    final Map<String, String> data = {
      "status_value": status.value,
    };

    if (fromDate != null) {
      data["from_date"] = dateFormatter.format(fromDate!);
    }
    if (toDate != null) {
      data["to_date"] = dateFormatter.format(toDate!);
    }
    if (fieldName != null) {
      data["field_name"] = fieldName!;
    }
    if (fieldValue != null) {
      data["field_value"] = fieldValue!;
    }

    return data;
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

  final Map<String, String> options = {
    "name": "Patient Name",
    "patient_id": "UHID",
    "phone": "Phone number",
  };

  @override
  void initState() {
    super.initState();
    _data = widget.initial;
    selectedValue = _data.fieldName;
    fieldValue.text = _data.fieldValue ?? "";
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

  void _reset() {
    setState(() {
      _data = widget.initial;
      selectedValue = _data.fieldName;
      fieldValue.text = _data.fieldValue ?? "";
    });
    widget.onReset();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(6, 0, 6, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dropdown
          DropdownButtonFormField<String>(
            value: selectedValue,
            decoration: InputDecoration(
              labelText: "Select an option",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            items: options.entries
                .map((entry) => DropdownMenuItem(
                      value: entry.key,
                      child: Text(entry.value),
                    ))
                .toList(),
            onChanged: (val) {
              setState(() {
                selectedValue = val;
                _data = _data.copyWith(fieldName: val);
              });
            },
          ),
          const SizedBox(height: 16),

          // Text Field
          TextFormField(
            controller: fieldValue,
            decoration: InputDecoration(
              labelText: "Enter Field Value",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onChanged: (val) {
              setState(() {
                _data = _data.copyWith(fieldValue: val.isEmpty ? null : val);
              });
            },
          ),
          const SizedBox(height: 16),

          // Status chips
          const Text(
            "Status",
            style:
                TextStyle(fontWeight: FontWeight.w800, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              _choiceChip(
                label: "All",
                selected: _data.status == ReportStatus.all,
                onSelected: () => setState(
                    () => _data = _data.copyWith(status: ReportStatus.all)),
              ),
              _choiceChip(
                label: "Delivered",
                selected: _data.status == ReportStatus.delivered,
                onSelected: () => setState(() =>
                    _data = _data.copyWith(status: ReportStatus.delivered)),
              ),
              _choiceChip(
                label: "Not Delivered",
                selected: _data.status == ReportStatus.notDelivered,
                onSelected: () => setState(() =>
                    _data = _data.copyWith(status: ReportStatus.notDelivered)),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Date range
          const Text(
            "Date Range",
            style:
                TextStyle(fontWeight: FontWeight.w800, color: Colors.black87),
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
                  onPressed: _reset,
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
        side: BorderSide(
            color: selected ? const Color(0xFF4F46E5) : Colors.black12),
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
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
        child: Text(text),
      ),
    );
  }

  String _formatDate(DateTime d) {
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
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      BorderSide(color: theme.colorScheme.primary, width: 2),
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
              labelStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w500),
              hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w600),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    BorderSide(color: theme.colorScheme.primary, width: 2),
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

 Color _statusColor(ReportStatus status) {
    switch (status) {
      case ReportStatus.delivered:
        return Colors.green;
      case ReportStatus.notDelivered:
        return Colors.orange;
      default:
        return Colors.blueGrey;
    }
  }

  String _statusLabel(ReportStatus status) {
    switch (status) {
      case ReportStatus.delivered:
        return "Delivered";
      case ReportStatus.notDelivered:
        return "Not Delivered";
      default:
        return "All";
    }
  }

  Widget build(BuildContext context) {
  final dateText = _formatDateTime(report.billCreatedDate);
  final status = report.status;

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
      child: Column(
        children: [
          Row(
            children: [
              // Leading circle with bill uid
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
                    (report.uid ?? '—').toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Main content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name + Status chip
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
                        const SizedBox(width: 8),
                        if (_statusLabel(status) != "All")
                          Chip(
                            label: Text(
                              _statusLabel(status),
                              style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            ),
                            backgroundColor: _statusColor(status),
                            visualDensity: VisualDensity.compact,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Expand button
              Container(
                margin: const EdgeInsets.only(left: 8),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _showDetailModal(context),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.expand_more,
                        size: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

void _showDetailModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _DetailModalSheet(report: report),
  );
}


  static String _formatDateTime(DateTime? d) {
    if (d == null) return '—';
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
    final dd = d.day.toString().padLeft(2, '0');
    final mm = months[d.month - 1];
    final yyyy = d.year.toString();
    final hh = d.hour.toString().padLeft(2, '0');
    final min = d.minute.toString().padLeft(2, '0');
    return '$dd $mm $yyyy • $hh:$min';
  }
}
class _DetailModalSheet extends StatelessWidget {
  final InvstReportResModel report;

  const _DetailModalSheet({required this.report});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
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
                      (report.uid ?? '—').toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Patient Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.grey[800],
                        ),
                      ),
                      Text(
                        report.patientName ?? 'Unknown Patient',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close, color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(
                    'Patient Information',
                    [
                      _buildInfoRow(Icons.person, 'Patient Name', report.patientName ?? 'N/A'),
                      _buildInfoRow(Icons.phone, 'Phone', report.phone ?? 'N/A'),
                      _buildInfoRow(Icons.people, 'Gender', report.gender ?? 'N/A'),
                      _buildInfoRow(Icons.cake, 'Date of Birth', _formatDateOfBirth()),
                      _buildInfoRow(Icons.badge, 'Patient ID', report.patientId?.toString() ?? 'N/A'),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  _buildSection(
                    'Medical Information',
                    [
                      _buildInfoRow(Icons.medical_services, 'Doctor', 'Dr ${report.doctorName ?? 'N/A'}'),
                      _buildInfoRow(Icons.person_pin, 'Referral', report.referralName ?? 'N/A'),
                      _buildInfoRow(Icons.science, 'Section', report.section ?? 'N/A'),
                      _buildInfoRow(Icons.bed, 'Bed Name', report.bedName ?? 'N/A'),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  _buildSection(
                    'Bill Information',
                    [
                      _buildInfoRow(Icons.receipt_long, 'Bill ID', report.billId?.toString() ?? 'N/A'),
                      _buildInfoRow(Icons.event, 'Created Date', _formatDateTime(report.billCreatedDate)),
                      if (report.statusValue != null)
                        _buildStatusRow(),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.1)),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, size: 18, color: Colors.grey[600]),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(Icons.info, size: 18, color: Colors.grey[600]),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              'Status',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor(report.statusValue),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _statusLabel(report.statusValue),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateOfBirth() {
    if (report.dobYear != null && report.dobMonth != null && report.dobDay != null) {
      try {
        final date = DateTime(report.dobYear!, report.dobMonth!, report.dobDay!);
        return DateFormat('MMM dd, yyyy').format(date);
      } catch (e) {
        return 'Invalid Date';
      }
    }
    return 'N/A';
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'N/A';
    return DateFormat('MMM dd, yyyy • hh:mm a').format(dateTime);
  }

  // You'll need to implement these methods based on your existing logic
  String _statusLabel(dynamic status) {
    // Implement your status label logic here
    return status?.toString() ?? 'Unknown';
  }

  Color _statusColor(dynamic status) {
    // Implement your status color logic here
    return Colors.blue; // Default color
  }
}