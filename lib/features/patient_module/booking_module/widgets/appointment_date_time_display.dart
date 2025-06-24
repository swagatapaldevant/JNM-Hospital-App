import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';

class AppointmentDateTimeDisplay extends StatelessWidget {
  final DateTime dateTime;

  const AppointmentDateTimeDisplay({
    super.key,
    required this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    final String dateStr = DateFormat('EEEE, MMM d, y').format(dateTime); // Wednesday, Jun 23, 2021
    final String timeStr = DateFormat('hh:mm a').format(dateTime);        // 10:00 AM

    return Row(
      children: [
        // Calendar Icon
        Container(
          padding: const EdgeInsets.all(10),
          decoration:  BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.starBackgroundColor, // background for icon circle
          ),
          child: const Icon(
            Icons.calendar_today_rounded,
            color: Color(0xFF047857), // teal/dark green
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        // Date & Time
        Text(
          "$dateStr  |  $timeStr",
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF111827), // dark gray text
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
