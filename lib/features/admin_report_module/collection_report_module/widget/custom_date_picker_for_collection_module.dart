import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/screen_utils.dart';

class CustomDatePickerFieldForCollectionModule extends StatefulWidget {
  final String? selectedDate;
  final String placeholderText;
  final ValueChanged<String> onDateChanged;
  final bool disallowFutureDates;

  const CustomDatePickerFieldForCollectionModule({
    super.key,
    required this.onDateChanged,
    required this.placeholderText,
    this.selectedDate,
    this.disallowFutureDates = false,
  });

  @override
  _CustomDatePickerFieldForCollectionModuleState createState() => _CustomDatePickerFieldForCollectionModuleState();
}

class _CustomDatePickerFieldForCollectionModuleState extends State<CustomDatePickerFieldForCollectionModule> {
  late TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController(text: widget.selectedDate ?? '');
  }

  @override
  void didUpdateWidget(covariant CustomDatePickerFieldForCollectionModule oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != oldWidget.selectedDate) {
      _dateController.text = widget.selectedDate ?? '';
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    // today without time
    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);

    // parse current value (if any)
    DateTime? parsed =
    DateTime.tryParse(widget.selectedDate ?? '');

    // if disallowing future dates, clamp initial date to today
    DateTime initialDate = parsed ?? todayOnly;
    if (widget.disallowFutureDates && initialDate.isAfter(todayOnly)) {
      initialDate = todayOnly;
    }

    // build lastDate based on the flag
    final DateTime lastDate =
    widget.disallowFutureDates ? todayOnly : DateTime(2100);

    // make sure initialDate is within [firstDate, lastDate]
    final DateTime firstDate = DateTime(2000);
    if (initialDate.isBefore(firstDate)) initialDate = firstDate;
    if (initialDate.isAfter(lastDate)) initialDate = lastDate;

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      _dateController.text = formattedDate;
      widget.onDateChanged(formattedDate);
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtils().screenWidth(context) * 0.33,
      padding: EdgeInsets.only(
        left: ScreenUtils().screenWidth(context) * 0.03,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5FA),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 0,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _dateController,
        readOnly: true,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(
          color: AppColors.colorBlack,
          fontSize: 10,
          fontFamily: "Poppins",
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: widget.placeholderText,
          hintStyle: TextStyle(
            color: AppColors.colorPrimaryText,
            fontFamily: "Poppins",
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
          border: InputBorder.none,
          suffixIcon: GestureDetector(
            onTap: () => _selectDate(context),
            child: Icon(Icons.calendar_today, color: AppColors.colorPrimaryText, size: 20,),
          ),
        ),
        onTap: () => _selectDate(context),
      ),
    );
  }
}
