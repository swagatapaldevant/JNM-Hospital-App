import 'dart:math';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/api_endpoint.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/locator.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/resource.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/status.dart';
import 'package:jnm_hospital_app/core/services/localStorage/shared_pref.dart';
import 'package:jnm_hospital_app/features/admin_report_module/common_widgets/searchable_dropdown.dart';
import 'package:jnm_hospital_app/features/admin_report_module/dashboard_module/presentation/report_dashboard_screen.dart';
import 'package:jnm_hospital_app/features/patient_module/model/appointment_form/slot_selection_model.dart';
import 'package:jnm_hospital_app/features/patient_module/patient_details_module/ui/common_layout.dart';
import 'package:jnm_hospital_app/features/patient_module/patient_opd_module/data/patient_opd_usecases_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppointmentFormScreen extends StatelessWidget {
  const AppointmentFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PatientDetailsScreenLayout(
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Row(
              children: [
                _roundIconButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => Navigator.pop(context)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "OPD Registration",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const _AppointmentForm()
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
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.cyan, width: 2),
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.black87),
      ),
    );
  }
}

class _AppointmentForm extends StatefulWidget {
  const _AppointmentForm({super.key});

  @override
  State<_AppointmentForm> createState() => _AppointmentFormState();
}

class _AppointmentFormState extends State<_AppointmentForm> {
  final _formKey = GlobalKey<FormState>();
  final Dio _dio = DioClient().dio;
  final SharedPref _pref = getIt<SharedPref>();

  // Controllers
  final TextEditingController uhidController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController monthController = TextEditingController();
  final TextEditingController dayController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  // Dropdown selections
  Map<int, String>? selectedDepartment;
  Map<int, String>? selectedDoctor;

  // Date + Time
  DateTime? selectedDate;
  String? selectedTime;
  SlotSelectionModel? selectedSlot;

  // Data
  final List<Map<int, String>> departments = [];
  final List<Map<int, String>> doctors = [];
  final List<DateTime> dateList = [];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getDepartmentsData();
  }

  @override
  void dispose() {
    uhidController.dispose();
    mobileController.dispose();
    nameController.dispose();
    genderController.dispose();
    yearController.dispose();
    monthController.dispose();
    dayController.dispose();
    addressController.dispose();
    super.dispose();
  }

  // ---------- Data -----------
  Future<void> getDepartmentsData() async {
    setState(() => isLoading = true);
    final impl = PatientOPDUsecasesImpl();
    final Resource resource = await impl.getOPDDepartments();
    if (resource.status == STATUS.SUCCESS) {
      final response = resource.data as List;
      departments.clear();
      for (final dept in response) {
        final id = dept['id'] as int;
        final name = (dept['department_name'] ?? '').toString();
        departments.add({id: name});
      }
      setState(() {});
    } else {
      _snack(context, resource.message ?? "Failed to load departments");
    }
    setState(() => isLoading = false);
  }

  Future<void> getDoctorsData(int selectedDeptId) async {
    setState(() => isLoading = true);
    final impl = PatientOPDUsecasesImpl();
    final Resource resource = await impl.getOPDDoctors(selectedDeptId);
    if (resource.status == STATUS.SUCCESS) {
      final response = resource.data as List;
      doctors.clear();
      for (final row in response) {
        final id = row['id'] as int;
        final name = (row['name'] ?? '').toString();
        doctors.add({id: name});
      }
      setState(() {});
    } else {
      _snack(context, resource.message ?? "Failed to load doctors");
    }
    setState(() => isLoading = false);
  }

  getScheduleData() async {
    setState(() {
      isLoading = true;
    });
    PatientOPDUsecasesImpl patientOPDUsecasesImpl = PatientOPDUsecasesImpl();
    Resource resource =
        await patientOPDUsecasesImpl.getOPDSchedule(selectedDoctor!.keys.first);
    if (resource.status == STATUS.SUCCESS) {
      print("Success");
      print(resource.data);
      final response = resource.data['uniqueDates'] as List;

      response.forEach((schedule) {
        DateTime date = DateTime.parse(schedule);
        dateList.add(date);
      });
      setState(() {});
    } else {
      // Handle error
      print("Error: ${resource.message}");
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<List<SlotSelectionModel>> getTimeslotData(
      DateTime selectedDate) async {
    setState(() {
      isLoading = true;
    });
    List<SlotSelectionModel> timeList = [];
    final token = await _pref.getUserAuthToken();

    print(selectedDoctor!.keys.first);
    print(DateFormat('yyyy-MM-dd').format(selectedDate));

    try {
      final response = await _dio.post(
        ApiEndPoint.getOPDTimeslot,
        data: {
          "doctor_id": selectedDoctor!.keys.first,
          "date": DateFormat('yyyy-MM-dd').format(selectedDate),
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        final resource = response.data;

        if (resource["success"] == true) {
          final List<dynamic> slots = resource["uniqueDates_withtiming"] ?? [];

          for (var timeslot in slots) {
            // final int id = timeslot["id"];
            // final String fromTime = timeslot["from_time"];
            // final String toTime = timeslot["to_time"];
            final SlotSelectionModel slot =
                SlotSelectionModel.fromJson(timeslot);
            timeList.add(slot);
          }

          print("Fetched ${timeList.length} slots");
        } else {
          print("API returned error: ${resource}");
        }
      } else {
        print("Error: ${response.statusCode} ${response.statusMessage}");
      }
    } catch (err) {
      print("Exception: $err");
    }

    setState(() {
      isLoading = false;
    });

    return timeList;
  }

  // ---------- Helpers ----------
  void _resetForm() {
    _formKey.currentState?.reset();
    for (final c in [
      uhidController,
      mobileController,
      nameController,
      genderController,
      yearController,
      monthController,
      dayController,
      addressController
    ]) {
      c.clear();
    }
    setState(() {
      selectedDepartment = null;
      selectedDoctor = null;
      selectedDate = null;
      selectedTime = null;
      doctors.clear();
    });
  }

  bool _validateForm() {
    return selectedDepartment != null &&
        selectedDoctor != null &&
        selectedDate != null &&
        selectedTime != null &&
        nameController.text.trim().isNotEmpty &&
        uhidController.text.trim().isNotEmpty &&
        mobileController.text.trim().isNotEmpty &&
        genderController.text.trim().isNotEmpty &&
        yearController.text.trim().isNotEmpty &&
        monthController.text.trim().isNotEmpty &&
        dayController.text.trim().isNotEmpty &&
        addressController.text.trim().isNotEmpty;
  }

  String _dateToChip(DateTime? d) =>
      d == null ? '—' : DateFormat('EEE, dd MMM').format(d);

  String _timeToChip(TimeOfDay? t) {
    if (t == null) return '—';
    final dt = DateTime(0, 1, 1, t.hour, t.minute);
    return DateFormat('h:mm a').format(dt);
  }

  String _dobText() {
    final y = yearController.text,
        m = monthController.text,
        d = dayController.text;
    if (y.isEmpty || m.isEmpty || d.isEmpty) return '—';
    return '$d $m, $y';
  }

  String _doctorText() => selectedDoctor?.values.first ?? '—';
  String _deptText() => selectedDepartment?.values.first ?? '—';

  // ---------- UI ----------
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width > 720;
    final valid = _validateForm();

    return SliverToBoxAdapter(
      child: Stack(
        children: [
          Column(
            children: [

              const SizedBox(height: 14),

              // ===== Form Card =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SectionCard(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _sectionHeader('Visit Details'),
                            _softButton(
                              label: "Reset",
                              icon: Icons.refresh_rounded,
                              color: Colors.red,
                              onTap: _resetForm,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _grid(
                          isWide: isWide,
                          children: [
                            _fieldShell(
                              label: "Department",
                              child: CommonSearchableDropdown<Map<int, String>>(
                                items: (filter, _) async {
                                  if (filter.isEmpty) return departments;
                                  return departments.where((dept) {
                                    final v = dept.values.first.toLowerCase();
                                    return v.contains(filter.toLowerCase());
                                  }).toList();
                                },
                                hintText: "Select Department",
                                selectedItem: selectedDepartment,
                                onChanged: (val) {
                                  setState(() {
                                    selectedDepartment = val;
                                    selectedDoctor = null;
                                    selectedDate = null;
                                    selectedTime = null;
                                    doctors.clear();
                                  });
                                  if (val != null) {
                                    getDoctorsData(val.keys.first);
                                  }
                                },
                                itemAsString: (item) => item.values.first,
                                compareFn: (a, b) =>
                                    a.keys.first == b.keys.first,
                                validator: (v) => v == null ? 'Required' : null,
                              ),
                            ),
                            _fieldShell(
                              label: "Doctor *",
                              child: CommonSearchableDropdown<Map<int, String>>(
                                items: (filter, _) => doctors,
                                hintText: "Select Doctor",
                                selectedItem: selectedDoctor,
                                onChanged: (val) async {
                                  setState(() {
                                    selectedDoctor = val;
                                    selectedDate = null;
                                    selectedTime = null;
                                  });
                                  if (val != null) {
                                    print("Call getScheduleData()");
                                    await getScheduleData();
                                  }
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (_) => DateTimePopup(
                                      onDateTimeSelected: (date, time) {
                                        setState(() {
                                          selectedDate = date;
                                          selectedTime = time.formatTime();
                                        });
                                      },
                                      dateList: dateList,
                                      getTimeList: getTimeslotData,
                                    ),
                                  );
                                },
                                enabled: selectedDepartment != null &&
                                    doctors.isNotEmpty,
                                itemAsString: (item) => item.values.first,
                                compareFn: (a, b) =>
                                    a.keys.first == b.keys.first,
                                validator: (v) => v == null ? 'Required' : null,
                              ),
                            ),
                            _fieldShell(
                              label: "Appointment Date *",
                              child: TextFormField(
                                readOnly: true,
                                enabled: false,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                                decoration: _inputDecoration(
                                  hint: "Select appointment date",
                                  suffixIcon: const Icon(Icons.calendar_today,
                                      color: Colors.blue, size: 20),
                                ),
                                controller: TextEditingController(
                                  text: selectedDate != null
                                      ? DateFormat('dd/MM/yyyy')
                                          .format(selectedDate!)
                                      : "",
                                ),
                                validator: (val) => (val == null || val.isEmpty)
                                    ? "Required"
                                    : null,
                              ),
                            ),
                            _fieldShell(
                              label: "Slot Time *",
                              child: TextFormField(
                                readOnly: true,
                                enabled: false,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                                decoration: _inputDecoration(
                                  hint: "Select slot time",
                                  suffixIcon: const Icon(Icons.access_time,
                                      color: Colors.blue, size: 20),
                                ),
                                controller: TextEditingController(
                                  text: selectedTime ?? "",
                                ),
                                validator: (val) => (val == null || val.isEmpty)
                                    ? "Required"
                                    : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _divider(),
                        const SizedBox(height: 10),
                        _sectionHeader('Patient Identity'),
                        const SizedBox(height: 12),
                        _grid(
                          isWide: isWide,
                          children: [
                            _fieldShell(
                              label: 'UHID',
                              child: TextFormField(
                                controller: uhidController,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                                decoration:
                                    _inputDecoration(hint: "Enter UHID"),
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                        ? 'Required'
                                        : null,
                              ),
                            ),
                            _fieldShell(
                              label: 'Mobile No.',
                              child: TextFormField(
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                                controller: mobileController,
                                keyboardType: TextInputType.phone,
                                decoration: _inputDecoration(
                                    hint: "Enter mobile number"),
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                        ? 'Required'
                                        : null,
                              ),
                            ),
                            _fieldShell(
                              label: 'Name *',
                              child: TextFormField(
                                controller: nameController,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                                decoration:
                                    _inputDecoration(hint: "Enter full name"),
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                        ? 'Required'
                                        : null,
                              ),
                            ),
                            _fieldShell(
                              label: 'Gender *',
                              child: CommonSearchableDropdown<String>(
                                items: (filter, _) =>
                                    ["Male", "Female", "Other"],
                                hintText: "Select gender",
                                selectedItem: genderController.text.isNotEmpty
                                    ? genderController.text
                                    : null,
                                onChanged: (val) =>
                                    genderController.text = val ?? "",
                                validator: (val) => (val == null || val.isEmpty)
                                    ? "Required"
                                    : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _divider(),
                        const SizedBox(height: 10),
                        _sectionHeader('Date of Birth'),
                        const SizedBox(height: 12),
                        _grid(
                          isWide: isWide,
                          children: [
                            _fieldShell(
                              label: 'Year',
                              child: CommonSearchableDropdown<int>(
                                  items: (filter, _) {
                                    final nowYear = DateTime.now().year;
                                    final years = List.generate(
                                        201, (i) => nowYear - 100 + i);
                                    return years.toList();
                                  },
                                  hintText: "Select year",
                                  selectedItem: yearController.text.isNotEmpty
                                      ? int.tryParse(yearController.text)
                                      : null,
                                  onChanged: (val) {
                                    yearController.text = val?.toString() ?? "";
                                    setState(() {});
                                  }),
                            ),
                            _fieldShell(
                              label: 'Month',
                              child: CommonSearchableDropdown<String>(
                                  items: (filter, _) => const [
                                        "January",
                                        "February",
                                        "March",
                                        "April",
                                        "May",
                                        "June",
                                        "July",
                                        "August",
                                        "September",
                                        "October",
                                        "November",
                                        "December"
                                      ],
                                  hintText: "Select month",
                                  selectedItem: monthController.text.isNotEmpty
                                      ? monthController.text
                                      : null,
                                  onChanged: (val) {
                                    monthController.text = val ?? "";
                                    setState(() {});
                                  }),
                            ),
                            _fieldShell(
                              label: 'Day',
                              child: StatefulBuilder(
                                builder: (context, setInner) {
                                  int? selectedYear =
                                      int.tryParse(yearController.text);
                                  int monthIndex = const [
                                        "January",
                                        "February",
                                        "March",
                                        "April",
                                        "May",
                                        "June",
                                        "July",
                                        "August",
                                        "September",
                                        "October",
                                        "November",
                                        "December"
                                      ].indexOf(monthController.text) +
                                      1;

                                  int daysInMonth = 31;
                                  if (selectedYear != null && monthIndex > 0) {
                                    final firstDayNextMonth = (monthIndex == 12)
                                        ? DateTime(selectedYear + 1, 1, 1)
                                        : DateTime(
                                            selectedYear, monthIndex + 1, 1);
                                    final lastDayThisMonth = firstDayNextMonth
                                        .subtract(const Duration(days: 1));
                                    daysInMonth = lastDayThisMonth.day;
                                  }
                                  final days = List.generate(
                                      daysInMonth, (i) => (i + 1).toString());

                                  return CommonSearchableDropdown<String>(
                                    items: (filter, _) => days,
                                    hintText: "Select day",
                                    selectedItem: dayController.text.isNotEmpty
                                        ? dayController.text
                                        : null,
                                    onChanged: (val) {
                                      dayController.text = val ?? "";
                                      setState(() {});
                                    },
                                  );
                                },
                              ),
                            ),
                            _fieldShell(
                              label: 'Selected DOB',
                              child: TextFormField(
                                readOnly: true,
                                enabled: false,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                                decoration: _inputDecoration(hint: "—"),
                                controller:
                                    TextEditingController(text: _dobText()),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _divider(),
                        const SizedBox(height: 10),
                        _sectionHeader('Address'),
                        const SizedBox(height: 12),
                        _fieldShell(
                          label: 'Full Address',
                          child: TextFormField(
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                            controller: addressController,
                            maxLines: 2,
                            decoration: _inputDecoration(hint: "Enter address"),
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Required'
                                : null,
                          ),
                        ),
                        const SizedBox(height: 12), // space for sticky submit
                        // ===== Sticky Submit Bar =====
                        _StickySubmitBar(
                          valid: valid,
                          department: _deptText(),
                          doctor: _doctorText(),
                          date: _dateToChip(selectedDate),
                          time: selectedTime ?? "",
                          onSubmit: () {
                            HapticFeedback.selectionClick();
                            if (_formKey.currentState?.validate() ?? false) {
                              if (!valid) {
                                _snack(context,
                                    'Please complete all required fields');
                                return;
                              }
                              _snack(context, 'Appointment submitted ✅');
                              // TODO: integrate submit usecase here.
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // ===== Loading overlay =====
          if (isLoading)
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: 1,
                  child: Container(
                    color: Colors.white.withOpacity(0.25),
                    child: const Center(child: _Spinner()),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ----- layout helpers -----
  static Widget _grid({
    required bool isWide,
    required List<Widget> children,
  }) {
    final items = children;
    if (!isWide) {
      return Column(
        children: [
          for (final w in items) ...[w, const SizedBox(height: 14)]
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              for (int i = 0; i < items.length; i += 2) ...[
                items[i],
                const SizedBox(height: 14),
              ]
            ],
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            children: [
              for (int i = 1; i < items.length; i += 2) ...[
                items[i],
                const SizedBox(height: 14),
              ]
            ],
          ),
        ),
      ],
    );
  }

  static Widget _fieldShell({
    required String label,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            )),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  static InputDecoration _inputDecoration(
      {required String hint, Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hint,
      suffixIcon: suffixIcon != null
          ? Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: suffixIcon,
            )
          : null,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.blue, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
    );
  }

  static Widget _sectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF7F5AF0),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }

  static Widget _divider() => Container(
        height: 1,
        margin: const EdgeInsets.only(right: 40),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black.withOpacity(0.06), Colors.transparent],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
      );

  static Widget _tag(IconData icon, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 14, color: Colors.blueGrey),
        const SizedBox(width: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w800,
            color: Colors.black87,
          ),
        ),
      ]),
    );
  }

  static Widget _softButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.10),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.35)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void _snack(BuildContext context, String msg) {
    final m = ScaffoldMessenger.maybeOf(context);
    if (m == null) return;
    m.clearSnackBars();
    m.showSnackBar(SnackBar(
      content: Text(msg),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(milliseconds: 1400),
    ));
  }
}

// ======= Section Card (glassy white) =======
class SectionCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  const SectionCard(
      {super.key,
      required this.child,
      this.padding = const EdgeInsets.all(16)});

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(18);
    return Container(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.65),
            blurRadius: 6,
            offset: const Offset(-3, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.82),
              borderRadius: radius,
              border:
                  Border.all(color: Colors.white.withOpacity(0.6), width: 1),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.95),
                  Colors.white.withOpacity(0.7)
                ],
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

// ======= Sticky bottom bar =======
class _StickySubmitBar extends StatelessWidget {
  final bool valid;
  final String department;
  final String doctor;
  final String date;
  final String time;
  final VoidCallback onSubmit;

  const _StickySubmitBar({
    required this.valid,
    required this.department,
    required this.doctor,
    required this.date,
    required this.time,
    required this.onSubmit,
  });
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 14,
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.92),
          border: Border(
            top: BorderSide(color: Colors.black.withOpacity(0.06)),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.10),
              blurRadius: 18,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 6,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _chip(icon: Icons.apartment, text: department),
                _chip(icon: Icons.person, text: doctor),
                _chip(icon: Icons.calendar_month, text: date),
                _chip(icon: Icons.access_time, text: time),
              ],
            ),
            const SizedBox(height: 12),
            Opacity(
              opacity: valid ? 1 : 0.6,
              child: ElevatedButton.icon(
                onPressed: valid ? onSubmit : null,
                icon: const Icon(Icons.check_circle_rounded),
                label: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                  child: Text(
                    'Submit',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7F5AF0),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _chip({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 14, color: Colors.blueGrey),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w800,
            color: Colors.black87,
          ),
        ),
      ]),
    );
  }
}

// ======= Spinner =======
class _Spinner extends StatefulWidget {
  const _Spinner();

  @override
  State<_Spinner> createState() => _SpinnerState();
}

class _SpinnerState extends State<_Spinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController c = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 900))
    ..repeat();

  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: c,
      builder: (_, __) => Transform.rotate(
        angle: c.value * 2 * pi,
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.indigo.withOpacity(0.5), width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}

// ======= Date & Time Dialog =======
class DateTimePopup extends StatefulWidget {
  const DateTimePopup(
      {super.key,
      required this.onDateTimeSelected,
      required this.dateList,
      required this.getTimeList});
  final void Function(DateTime, SlotSelectionModel) onDateTimeSelected;
  final List<DateTime> dateList;
  final Future<List<SlotSelectionModel>> Function(DateTime) getTimeList;

  @override
  State<DateTimePopup> createState() => _DateTimePopupState();
}

class _DateTimePopupState extends State<DateTimePopup> {
  final ScrollController _dateScrollController = ScrollController();
  // final List<DateTime> _dates = widget.dateList;

  DateTime? _selectedDate;
  SlotSelectionModel? _selectedTimeSlot;

  List<SlotSelectionModel> timeList = [];
  // void _scrollDates(bool forward) {
  //   const offset = 150.0;
  //   final newOffset =
  //   forward ? _dateScrollController.offset + offset : _dateScrollController.offset - offset;
  //   _dateScrollController.animateTo(
  //     newOffset.clamp(0, _dateScrollController.position.maxScrollExtent),
  //     duration: const Duration(milliseconds: 400),
  //     curve: Curves.easeOut,
  //   );
  // }

  int _startIndex = 0;
  void _scrollDates(bool forward) {
    setState(() {
      if (forward) {
        if (_startIndex < widget.dateList.length - 4) {
          _startIndex++;
        }
      } else {
        if (_startIndex > 0) {
          _startIndex--;
        }
      }
    });
  }

  void _onDateSelected(DateTime date) async {
    timeList = await widget.getTimeList(date);
    setState(() {
      _selectedDate = date;
      _selectedTimeSlot = null;
    });
  }

  void _onTimeSlotSelected(int timeSlotIndex) =>
      setState(() => _selectedTimeSlot = timeList[timeSlotIndex]);

  void _confirmSelection() {
    if (_selectedDate != null && _selectedTimeSlot != null) {
      try {
        widget.onDateTimeSelected(_selectedDate!, _selectedTimeSlot!);
        Navigator.of(context).pop();
      } catch (_) {
        _snack("Invalid time format: $_selectedTimeSlot");
      }
    } else {
      _snack("Please select a date and time.");
    }
  }

  void _snack(String msg) {
    final m = ScaffoldMessenger.maybeOf(context);
    if (m == null) return;
    m.clearSnackBars();
    m.showSnackBar(SnackBar(
      content: Text(msg),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 2),
    ));
  }

  Widget _buildDateGrid(ThemeData theme) {
    final visibleDates = widget.dateList.skip(_startIndex).take(4).toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 per row
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 2.2,
      ),
      itemCount: visibleDates.length,
      itemBuilder: (context, index) {
        final date = visibleDates[index];
        final isSelected = _selectedDate == date;
        return GestureDetector(
          onTap: () => _onDateSelected(date),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: isSelected
                  ? theme.colorScheme.primary.withOpacity(0.8)
                  : Colors.white.withOpacity(0.3),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    "${date.day}/${date.month}/${date.year}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12, // Reduced from 14 to prevent overflow
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 2), // Reduced spacing
                Flexible(
                  child: Text(
                    [
                      "Mon",
                      "Tue",
                      "Wed",
                      "Thu",
                      "Fri",
                      "Sat",
                      "Sun"
                    ][date.weekday - 1], // Fixed: weekday is 1-7, array is 0-6
                    style: TextStyle(
                      fontSize: 10, // Reduced from 12
                      color: isSelected
                          ? Colors.white.withOpacity(0.9)
                          : Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            color: Colors.white.withOpacity(0.9),
            child: CustomScrollView(
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
                      border: Border(
                          bottom: BorderSide(
                              color: Colors.black.withOpacity(0.06))),
                    ),
                    child: Row(
                      children: [
                        const Text(
                          "Select Date & Time",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87),
                        ),
                        const Spacer(),
                        IconButton.filledTonal(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close, size: 20),
                          style: IconButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // DATE SELECTOR
                SliverToBoxAdapter(
                    child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  child: Row(
                    children: [
                      IconButton.filledTonal(
                        onPressed: () => _scrollDates(false),
                        icon: const Icon(Icons.arrow_back_ios, size: 18, weight: 30, ),
                      ),
                      Expanded(
                        child: _buildDateGrid(theme),
                      ),
                      IconButton.filledTonal(
                        onPressed: () => _scrollDates(true),
                        icon: const Icon(Icons.arrow_forward_ios, size: 18,  weight: 30),
                      ),
                    ],
                  ),
                )),

                // Slots
                if (timeList.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text(
                        "Select a date to view available times",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final slot = timeList[index].id;
                          final isSelected = _selectedTimeSlot?.id == slot;
                          return GestureDetector(
                            onTap: () => _onTimeSlotSelected(index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              curve: Curves.easeOut,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: isSelected
                                    ? theme.colorScheme.primary.withOpacity(0.9)
                                    : Colors.white,
                                border: Border.all(
                                  color: isSelected
                                      ? theme.colorScheme.primary
                                      : Colors.black.withOpacity(0.08),
                                ),
                                boxShadow: [
                                  if (isSelected)
                                    BoxShadow(
                                      color: theme.colorScheme.primary
                                          .withOpacity(0.22),
                                      blurRadius: 16,
                                      offset: const Offset(0, 8),
                                    ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  '${timeList[index].fromTime!} - ${timeList[index].toTime!}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        childCount: timeList.length,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 2.6,
                      ),
                    ),
                  ),

                // Confirm
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      onPressed: _confirmSelection,
                      icon: const Icon(Icons.check_circle_outline_rounded),
                      label: const Text("Confirm",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w900)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
