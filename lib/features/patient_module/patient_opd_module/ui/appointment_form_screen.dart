// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';
// import 'package:jnm_hospital_app/core/network/apiHelper/resource.dart';
// import 'package:jnm_hospital_app/core/network/apiHelper/status.dart';
// import 'package:jnm_hospital_app/features/admin_report_module/common_widgets/searchable_dropdown.dart';
// import 'package:jnm_hospital_app/features/patient_module/patient_details_module/ui/common_layout.dart';
// import 'package:jnm_hospital_app/features/patient_module/patient_opd_module/data/patient_opd_usecases_impl.dart';
// import 'dart:math';
// import 'dart:ui';

// class AppointmentFormScreen extends StatelessWidget {
//   const AppointmentFormScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return PatientDetailsScreenLayout(
//       heading: "Appointment Form",
//       child: const _AppointmentForm(),
//     );
//   }
// }

// class _AppointmentForm extends StatefulWidget {
//   const _AppointmentForm({super.key});

//   @override
//   State<_AppointmentForm> createState() => _AppointmentFormState();
// }

// class _AppointmentFormState extends State<_AppointmentForm> {
//   final _formKey = GlobalKey<FormState>();

//   // Controllers
//   final TextEditingController uhidController = TextEditingController();
//   final TextEditingController mobileController = TextEditingController();
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController genderController = TextEditingController();
//   final TextEditingController yearController = TextEditingController();
//   final TextEditingController monthController = TextEditingController();
//   final TextEditingController dayController = TextEditingController();
//   final TextEditingController addressController = TextEditingController();

//   // Dropdown selections
//   Map<int, String>? selectedDepartment;
//   Map<int, String>? selectedDoctor;

//   // Date + Time
//   DateTime? selectedDate;
//   TimeOfDay? selectedTime;

//   // Dummy data for dropdowns
//   final List<Map<int, String>> departments = [];
//   final List<Map<int, String>> doctors = [];
//   List<DateTime> dateList = [];

//   bool isLoading = false;

//   void _resetForm() {
//     _formKey.currentState?.reset();
//     uhidController.clear();
//     mobileController.clear();
//     nameController.clear();
//     genderController.clear();
//     yearController.clear();
//     monthController.clear();
//     dayController.clear();
//     addressController.clear();
//     setState(() {
//       selectedDepartment = null;
//       selectedDoctor = null;
//       selectedDate = null;
//       selectedTime = null;
//     });
//   }

//   void initState() {
//     super.initState();
//     getDepartmentsData();
//   }

//   void getDepartmentsData() async {
//     setState(() {
//       isLoading = true;
//     });
//     PatientOPDUsecasesImpl patientOPDUsecasesImpl = PatientOPDUsecasesImpl();
//     Resource resource = await patientOPDUsecasesImpl.getOPDDepartments();
//     if (resource.status == STATUS.SUCCESS) {
//       // Handle successful response
//       print("Success");
//       final response = resource.data as List;
//       response.forEach((dept) {
//         final id = dept['id'] as int;
//         final name = dept['department_name'] as String;
//         departments.add({id: name});
//       });
//       setState(() {});
//     } else {
//       // Handle error
//       print("Error: ${resource.message}");
//     }
//     setState(() {
//       isLoading = false;
//     });
//   }


//   bool _validateForm() {
//     return selectedDoctor != null &&
//         selectedDate != null &&
//         selectedTime != null &&
//         (nameController.text.isNotEmpty) &&
//         (uhidController.text.isNotEmpty) &&
//         (mobileController.text.isNotEmpty) &&
//         (genderController.text.isNotEmpty) &&
//         (yearController.text.isNotEmpty) &&
//         (monthController.text.isNotEmpty) &&
//         (dayController.text.isNotEmpty) &&
//         (addressController.text.isNotEmpty);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return SliverPadding(
//       padding: const EdgeInsets.all(16),
//       sliver: SliverToBoxAdapter(
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   ElevatedButton.icon(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.red.withOpacity(0.8),
//                     ),
//                     onPressed: _resetForm,
//                     icon: const Icon(
//                       Icons.refresh,
//                       color: Colors.white,
//                     ),
//                     label: const Text(
//                       "Reset",
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               // Department dropdown
//               CommonSearchableDropdown<Map<int, String>>(
//                 items: (filter, props) async {
//                   // simple filtering
//                   if (filter.isEmpty) return departments;
//                   return departments.where((dept) {
//                     final value = dept.values.first.toLowerCase();
//                     return value.contains(filter.toLowerCase());
//                   }).toList();
//                 },
//                 hintText: "Department",
//                 selectedItem: selectedDepartment,
//                 onChanged: (val) {
//                   setState(() {
//                     selectedDoctor = null;
//                     selectedDate = null;
//                     selectedTime = null;
//                     selectedDepartment = val;
//                   });
//                   getDoctorsData(selectedDepartment!.keys.first);
//                 },
//                 itemAsString: (item) => item.values.first,
//                 compareFn: (a, b) => a.keys.first == b.keys.first,
//               ),
//               const SizedBox(height: 16),

//               // Doctor dropdown
//               CommonSearchableDropdown<Map<int, String>>(
//                 items: (filter, props) => doctors,
//                 hintText: "Doctor *",
//                 selectedItem: selectedDoctor,
//                 onChanged: (val) {
//                   setState(() {
//                     selectedDate = null;
//                     selectedTime = null;
//                     selectedDoctor = val;
//                   });
//                   showDialog(
//                     context: context,
//                     builder: (_) => DateTimePopup(
//                       onDateTimeSelected: (date, time) {
//                         setState(() {
//                           selectedDate = date;
//                           selectedTime = time;
//                         });
//                       },
//                       dateList: dateList,
//                       getTimeList: getTimeslotData,
//                     ),
//                   );
//                 },
//                 itemAsString: (item) => item.values.first,
//                 validator: (val) => val == null ? "Required" : null,
//                 compareFn: (a, b) => a.keys.first == b.keys.first,
//                 enabled: selectedDepartment != null && doctors.isNotEmpty,
//               ),
//               const SizedBox(height: 16),

//               TextFormField(
//                 readOnly: true,
//                 enabled: false,
//                 decoration: InputDecoration(
//                   labelText: "Appointment Date *",
//                   labelStyle: TextStyle(
//                     color: Colors.grey[700],
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                   ),
//                   suffixIcon: Container(
//                     margin: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: Colors.blue.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: const Icon(
//                       Icons.calendar_today,
//                       color: Colors.blue,
//                       size: 20,
//                     ),
//                   ),
//                   filled: true,
//                   fillColor: Colors.white,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: const BorderSide(color: Colors.blue, width: 2),
//                   ),
//                   errorBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: const BorderSide(color: Colors.red, width: 1),
//                   ),
//                   focusedErrorBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: const BorderSide(color: Colors.red, width: 2),
//                   ),
//                   contentPadding:
//                       const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//                   hintText: "Select appointment date",
//                   hintStyle: TextStyle(
//                     color: Colors.grey[400],
//                     fontSize: 14,
//                   ),
//                   // Add a subtle shadow effect
//                   floatingLabelBehavior: FloatingLabelBehavior.auto,
//                 ),
//                 style: const TextStyle(
//                   fontSize: 16,
//                   color: Colors.black87,
//                   fontWeight: FontWeight.w500,
//                 ),
//                 controller: TextEditingController(
//                   text: selectedDate != null
//                       ? "${selectedDate!.day.toString().padLeft(2, '0')}/${selectedDate!.month.toString().padLeft(2, '0')}/${selectedDate!.year}"
//                       : "",
//                 ),
//                 onTap: () async {
//                   // final picked = await showDatePicker(
//                   //   context: context,
//                   //   firstDate: DateTime.now(),
//                   //   lastDate: DateTime(2100),
//                   //   initialDate: selectedDate ?? DateTime.now(),
//                   //   builder: (context, child) {
//                   //     return Theme(
//                   //       data: Theme.of(context).copyWith(
//                   //         colorScheme: Theme.of(context).colorScheme.copyWith(
//                   //               primary: Colors.blue,
//                   //               onPrimary: Colors.white,
//                   //               surface: Colors.white,
//                   //               onSurface: Colors.black87,
//                   //             ),
//                   //         dialogBackgroundColor: Colors.white,
//                   //       ),
//                   //       child: child!,
//                   //     );
//                   //   },
//                   // );
//                   // if (picked != null) {
//                   //   setState(() => selectedDate = picked);
//                   // }
//                 },
//                 validator: (val) =>
//                     val == null || val.isEmpty ? "Please select a date" : null,
//               ),
//               const SizedBox(height: 16),

//               TextFormField(
//                 readOnly: true,
//                 enabled: false,
//                 decoration: buildInputDecoration(
//                   label: "Slot Time *",
//                   hint: "Select slot time",
//                   suffixIcon: const Icon(Icons.access_time,
//                       color: Colors.blue, size: 20),
//                 ),
//                 controller: TextEditingController(
//                   text:
//                       selectedTime != null ? selectedTime!.format(context) : "",
//                 ),
//                 onTap: () async {
//                   // final picked = await showTimePicker(
//                   //   context: context,
//                   //   initialTime: TimeOfDay.now(),
//                   // );
//                   // if (picked != null) {
//                   //   setState(() => selectedTime = picked);
//                   // }
//                 },
//                 validator: (val) =>
//                     val == null || val.isEmpty ? "Required" : null,
//               ),
//               const SizedBox(height: 16),

//               // UHID
//               TextFormField(
//                 controller: uhidController,
//                 decoration:
//                     buildInputDecoration(label: "UHID", hint: "Enter UHID"),
//               ),
//               const SizedBox(height: 16),

//               // Mobile No
//               TextFormField(
//                 controller: mobileController,
//                 keyboardType: TextInputType.phone,
//                 decoration: buildInputDecoration(
//                     label: "Mobile No.", hint: "Enter mobile number"),
//               ),
//               const SizedBox(height: 16),

//               // Name
//               TextFormField(
//                 controller: nameController,
//                 decoration: buildInputDecoration(
//                     label: "Name *", hint: "Enter full name"),
//                 validator: (val) =>
//                     val == null || val.isEmpty ? "Required" : null,
//               ),
//               const SizedBox(height: 16),

//               // Gender
//               // Gender dropdown (simple fixed list)
//               CommonSearchableDropdown<String>(
//                 items: (filter, _) => ["Male", "Female", "Other"],
//                 hintText: "Gender *",
//                 selectedItem: genderController.text.isNotEmpty
//                     ? genderController.text
//                     : null,
//                 onChanged: (val) {
//                   genderController.text = val ?? "";
//                 },
//                 validator: (val) =>
//                     val == null || val.isEmpty ? "Required" : null,
//               ),

//               const SizedBox(height: 16),

// // Year dropdown (±100 years from today)
//               CommonSearchableDropdown<int>(
//                 items: (filter, _) {
//                   final nowYear = DateTime.now().year;
//                   final years = List.generate(201, (i) => nowYear - 100 + i);
//                   return years.reversed.toList(); // most recent first
//                 },
//                 hintText: "Year",
//                 selectedItem: yearController.text.isNotEmpty
//                     ? int.tryParse(yearController.text)
//                     : null,
//                 onChanged: (val) {
//                   yearController.text = val?.toString() ?? "";
//                 },
//               ),

//               const SizedBox(height: 16),

// // Month dropdown (1–12)
//               CommonSearchableDropdown<String>(
//                 items: (filter, _) => [
//                   "January",
//                   "February",
//                   "March",
//                   "April",
//                   "May",
//                   "June",
//                   "July",
//                   "August",
//                   "September",
//                   "October",
//                   "November",
//                   "December"
//                 ],
//                 hintText: "Month",
//                 selectedItem: monthController.text.isNotEmpty
//                     ? monthController.text
//                     : null,
//                 onChanged: (val) {
//                   monthController.text = val ?? "";
//                 },
//               ),

//               const SizedBox(height: 16),

// // Day dropdown (depends on month + year)
//               StatefulBuilder(
//                 builder: (context, setState) {
//                   int? selectedYear = int.tryParse(yearController.text);
//                   int monthIndex = [
//                         "January",
//                         "February",
//                         "March",
//                         "April",
//                         "May",
//                         "June",
//                         "July",
//                         "August",
//                         "September",
//                         "October",
//                         "November",
//                         "December"
//                       ].indexOf(monthController.text) +
//                       1;

//                   // Calculate days in month
//                   int daysInMonth = 31;
//                   if (selectedYear != null && monthIndex > 0) {
//                     final firstDayNextMonth = (monthIndex == 12)
//                         ? DateTime(selectedYear + 1, 1, 1)
//                         : DateTime(selectedYear, monthIndex + 1, 1);
//                     final lastDayThisMonth =
//                         firstDayNextMonth.subtract(const Duration(days: 1));
//                     daysInMonth = lastDayThisMonth.day;
//                   }

//                   final days =
//                       List.generate(daysInMonth, (i) => (i + 1).toString());

//                   return CommonSearchableDropdown<String>(
//                     items: (filter, _) => days,
//                     hintText: "Day",
//                     selectedItem: dayController.text.isNotEmpty
//                         ? dayController.text
//                         : null,
//                     onChanged: (val) {
//                       dayController.text = val ?? "";
//                       setState(() {}); // refresh if needed
//                     },
//                   );
//                 },
//               ),

//               const SizedBox(height: 16),

//               // Address
//               TextFormField(
//                 controller: addressController,
//                 maxLines: 2,
//                 decoration: buildInputDecoration(
//                     label: "Address", hint: "Enter address"),
//               ),
//               const SizedBox(height: 16),
//               _PrimaryButton(
//                 label: 'Submit',
//                 enabled: _validateForm(),
//                 accent: Color(0xFF00C2FF),
//                 onTap: () {},
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _PrimaryButton extends StatelessWidget {
//   final String label;
//   final bool enabled;
//   final VoidCallback onTap;
//   final Color accent;

//   const _PrimaryButton({
//     required this.label,
//     required this.enabled,
//     required this.onTap,
//     required this.accent,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final radius = BorderRadius.circular(16);

//     return Opacity(
//       opacity: enabled ? 1 : 0.6,
//       child: GestureDetector(
//         onTap: enabled
//             ? () {
//                 HapticFeedback.selectionClick();
//                 onTap();
//               }
//             : null,
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 200),
//           padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
//           decoration: BoxDecoration(
//             borderRadius: radius,
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [
//                 accent,
//                 const Color(0xFF7F5AF0),
//               ],
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: const Color(0xFF7F5AF0).withOpacity(0.25),
//                 blurRadius: 16,
//                 offset: const Offset(0, 6),
//               ),
//             ],
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(Icons.sms_rounded, color: Colors.white),
//               const SizedBox(width: 8),
//               Text(
//                 label,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 16.5,
//                   fontWeight: FontWeight.w800,
//                   letterSpacing: 0.2,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// InputDecoration buildInputDecoration({
//   required String label,
//   String? hint,
//   Widget? suffixIcon,
// }) {
//   return InputDecoration(
//     labelText: label,
//     labelStyle: TextStyle(
//       color: Colors.grey[700],
//       fontSize: 16,
//       fontWeight: FontWeight.w500,
//     ),
//     suffixIcon: suffixIcon != null
//         ? Container(
//             margin: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: Colors.blue.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: suffixIcon,
//           )
//         : null,
//     filled: true,
//     fillColor: Colors.white,
//     border: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(12),
//       borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
//     ),
//     enabledBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(12),
//       borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
//     ),
//     focusedBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(12),
//       borderSide: const BorderSide(color: Colors.blue, width: 2),
//     ),
//     errorBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(12),
//       borderSide: const BorderSide(color: Colors.red, width: 1),
//     ),
//     focusedErrorBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(12),
//       borderSide: const BorderSide(color: Colors.red, width: 2),
//     ),
//     contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//     hintText: hint,
//     hintStyle: TextStyle(
//       color: Colors.grey[400],
//       fontSize: 14,
//     ),
//     floatingLabelBehavior: FloatingLabelBehavior.auto,
//   );
// }

// class DateTimePopup extends StatefulWidget {
//   const DateTimePopup({super.key, required this.onDateTimeSelected, required this.dateList, required this.getTimeList});

//   final void Function(DateTime, TimeOfDay) onDateTimeSelected;
//   final List<DateTime> dateList;
//   final Future<List<String>> Function(DateTime) getTimeList;

//   @override
//   State<DateTimePopup> createState() => _DateTimePopupState();
// }

// class _DateTimePopupState extends State<DateTimePopup> {
//   final ScrollController _dateScrollController = ScrollController();
//   final List<DateTime> _dates =
//       List.generate(14, (i) => DateTime.now().add(Duration(days: i)));

//   DateTime? _selectedDate;
//   String? _selectedTimeSlot;
//   List<String> _timeSlots = [];

//   void _onDateSelected(DateTime date) {
//     setState(() {
//       _selectedDate = date;
//       _selectedTimeSlot = null; // Reset time selection when date changes
//       _timeSlots = List.generate(
//         5,
//         (i) =>
//             "${10 + Random().nextInt(6)}:${Random().nextBool() ? "00" : "30"} ${Random().nextBool() ? "AM" : "PM"}",
//       );
//     });
//   }

//   void _onTimeSlotSelected(String timeSlot) {
//     setState(() {
//       _selectedTimeSlot = timeSlot;
//     });
//     print(timeSlot);
//   }

//   void _confirmSelection() {
//     if (_selectedDate != null && _selectedTimeSlot != null) {
//       try {
//         // Normalize string (remove extra spaces, force uppercase)
//         final timeString = _selectedTimeSlot!.trim().toUpperCase();

//         // Parse with intl
//         final parsedTime = DateFormat("h:mm a").parse(timeString);

//         // Convert to TimeOfDay
//         final timeOfDay = TimeOfDay.fromDateTime(parsedTime);

//         // Pass back to parent
//         widget.onDateTimeSelected(_selectedDate!, timeOfDay);
//         Navigator.of(context).pop();
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("Invalid time format: $_selectedTimeSlot"),
//             duration: const Duration(seconds: 2),
//           ),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Please select a date and time."),
//           duration: Duration(seconds: 2),
//         ),
//       );
//     }
//   }

//   int _startIndex = 0;

//   void _scrollDates(bool forward) {
//     setState(() {
//       if (forward) {
//         if (_startIndex < _dates.length - 4) {
//           _startIndex++;
//         }
//       } else {
//         if (_startIndex > 0) {
//           _startIndex--;
//         }
//       }
//     });
//   }

//   Widget _buildDateGrid(ThemeData theme) {
//   final visibleDates = _dates.skip(_startIndex).take(4).toList();

//   return GridView.builder(
//     shrinkWrap: true,
//     physics: const NeverScrollableScrollPhysics(),
//     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//       crossAxisCount: 2, // 2 per row
//       mainAxisSpacing: 8,
//       crossAxisSpacing: 8,
//       childAspectRatio: 2.2,
//     ),
//     itemCount: visibleDates.length,
//     itemBuilder: (context, index) {
//       final date = visibleDates[index];
//       final isSelected = _selectedDate == date;
//       return GestureDetector(
//         onTap: () => _onDateSelected(date),
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12),
//             color: isSelected
//                 ? theme.colorScheme.primary.withOpacity(0.8)
//                 : Colors.white.withOpacity(0.3),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Flexible(
//                 child: Text(
//                   "${date.day}/${date.month}/${date.year}",
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 12, // Reduced from 14 to prevent overflow
//                     color: isSelected ? Colors.white : Colors.black,
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               const SizedBox(height: 2), // Reduced spacing
//               Flexible(
//                 child: Text(
//                   [
//                     "Mon",
//                     "Tue",
//                     "Wed",
//                     "Thu",
//                     "Fri",
//                     "Sat",
//                     "Sun"
//                   ][date.weekday - 1], // Fixed: weekday is 1-7, array is 0-6
//                   style: TextStyle(
//                     fontSize: 10, // Reduced from 12
//                     color: isSelected
//                         ? Colors.white.withOpacity(0.9)
//                         : Colors.black87,
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Dialog(
//       backgroundColor: const Color.fromARGB(0, 238, 233, 233),
//       insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(24),
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
//           child: Container(
//             color: Colors.white.withOpacity(0.8),
//             child: CustomScrollView(
//               slivers: [
//                 // HEADER
//                 SliverToBoxAdapter(
//                   child: Container(
//                     padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
//                     color: Colors.white.withOpacity(0.2),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text(
//                           "Select Date & Time",
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black87,
//                           ),
//                         ),
//                         IconButton(
//                           onPressed: () => Navigator.of(context).pop(),
//                           icon: const Icon(Icons.close, size: 24),
//                           style: IconButton.styleFrom(
//                             backgroundColor: Colors.black.withOpacity(0.1),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//                 // DATE SELECTOR
//                 SliverToBoxAdapter(
//                   child: Container(
//                     padding:
//                         const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
//                     child: Row(
//                       children: [
//                         IconButton(
//                           onPressed: () => _scrollDates(false),
//                           icon: const Icon(Icons.arrow_back_ios, size: 18),
//                         ),
//                         Expanded(
//                           child: _buildDateGrid(theme),
//                         ),
//                         IconButton(
//                           onPressed: () => _scrollDates(true),
//                           icon: const Icon(Icons.arrow_forward_ios, size: 18),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 //sliverdivider
//                 SliverToBoxAdapter(
//                   child: Divider(
//                     height: 1,
//                     color: Colors.black.withOpacity(0.1),
//                   ),
//                 ),
//                 // TIME SLOTS
//                 if (_timeSlots.isEmpty)
//                   const SliverFillRemaining(
//                     hasScrollBody: false,
//                     child: Center(
//                       child: Text(
//                         "Select a date to view available times",
//                         style: TextStyle(
//                             fontSize: 14, fontWeight: FontWeight.w500),
//                       ),
//                     ),
//                   )
//                 else
//                   SliverPadding(
//                     padding: const EdgeInsets.all(16),
//                     sliver: SliverGrid(
//                       delegate: SliverChildBuilderDelegate(
//                         (context, index) {
//                           final slot = _timeSlots[index];
//                           final isSelected = _selectedTimeSlot == slot;
//                           return GestureDetector(
//                             onTap: () => _onTimeSlotSelected(slot),
//                             child: Card(
//                               elevation: isSelected ? 4 : 0,
//                               color: isSelected
//                                   ? theme.colorScheme.primary.withOpacity(0.9)
//                                   : Colors.white.withOpacity(0.4),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                                 side: isSelected
//                                     ? BorderSide(
//                                         color: theme.colorScheme.primary,
//                                         width: 2)
//                                     : BorderSide.none,
//                               ),
//                               child: Center(
//                                 child: Text(
//                                   slot,
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.w600,
//                                     color: isSelected
//                                         ? Colors.white
//                                         : Colors.black87,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                         childCount: _timeSlots.length,
//                       ),
//                       gridDelegate:
//                           const SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 2,
//                         crossAxisSpacing: 12,
//                         mainAxisSpacing: 12,
//                         childAspectRatio: 2.5,
//                       ),
//                     ),
//                   ),

//                 // CONFIRM BUTTON
//                 SliverToBoxAdapter(
//                   child: Padding(
//                     padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         backgroundColor: theme.colorScheme.primary,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       onPressed: _confirmSelection,
//                       child: const Text(
//                         "Confirm",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/resource.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/status.dart';
import 'package:jnm_hospital_app/features/admin_report_module/common_widgets/searchable_dropdown.dart';
import 'package:jnm_hospital_app/features/patient_module/patient_details_module/ui/common_layout.dart';
import 'package:jnm_hospital_app/features/patient_module/patient_opd_module/data/patient_opd_usecases_impl.dart';

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
    Resource resource = await patientOPDUsecasesImpl.getOPDSchedule(selectedDoctor!.keys.first);
    if (resource.status == STATUS.SUCCESS) {

      print("Success");
      print(resource.data['data']);
      final response = resource.data['data']['uniqueDates'] as List;
      
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

  Future<List<String>> getTimeslotData(DateTime selectedDate) async {
    setState(() {
      isLoading = true;
    });
    PatientOPDUsecasesImpl patientOPDUsecasesImpl = PatientOPDUsecasesImpl();
    Resource resource = await patientOPDUsecasesImpl.getOPDTimeslot(selectedDoctor!.keys.first, selectedDate!);

    List<String> timeList = [];

    if (resource.status == STATUS.SUCCESS) {
      // Handle successful response
      print("Success");
      final response = resource.data as List;
      response.forEach((timeslot) {
        String fromTime = timeslot['uniqueDates_withtiming']["from_time"];
        String toTime = timeslot['uniqueDates_withtiming']["to_time"];
        timeList.add("$fromTime - $toTime");
      });
      setState(() {});
    } else {

      print("Error: ${resource.message}");
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
              const SizedBox(height: 12),

              // ===== Top Actions & Summary =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _softButton(
                      label: "Reset",
                      icon: Icons.refresh_rounded,
                      color: Colors.red,
                      onTap: _resetForm,
                    ),
                    // const Spacer(),
                    // Wrap(
                    //   spacing: 8,
                    //   runSpacing: 8,
                    //   children: [
                    //     _tag(Icons.apartment_rounded, _deptText()),
                    //     _tag(Icons.person_rounded, _doctorText()),
                    //     _tag(Icons.calendar_today_rounded, _dateToChip(selectedDate)),
                    //     _tag(Icons.access_time_rounded, _timeToChip(selectedTime)),
                    //   ],
                    // )
                  ],
                ),
              ),

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
                        _sectionHeader('Visit Details'),
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
                                onChanged: (val)async {
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
                                    builder: (_) => DateTimePopup(
                                      onDateTimeSelected: (date, time) {
                                        setState(() {
                                          selectedDate = date;
                                          selectedTime = time;
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
                                decoration: _inputDecoration(
                                  hint: "Select slot time",
                                  suffixIcon: const Icon(Icons.access_time,
                                      color: Colors.blue, size: 20),
                                ),
                                controller: TextEditingController(
                                  text: selectedTime != null
                                      ? selectedTime!.format(context)
                                      : "",
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
                                  return years.reversed.toList();
                                },
                                hintText: "Select year",
                                selectedItem: yearController.text.isNotEmpty
                                    ? int.tryParse(yearController.text)
                                    : null,
                                onChanged: (val) =>
                                    yearController.text = val?.toString() ?? "",
                              ),
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
                                onChanged: (val) =>
                                    monthController.text = val ?? "",
                              ),
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
                                      setInner(() {});
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
                            controller: addressController,
                            maxLines: 2,
                            decoration: _inputDecoration(hint: "Enter address"),
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Required'
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 88), // space for sticky submit
            ],
          ),

          // ===== Sticky Submit Bar =====
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _StickySubmitBar(
              valid: valid,
              department: _deptText(),
              doctor: _doctorText(),
              date: _dateToChip(selectedDate),
              time: _timeToChip(selectedTime),
              onSubmit: () {
                HapticFeedback.selectionClick();
                if (_formKey.currentState?.validate() ?? false) {
                  if (!valid) {
                    _snack(context, 'Please complete all required fields');
                    return;
                  }
                  _snack(context, 'Appointment submitted ✅');
                  // TODO: integrate submit usecase here.
                }
              },
            ),
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
              fontWeight: FontWeight.w800,
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
            fontWeight: FontWeight.w900,
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
          border:
              Border(top: BorderSide(color: Colors.black.withOpacity(0.06))),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.10),
              blurRadius: 18,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Wrap(
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
            ),
            const SizedBox(width: 12),
            Opacity(
              opacity: valid ? 1 : 0.6,
              child: ElevatedButton.icon(
                onPressed: valid ? onSubmit : null,
                icon: const Icon(Icons.check_circle_rounded),
                label: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                  child: Text('Submit',
                      style: TextStyle(fontWeight: FontWeight.w900)),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7F5AF0),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
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
  const DateTimePopup({super.key, required this.onDateTimeSelected, required this.dateList, required this.getTimeList});
  final void Function(DateTime, TimeOfDay) onDateTimeSelected;
  final List<DateTime> dateList;
  final Future<List<String>> Function(DateTime) getTimeList;

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
        if (_startIndex < _dates.length - 4) {
          _startIndex++;
        }
      } else {
        if (_startIndex > 0) {
          _startIndex--;
        }
      }
    });
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
      _selectedTimeSlot = null;
      _timeSlots = List.generate(
        6,
        (i) =>
            "${10 + Random().nextInt(7)}:${Random().nextBool() ? "00" : "30"} ${Random().nextBool() ? "AM" : "PM"}",
      );
    });
  }

  void _onTimeSlotSelected(String timeSlot) =>
      setState(() => _selectedTimeSlot = timeSlot);

  void _confirmSelection() {
    if (_selectedDate != null && _selectedTimeSlot != null) {
      try {
        final timeString = _selectedTimeSlot!.trim().toUpperCase();
        final parsedTime = DateFormat("h:mm a").parse(timeString);
        final timeOfDay = TimeOfDay.fromDateTime(parsedTime);
        widget.onDateTimeSelected(_selectedDate!, timeOfDay);
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
    final visibleDates = _dates.skip(_startIndex).take(4).toList();

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
                              fontWeight: FontWeight.w900,
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
                      IconButton(
                        onPressed: () => _scrollDates(false),
                        icon: const Icon(Icons.arrow_back_ios, size: 18),
                      ),
                      Expanded(
                        child: _buildDateGrid(theme),
                      ),
                      IconButton(
                        onPressed: () => _scrollDates(true),
                        icon: const Icon(Icons.arrow_forward_ios, size: 18),
                      ),
                    ],
                  ),
                )),

                // Slots
                if (_timeSlots.isEmpty)
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
                          final slot = _timeSlots[index];
                          final isSelected = _selectedTimeSlot == slot;
                          return GestureDetector(
                            onTap: () => _onTimeSlotSelected(slot),
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
                                  slot,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
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


