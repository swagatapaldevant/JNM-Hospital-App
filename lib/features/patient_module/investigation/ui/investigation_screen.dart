import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/services.dart';
import 'package:jnm_hospital_app/features/patient_module/model/patient_details/patient_details_model.dart';
import 'package:jnm_hospital_app/features/patient_module/patient_details_module/ui/common_layout.dart';

class InvestigationScreen extends StatefulWidget {
  const InvestigationScreen({super.key});

  @override
  State<InvestigationScreen> createState() => _InvestigationScreenState();
}

class _InvestigationScreenState extends State<InvestigationScreen> {
  bool _filterExpanded = false;
  final TextEditingController _search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PatientDetailsScreenLayout(slivers: [
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
                  "Investigations",
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
      SliverToBoxAdapter(
          child: _ExpandableFilterCard(
              expanded: _filterExpanded,
              searchField: _SearchField(
                controller: _search,
                hint: 'Search Patient name, UID…',
                onChanged: (_) => setState(() {}),
              ),
              onToggle: () =>
                  setState(() => _filterExpanded = !_filterExpanded),
              filters: FilterForm()))
    ]);
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
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.cyan, width: 2)),
        child: Icon(icon, color: Colors.black87),
      ),
    );
  }
}

class FilterForm extends StatefulWidget {
  const FilterForm({super.key});

  @override
  State<FilterForm> createState() => _FilterFormState();
}

class _FilterFormState extends State<FilterForm> {
  final _formKey = GlobalKey<FormState>();

  String? selectedField;
  final TextEditingController _fieldValueController = TextEditingController();
  String? selectedReportStatus;
  List<String> selectedMultiValues = [];
  DateTime? fromDate;
  DateTime? toDate;

  // Dummy data for multi-select
  final List<String> _dummyValues = [
    "Option 1",
    "Option 2",
    "Option 3",
    "Option 4",
    "Option 5",
  ];

  Future<void> _pickDate(BuildContext context, bool isFrom) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          fromDate = picked;
        } else {
          toDate = picked;
        }
      });
    }
  }

  void _resetForm() {
    setState(() {
      selectedField = null;
      _fieldValueController.clear();
      selectedReportStatus = null;
      selectedMultiValues = [];
      fromDate = null;
      toDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Field Name Dropdown
            DropdownButtonFormField<String>(
              value: selectedField,
              decoration: const InputDecoration(
                labelText: "Field Name",
                border: OutlineInputBorder(),
              ),
              items: ["Patient Name", "UHID", "Phone No."]
                  .map((field) => DropdownMenuItem(
                        value: field,
                        child: Text(field),
                      ))
                  .toList(),
              onChanged: (val) => setState(() => selectedField = val),
            ),
            const SizedBox(height: 12),

            // Field Value
            TextFormField(
              controller: _fieldValueController,
              decoration: const InputDecoration(
                labelText: "Field Value",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // Report Status Dropdown
            DropdownButtonFormField<String>(
              value: selectedReportStatus,
              decoration: const InputDecoration(
                labelText: "Report Status",
                border: OutlineInputBorder(),
              ),
              items: ["All", "Report Delivered", "Report Not Delivered"]
                  .map((status) => DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      ))
                  .toList(),
              onChanged: (val) => setState(() => selectedReportStatus = val),
            ),
            const SizedBox(height: 12),

            // Multi-select dropdown
            CommonMultiSelectDropdown<String>(
              hintText: "Select Multiple",
              items: (filter, props) async {
                if (filter.isEmpty) return _dummyValues;
                return _dummyValues
                    .where(
                        (e) => e.toLowerCase().contains(filter.toLowerCase()))
                    .toList();
              },
              selectedItems: selectedMultiValues,
              itemAsString: (item) => item,
              onChanged: (values) {
                setState(() => selectedMultiValues = values);
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
            const SizedBox(height: 12),

            // From Date
            InkWell(
              onTap: () => _pickDate(context, true),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: "From Date",
                  border: OutlineInputBorder(),
                ),
                child: Text(
                  fromDate != null
                      ? "${fromDate!.day}/${fromDate!.month}/${fromDate!.year}"
                      : "Select date",
                ),
              ),
            ),
            const SizedBox(height: 12),

            // To Date
            InkWell(
              onTap: () => _pickDate(context, false),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: "To Date",
                  border: OutlineInputBorder(),
                ),
                child: Text(
                  toDate != null
                      ? "${toDate!.day}/${toDate!.month}/${toDate!.year}"
                      : "Select date",
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Apply filter logic
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Filter applied")),
                      );
                    }
                  },
                  icon: const Icon(Icons.filter_alt),
                  label: const Text("Filter"),
                ),
                OutlinedButton.icon(
                  onPressed: _resetForm,
                  icon: const Icon(Icons.refresh),
                  label: const Text("Reset"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

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
                hintText: "Search...",
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
              labelStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w500),
              hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w600),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    BorderSide(color: theme.colorScheme.primary, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.redAccent),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.redAccent, width: 2),
              ),
            ),
          ),
    );
  }
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
        color: Colors.white, // SOLID WHITE
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
  final Widget searchField;
  final Widget filters;

  const _ExpandableFilterCard({
    required this.expanded,
    required this.onToggle,
    required this.searchField,
    required this.filters,
  });

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header row (tap anywhere to toggle)
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  const Icon(Icons.tune_rounded,
                      size: 20, color: Colors.indigo),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Search & Filters',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  // chevron animates
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

          // Search always visible
          searchField,

          // Animated expand area
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
                const SizedBox(height: 12),
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

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String>? onChanged;
  const _SearchField({
    required this.controller,
    required this.hint,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: controller.text.isEmpty
            ? null
            : IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  controller.clear();
                  onChanged?.call('');
                },
              ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.black.withOpacity(0.08)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.black.withOpacity(0.08)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide(color: Colors.indigo),
        ),
      ),
    );
  }
}

class InvestigationCard extends StatelessWidget {
  final OpdDetailsModel opd;
  final VoidCallback onTap;
  const InvestigationCard({required this.opd, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Accessors to be robust for snake/camel case
    String _doctorName() {
      final dn = opd.doctorName ?? (opd as dynamic).doctor_name;
      return (dn?.toString().trim().isNotEmpty ?? false) ? dn.toString() : 'Unknown Doctor';
    }

    String _departmentName() {
      final dd = opd.departmentName ?? (opd as dynamic).department_name;
      return (dd?.toString().trim().isNotEmpty ?? false) ? dd.toString() : '—';
    }

    String _appointmentIso() {
      final v = opd.appointmentDate ?? (opd as dynamic).appointment_date;
      return v?.toString() ?? '';
    }

    int _ticket() {
      final t = opd.billingId ?? (opd as dynamic).ticket_no;
      if (t is int) return t;
      if (t is String) return int.tryParse(t) ?? 0;
      return 0;
    }

    String _type() {
      final t = opd.type ?? (opd as dynamic).type;
      return (t?.toString().trim().isNotEmpty ?? false) ? t.toString() : '—';
    }

    double _due() {
      final d = opd.dueAmount ?? (opd as dynamic).due_amount;
      if (d is num) return d.toDouble();
      if (d is String) return double.tryParse(d) ?? 0.0;
      return 0.0;
    }

    int _billStatus() {
      final bs = opd.billStatus ?? (opd as dynamic).bill_status;
      if (bs is int) return bs;
      if (bs is String) return int.tryParse(bs) ?? 0;
      return 0;
    }

    String _uid() {
      final u = opd.uid ?? (opd as dynamic).uid;
      return (u?.toString().trim().isNotEmpty ?? false) ? u.toString() : '—';
    }

    final statusPaid = _billStatus() == 2;
    final statusColor = statusPaid ? Colors.green : Colors.orange;
    final apptText = _formatDateTime(_appointmentIso());

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white, // SOLID WHITE CARD
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
            // Leading circular gradient with ticket
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF00C2FF),
                    Color(0xFF7F5AF0),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.10),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  _ticket() == 0 ? 'OPD' : _ticket().toString(),
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
                  // Row: Department + Paid/Pending
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _departmentName(),
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
                          statusPaid ? 'Paid' : 'Pending',
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
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                         "Dr  ${_doctorName()}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13.5,
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Date & Type & UID
                  Wrap(
                    spacing: 10,
                    runSpacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.event, size: 16, color: Colors.blueGrey),
                          const SizedBox(width: 6),
                          Text(apptText, style: const TextStyle(fontSize: 12.5, color: Colors.black54)),
                        ],
                      ),
                      _chip(icon: Icons.category_outlined, label: (_type()).toUpperCase()),
                      if (_uid() != '—') _chip(icon: Icons.tag, label: 'UID: ${_uid()}'),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Due pill
                  _moneyPill(
                    icon: Icons.account_balance_wallet,
                    label: 'Due',
                    value: _inr(_due()),
                    emphasize: _due() > 0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _chip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.blueGrey),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  static String _formatDateTime(String? iso) {
    if (iso == null || iso.isEmpty) return '—';
    final d = DateTime.tryParse(iso);
    if (d == null) return iso;
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    final dd = d.day.toString().padLeft(2, '0');
    final mm = months[d.month - 1];
    final yyyy = d.year.toString();
    final hh = d.hour.toString().padLeft(2, '0');
    final min = d.minute.toString().padLeft(2, '0');
    return '$dd $mm $yyyy • $hh:$min';
  }

  static String _inr(num? v) {
    final n = (v ?? 0).toDouble();
    final s = n.toStringAsFixed(2);
    final parts = s.split('.');
    final whole = parts[0];
    final dec = parts[1];
    final buf = StringBuffer();
    for (int i = 0; i < whole.length; i++) {
      final left = whole.length - i - 1;
      buf.write(whole[i]);
      if (left > 0 && left % 3 == 0) buf.write(',');
    }
    return '₹${buf.toString()}.$dec';
  }

  Widget _moneyPill({
    required IconData icon,
    required String label,
    required String value,
    bool emphasize = false,
  }) {
    final color = emphasize ? Colors.red : Colors.blueGrey;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 6),
          Text(
            '$label: $value',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: color.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
