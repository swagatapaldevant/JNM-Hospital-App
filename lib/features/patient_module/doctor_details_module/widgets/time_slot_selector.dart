import 'package:flutter/material.dart';

class TimeSlotSelector extends StatefulWidget {
  const TimeSlotSelector({super.key});

  @override
  State<TimeSlotSelector> createState() => _TimeSlotSelectorState();
}

class _TimeSlotSelectorState extends State<TimeSlotSelector> {
  final List<String> timeSlots = [
    "09:00 AM", "10:00 AM", "11:00 AM",
    "01:00 PM", "02:00 PM", "03:00 PM",
    "04:00 PM", "07:00 PM", "08:00 PM",
  ];

  final Set<String> disabledSlots = {
    "09:00 AM", "11:00 AM", "01:00 PM", "08:00 PM",
  };

  String? selectedTime;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: timeSlots.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2.4,
      ),
      itemBuilder: (context, index) {
        final time = timeSlots[index];
        final isDisabled = disabledSlots.contains(time);
        final isSelected = selectedTime == time;

        return GestureDetector(
          onTap: isDisabled
              ? null
              : () {
            setState(() {
              selectedTime = time;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.blue
                  : isDisabled
                  ? Colors.transparent
                  : Colors.white,
              border: Border.all(
                color: isDisabled
                    ? Colors.grey.shade200
                    : isSelected
                    ? Colors.transparent
                    : Colors.teal.shade200,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            alignment: Alignment.center,
            child: Text(
              time,
              style: TextStyle(
                color: isDisabled
                    ? Colors.grey.shade300
                    : isSelected
                    ? Colors.white
                    : Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      },
    );
  }
}
