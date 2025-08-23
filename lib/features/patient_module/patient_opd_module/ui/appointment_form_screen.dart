import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/resource.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/status.dart';
import 'package:jnm_hospital_app/features/admin_report_module/common_widgets/searchable_dropdown.dart';
import 'package:jnm_hospital_app/features/patient_module/patient_details_module/ui/common_layout.dart';
import 'package:jnm_hospital_app/features/patient_module/patient_opd_module/data/patient_opd_usecases_impl.dart';
import 'dart:math';
import 'dart:ui';

class AppointmentFormScreen extends StatelessWidget {
  const AppointmentFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PatientDetailsScreenLayout(
      heading: "Appointment Form",
      child: const _AppointmentForm(),
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
  TimeOfDay? selectedTime;

  // Dummy data for dropdowns
  final List<Map<int, String>> departments = [];
  final List<Map<int, String>> doctors = [];

  bool isLoading = false;

  void _resetForm() {
    _formKey.currentState?.reset();
    uhidController.clear();
    mobileController.clear();
    nameController.clear();
    genderController.clear();
    yearController.clear();
    monthController.clear();
    dayController.clear();
    addressController.clear();
    setState(() {
      selectedDepartment = null;
      selectedDoctor = null;
      selectedDate = null;
      selectedTime = null;
    });
  }

  void initState() {
    super.initState();
    getDepartmentsData();
  }

  void getDepartmentsData() async {
    setState(() {
      isLoading = true;
    });
    PatientOPDUsecasesImpl patientOPDUsecasesImpl = PatientOPDUsecasesImpl();
    Resource resource = await patientOPDUsecasesImpl.getOPDDepartments();
    if (resource.status == STATUS.SUCCESS) {
      // Handle successful response
      print("Success");
      final response = resource.data as List;
      response.forEach((dept) {
        final id = dept['id'] as int;
        final name = dept['department_name'] as String;
        departments.add({id: name});
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

  void getDoctorsData(int selectedDeptId) async {
    setState(() {
      isLoading = true;
    });
    PatientOPDUsecasesImpl patientOPDUsecasesImpl = PatientOPDUsecasesImpl();
    Resource resource =
        await patientOPDUsecasesImpl.getOPDDoctors(selectedDeptId);
    if (resource.status == STATUS.SUCCESS) {
      // Handle successful response
      print("Success");
      final response = resource.data as List;
      print(response);
      response.forEach((deptDoct) {
        final id = deptDoct['id'] as int;
        final name = deptDoct['name'] as String;
        doctors.add({id: name});
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

  bool _validateForm() {
    return selectedDoctor != null &&
        selectedDate != null &&
        selectedTime != null &&
        (nameController.text.isNotEmpty) &&
        (uhidController.text.isNotEmpty) &&
        (mobileController.text.isNotEmpty) &&
        (genderController.text.isNotEmpty) &&
        (yearController.text.isNotEmpty) &&
        (monthController.text.isNotEmpty) &&
        (dayController.text.isNotEmpty) &&
        (addressController.text.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverToBoxAdapter(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.withOpacity(0.8),
                    ),
                    onPressed: _resetForm,
                    icon: const Icon(
                      Icons.refresh,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "Reset",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Department dropdown
              CommonSearchableDropdown<Map<int, String>>(
                items: (filter, props) async {
                  // simple filtering
                  if (filter.isEmpty) return departments;
                  return departments.where((dept) {
                    final value = dept.values.first.toLowerCase();
                    return value.contains(filter.toLowerCase());
                  }).toList();
                },
                hintText: "Department",
                selectedItem: selectedDepartment,
                onChanged: (val) {
                  setState(() {
                    selectedDoctor = null;
                    selectedDate = null;
                    selectedTime = null;
                    selectedDepartment = val;
                  });
                  getDoctorsData(selectedDepartment!.keys.first);
                },
                itemAsString: (item) => item.values.first,
                compareFn: (a, b) => a.keys.first == b.keys.first,
              ),
              const SizedBox(height: 16),

              // Doctor dropdown
              CommonSearchableDropdown<Map<int, String>>(
                items: (filter, props) => doctors,
                hintText: "Doctor *",
                selectedItem: selectedDoctor,
                onChanged: (val) {
                  setState(() {
                    selectedDate = null;
                    selectedTime = null;
                    selectedDoctor = val;
                  });
                  showDialog(
                    context: context,
                    builder: (_) => DateTimePopup(
                      onDateTimeSelected: (date, time) {
                        setState(() {
                          selectedDate = date;
                          selectedTime = time;
                        });
                      },
                    ),
                  );
                },
                itemAsString: (item) => item.values.first,
                validator: (val) => val == null ? "Required" : null,
                compareFn: (a, b) => a.keys.first == b.keys.first,
                enabled: selectedDepartment != null && doctors.isNotEmpty,
              ),
              const SizedBox(height: 16),

              TextFormField(
                readOnly: true,
                enabled: false,
                decoration: InputDecoration(
                  labelText: "Appointment Date *",
                  labelStyle: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  suffixIcon: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.calendar_today,
                      color: Colors.blue,
                      size: 20,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
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
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  hintText: "Select appointment date",
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                  // Add a subtle shadow effect
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                ),
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
                controller: TextEditingController(
                  text: selectedDate != null
                      ? "${selectedDate!.day.toString().padLeft(2, '0')}/${selectedDate!.month.toString().padLeft(2, '0')}/${selectedDate!.year}"
                      : "",
                ),
                onTap: () async {
                  // final picked = await showDatePicker(
                  //   context: context,
                  //   firstDate: DateTime.now(),
                  //   lastDate: DateTime(2100),
                  //   initialDate: selectedDate ?? DateTime.now(),
                  //   builder: (context, child) {
                  //     return Theme(
                  //       data: Theme.of(context).copyWith(
                  //         colorScheme: Theme.of(context).colorScheme.copyWith(
                  //               primary: Colors.blue,
                  //               onPrimary: Colors.white,
                  //               surface: Colors.white,
                  //               onSurface: Colors.black87,
                  //             ),
                  //         dialogBackgroundColor: Colors.white,
                  //       ),
                  //       child: child!,
                  //     );
                  //   },
                  // );
                  // if (picked != null) {
                  //   setState(() => selectedDate = picked);
                  // }
                },
                validator: (val) =>
                    val == null || val.isEmpty ? "Please select a date" : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                readOnly: true,
                enabled: false,
                decoration: buildInputDecoration(
                  label: "Slot Time *",
                  hint: "Select slot time",
                  suffixIcon: const Icon(Icons.access_time,
                      color: Colors.blue, size: 20),
                ),
                controller: TextEditingController(
                  text:
                      selectedTime != null ? selectedTime!.format(context) : "",
                ),
                onTap: () async {
                  // final picked = await showTimePicker(
                  //   context: context,
                  //   initialTime: TimeOfDay.now(),
                  // );
                  // if (picked != null) {
                  //   setState(() => selectedTime = picked);
                  // }
                },
                validator: (val) =>
                    val == null || val.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 16),

              // UHID
              TextFormField(
                controller: uhidController,
                decoration:
                    buildInputDecoration(label: "UHID", hint: "Enter UHID"),
              ),
              const SizedBox(height: 16),

              // Mobile No
              TextFormField(
                controller: mobileController,
                keyboardType: TextInputType.phone,
                decoration: buildInputDecoration(
                    label: "Mobile No.", hint: "Enter mobile number"),
              ),
              const SizedBox(height: 16),

              // Name
              TextFormField(
                controller: nameController,
                decoration: buildInputDecoration(
                    label: "Name *", hint: "Enter full name"),
                validator: (val) =>
                    val == null || val.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 16),

              // Gender
              // Gender dropdown (simple fixed list)
              CommonSearchableDropdown<String>(
                items: (filter, _) => ["Male", "Female", "Other"],
                hintText: "Gender *",
                selectedItem: genderController.text.isNotEmpty
                    ? genderController.text
                    : null,
                onChanged: (val) {
                  genderController.text = val ?? "";
                },
                validator: (val) =>
                    val == null || val.isEmpty ? "Required" : null,
              ),

              const SizedBox(height: 16),

// Year dropdown (±100 years from today)
              CommonSearchableDropdown<int>(
                items: (filter, _) {
                  final nowYear = DateTime.now().year;
                  final years = List.generate(201, (i) => nowYear - 100 + i);
                  return years.reversed.toList(); // most recent first
                },
                hintText: "Year",
                selectedItem: yearController.text.isNotEmpty
                    ? int.tryParse(yearController.text)
                    : null,
                onChanged: (val) {
                  yearController.text = val?.toString() ?? "";
                },
              ),

              const SizedBox(height: 16),

// Month dropdown (1–12)
              CommonSearchableDropdown<String>(
                items: (filter, _) => [
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
                hintText: "Month",
                selectedItem: monthController.text.isNotEmpty
                    ? monthController.text
                    : null,
                onChanged: (val) {
                  monthController.text = val ?? "";
                },
              ),

              const SizedBox(height: 16),

// Day dropdown (depends on month + year)
              StatefulBuilder(
                builder: (context, setState) {
                  int? selectedYear = int.tryParse(yearController.text);
                  int monthIndex = [
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

                  // Calculate days in month
                  int daysInMonth = 31;
                  if (selectedYear != null && monthIndex > 0) {
                    final firstDayNextMonth = (monthIndex == 12)
                        ? DateTime(selectedYear + 1, 1, 1)
                        : DateTime(selectedYear, monthIndex + 1, 1);
                    final lastDayThisMonth =
                        firstDayNextMonth.subtract(const Duration(days: 1));
                    daysInMonth = lastDayThisMonth.day;
                  }

                  final days =
                      List.generate(daysInMonth, (i) => (i + 1).toString());

                  return CommonSearchableDropdown<String>(
                    items: (filter, _) => days,
                    hintText: "Day",
                    selectedItem: dayController.text.isNotEmpty
                        ? dayController.text
                        : null,
                    onChanged: (val) {
                      dayController.text = val ?? "";
                      setState(() {}); // refresh if needed
                    },
                  );
                },
              ),

              const SizedBox(height: 16),

              // Address
              TextFormField(
                controller: addressController,
                maxLines: 2,
                decoration: buildInputDecoration(
                    label: "Address", hint: "Enter address"),
              ),
              const SizedBox(height: 16),
              _PrimaryButton(
                label: 'Submit',
                enabled: _validateForm(),
                accent: Color(0xFF00C2FF),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback onTap;
  final Color accent;

  const _PrimaryButton({
    required this.label,
    required this.enabled,
    required this.onTap,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(16);

    return Opacity(
      opacity: enabled ? 1 : 0.6,
      child: GestureDetector(
        onTap: enabled
            ? () {
                HapticFeedback.selectionClick();
                onTap();
              }
            : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: radius,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                accent,
                const Color(0xFF7F5AF0),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7F5AF0).withOpacity(0.25),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.sms_rounded, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

InputDecoration buildInputDecoration({
  required String label,
  String? hint,
  Widget? suffixIcon,
}) {
  return InputDecoration(
    labelText: label,
    labelStyle: TextStyle(
      color: Colors.grey[700],
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    suffixIcon: suffixIcon != null
        ? Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: suffixIcon,
          )
        : null,
    filled: true,
    fillColor: Colors.white,
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
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    hintText: hint,
    hintStyle: TextStyle(
      color: Colors.grey[400],
      fontSize: 14,
    ),
    floatingLabelBehavior: FloatingLabelBehavior.auto,
  );
}

class DateTimePopup extends StatefulWidget {
  const DateTimePopup({super.key, required this.onDateTimeSelected});

  final void Function(DateTime, TimeOfDay) onDateTimeSelected;
  @override
  State<DateTimePopup> createState() => _DateTimePopupState();
}

class _DateTimePopupState extends State<DateTimePopup> {
  final ScrollController _dateScrollController = ScrollController();
  final List<DateTime> _dates =
      List.generate(14, (i) => DateTime.now().add(Duration(days: i)));

  DateTime? _selectedDate;
  String? _selectedTimeSlot;
  List<String> _timeSlots = [];

  void _scrollDates(bool forward) {
    const offset = 150.0;
    final newOffset = forward
        ? _dateScrollController.offset + offset
        : _dateScrollController.offset - offset;
    _dateScrollController.animateTo(
      newOffset.clamp(0, _dateScrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
      _selectedTimeSlot = null; // Reset time selection when date changes
      _timeSlots = List.generate(
        5,
        (i) =>
            "${10 + Random().nextInt(6)}:${Random().nextBool() ? "00" : "30"} ${Random().nextBool() ? "AM" : "PM"}",
      );
    });
  }

  void _onTimeSlotSelected(String timeSlot) {
    setState(() {
      _selectedTimeSlot = timeSlot;
    });
    print(timeSlot);
  }

  void _confirmSelection() {
    if (_selectedDate != null && _selectedTimeSlot != null) {
      try {
        // Normalize string (remove extra spaces, force uppercase)
        final timeString = _selectedTimeSlot!.trim().toUpperCase();

        // Parse with intl
        final parsedTime = DateFormat("h:mm a").parse(timeString);

        // Convert to TimeOfDay
        final timeOfDay = TimeOfDay.fromDateTime(parsedTime);

        // Pass back to parent
        widget.onDateTimeSelected(_selectedDate!, timeOfDay);
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Invalid time format: $_selectedTimeSlot"),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a date and time."),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: const Color.fromARGB(0, 238, 233, 233),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            color: Colors.white.withOpacity(0.8),
            child: CustomScrollView(
              slivers: [
                // HEADER
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
                    color: Colors.white.withOpacity(0.2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Select Date & Time",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close, size: 24),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black.withOpacity(0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // DATE SELECTOR
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    color: Colors.white.withOpacity(0.1),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => _scrollDates(false),
                          icon: const Icon(Icons.arrow_back_ios, size: 18),
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 70,
                            child: ListView.builder(
                              controller: _dateScrollController,
                              scrollDirection: Axis.horizontal,
                              itemCount: _dates.length,
                              itemBuilder: (context, index) {
                                final date = _dates[index];
                                final isSelected = _selectedDate == date;
                                return GestureDetector(
                                  onTap: () => _onDateSelected(date),
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 4),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: isSelected
                                          ? theme.colorScheme.primary
                                              .withOpacity(0.8)
                                          : Colors.white.withOpacity(0.3),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "${date.day}/${date.month}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: isSelected
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          [
                                            "Sun",
                                            "Mon",
                                            "Tue",
                                            "Wed",
                                            "Thu",
                                            "Fri",
                                            "Sat"
                                          ][date.weekday % 7],
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: isSelected
                                                ? Colors.white.withOpacity(0.9)
                                                : Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => _scrollDates(true),
                          icon: const Icon(Icons.arrow_forward_ios, size: 18),
                        ),
                      ],
                    ),
                  ),
                ),

                // TIME SLOTS
                if (_timeSlots.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text(
                        "Select a date to view available times",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final slot = _timeSlots[index];
                          final isSelected = _selectedTimeSlot == slot;
                          return GestureDetector(
                            onTap: () => _onTimeSlotSelected(slot),
                            child: Card(
                              elevation: isSelected ? 4 : 0,
                              color: isSelected
                                  ? theme.colorScheme.primary.withOpacity(0.9)
                                  : Colors.white.withOpacity(0.4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: isSelected
                                    ? BorderSide(
                                        color: theme.colorScheme.primary,
                                        width: 2)
                                    : BorderSide.none,
                              ),
                              child: Center(
                                child: Text(
                                  slot,
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
                        childCount: _timeSlots.length,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 2.5,
                      ),
                    ),
                  ),

                // CONFIRM BUTTON
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: theme.colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _confirmSelection,
                      child: const Text(
                        "Confirm",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
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
