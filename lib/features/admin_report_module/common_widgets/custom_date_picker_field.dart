import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/screen_utils.dart';

class CustomDatePickerField extends StatefulWidget {
  final String? selectedDate;
  final String placeholderText;
  final ValueChanged<String> onDateChanged;

  const CustomDatePickerField({
    super.key,
    required this.onDateChanged,
    required this.placeholderText,
    this.selectedDate,
  });

  @override
  _CustomDatePickerFieldState createState() => _CustomDatePickerFieldState();
}

class _CustomDatePickerFieldState extends State<CustomDatePickerField> {
  late TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController(text: widget.selectedDate ?? '');
  }

  @override
  void didUpdateWidget(covariant CustomDatePickerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != oldWidget.selectedDate) {
      _dateController.text = widget.selectedDate ?? '';
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.tryParse(widget.selectedDate ?? '') ?? DateTime.now();

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      _dateController.text = formattedDate;

      // Call callback to return the selected date
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
      width: ScreenUtils().screenWidth(context) * 0.44,
      padding: EdgeInsets.symmetric(horizontal: ScreenUtils().screenWidth(context) * 0.05),
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
          fontSize: ScreenUtils().screenWidth(context) * 0.03,
          fontFamily: "Poppins",
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: widget.placeholderText,
          hintStyle: TextStyle(
            color: AppColors.colorPrimaryText,
            fontFamily: "Poppins",
            fontSize: ScreenUtils().screenWidth(context) * 0.035,
            fontWeight: FontWeight.w500,
          ),
          border: InputBorder.none,
          suffixIcon: GestureDetector(
            onTap: () => _selectDate(context),
            child: Icon(Icons.calendar_today, color: AppColors.colorPrimaryText),
          ),
        ),
        onTap: () => _selectDate(context),
      ),
    );
  }
}
