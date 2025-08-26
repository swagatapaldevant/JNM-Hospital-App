import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:jnm_hospital_app/features/patient_module/model/dashboard/doctor_model.dart';

class DoctorDetailsScreen extends StatefulWidget {
  final DoctorModel doctorDetails;
  const DoctorDetailsScreen({super.key, required this.doctorDetails});

  @override
  State<DoctorDetailsScreen> createState() => _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends State<DoctorDetailsScreen> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  // --- helpers
  void _snack(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  Color? _parseColor(dynamic c) {
    if (c == null) return null;
    if (c is Color) return c;
    if (c is int) return Color(c);
    if (c is String) {
      final s = c.replaceAll('#', '').trim();
      if (s.length == 6) return Color(int.parse('FF$s', radix: 16));
      if (s.length == 8) return Color(int.parse(s, radix: 16));
    }
    return null;
  }

  // Open flow to pick date/time, then set state
  Future<void> _openBookingSheet(BuildContext context, Color accent) async {
    HapticFeedback.selectionClick();

    final now = DateTime.now();
    DateTime tempDate = _selectedDate ?? now;
    TimeOfDay tempTime = _selectedTime ?? TimeOfDay(hour: now.hour, minute: 0);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return _BookingSheet(
          accent: accent,
          initialDate: tempDate,
          initialTime: tempTime,
          onConfirmed: (d, t, reason) {
            setState(() {
              _selectedDate = d;
              _selectedTime = t;
            });
            Navigator.pop(context);
            _snack('Selected ${DateFormat('EEE, dd MMM').format(d)} • '
                '${DateFormat('h:mm a').format(DateTime(0, 1, 1, t.hour, t.minute))}');
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.doctorDetails;
    final accent = _parseColor(d.color) ?? const Color(0xFF7F5AF0);
    const secondary = Color(0xFF00C2FF);
    final isIn = (d.inOutStatus?.toString().toUpperCase() == 'IN');

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: Stack(
        children: [
          // Soft gradient background with subtle blobs
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF6F7FF), Color(0xFFE7F0FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Positioned(top: -120, left: -80, child: _blob(220, secondary.withOpacity(0.10))),
          Positioned(bottom: -140, right: -100, child: _blob(260, accent.withOpacity(0.10))),

          SafeArea(
            child: CustomScrollView(
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: Row(
                      children: [
                        _roundIconButton(
                          icon: Icons.arrow_back_ios_new_rounded,
                          onTap: () => Navigator.maybePop(context),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          "Doctor Details",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        const Spacer(),
                        _roundIconButton(
                          icon: Icons.share_rounded,
                          onTap: () => _snack('Share profile'),
                        ),
                      ],
                    ),
                  ),
                ),

                // Profile card
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: _ProfileCard(
                      name: d.name ?? 'Unknown Doctor',
                      details: d.details ?? '',
                      inOutStatus: isIn ? 'IN' : 'OUT',
                      inOutDetails: (d.inOutDetails ?? '').toString(),
                      accent: accent,
                      secondary: secondary,
                    ),
                  ),
                ),

                // Quick info row
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: _WhiteChipTile(
                            icon: Icons.badge_outlined,
                            title: 'Doctor ID',
                            value: d.doctorId?.toString() ?? '—',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _StatusPill(
                            isIn: isIn,
                            text: isIn ? 'Available' : 'Not Available',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 12)),

                // Availability
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _SectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionHeader('Available Timings', accent),
                          const SizedBox(height: 10),
                          if ((d.avilableTime1 ?? '').trim().isNotEmpty ||
                              (d.avilableTime ?? '').trim().isNotEmpty)
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                if ((d.avilableTime1 ?? '').trim().isNotEmpty)
                                  _slotChip(d.avilableTime1!.trim(), () => _openBookingSheet(context, accent)),
                                if ((d.avilableTime ?? '').trim().isNotEmpty)
                                  _slotChip(d.avilableTime!.trim(), () => _openBookingSheet(context, accent)),
                              ],
                            )
                          else
                            const Text(
                              'No schedule shared',
                              style: TextStyle(color: Colors.black54, fontSize: 13),
                            ),
                          if ((d.inOutDetails ?? '').toString().trim().isNotEmpty) ...[
                            const SizedBox(height: 12),
                            _kvRow(
                              icon: Icons.info_outline,
                              label: 'Notes',
                              value: d.inOutDetails.toString(),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 12)),

                if ((d.details ?? '').trim().isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _SectionCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _sectionHeader('About', accent),
                            const SizedBox(height: 10),
                            Text(
                              d.details!.trim(),
                              style: const TextStyle(fontSize: 12, height: 1.35, color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 120)),
              ],
            ),
          ),

          // Bottom: single "Book Now" CTA with selected chips preview
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _BookNowBar(
              accent: accent,
              secondary: secondary,
              selectedDate: _selectedDate,
              selectedTime: _selectedTime,
              onBookNow: () async {
                // If not selected yet, open picker first
                if (_selectedDate == null || _selectedTime == null) {
                  await _openBookingSheet(context, accent);
                }
                if (_selectedDate != null && _selectedTime != null) {
                  // TODO: Hook your booking API here with doctorId, date, time, reason (if needed)
                  _snack('Appointment request sent ✅');
                }
              },
              onEdit: () => _openBookingSheet(context, accent),
            ),
          ),
        ],
      ),
    );
  }

  // --- small UI helpers inside State ---

  Widget _blob(double size, Color color) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: color,
      boxShadow: [
        BoxShadow(
          color: color.withOpacity(0.45),
          blurRadius: size * 0.25,
          spreadRadius: size * 0.02,
        )
      ],
    ),
  );

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
          border: Border.all(color: Colors.cyan),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(.06), blurRadius: 10, offset: const Offset(0, 6)),
          ],
        ),
        child: Icon(icon, color: Colors.black87),
      ),
    );
  }

  Widget _sectionHeader(String title, Color accent) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: accent)),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }

  Widget _kvRow({required IconData icon, required String label, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: Colors.blueGrey.withOpacity(0.12),
          child: Icon(icon, size: 18, color: Colors.blueGrey),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: Colors.black54)),
            const SizedBox(height: 3),
            Text(value, style: const TextStyle(fontSize: 14.5, color: Colors.black87, height: 1.3)),
          ]),
        ),
      ],
    );
  }

  Widget _slotChip(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.black12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 4))],
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.access_time, size: 14, color: Colors.blueGrey),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.black87),
          ),
        ]),
      ),
    );
  }
}

// ===== Profile Card =====
class _ProfileCard extends StatelessWidget {
  final String name;
  final String details;
  final String inOutStatus;
  final String inOutDetails;
  final Color accent;
  final Color secondary;

  const _ProfileCard({
    required this.name,
    required this.details,
    required this.inOutStatus,
    required this.inOutDetails,
    required this.accent,
    required this.secondary,
  });

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _GradientAvatar(initials: _initials(name), accent: accent, secondary: secondary),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: (inOutStatus == 'IN' ? Colors.green : Colors.red).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: (inOutStatus == 'IN' ? Colors.green : Colors.red).withOpacity(0.45),
                      ),
                    ),
                    child: Text(
                      inOutStatus,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: (inOutStatus == 'IN' ? Colors.green : Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              if (details.trim().isNotEmpty)
                Text(
                  details.trim(),
                  style: const TextStyle(fontSize: 12, color: Colors.black54, height: 1.3),
                ),
              if (inOutDetails.trim().isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.info_outline, size: 16, color: Colors.blueGrey),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        inOutDetails.trim(),
                        style: const TextStyle(fontSize: 12.5, color: Colors.black54),
                      ),
                    ),
                  ],
                ),
              ],
            ]),
          ),
        ],
      ),
    );
  }

  static String _initials(String n) {
    final parts = n.trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
    if (parts.isEmpty) return 'DR';
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return (parts.first.characters.first + parts.last.characters.first).toUpperCase();
  }
}

class _GradientAvatar extends StatelessWidget {
  final String initials;
  final Color accent;
  final Color secondary;
  const _GradientAvatar({required this.initials, required this.accent, required this.secondary});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(colors: [secondary, accent], begin: Alignment.topLeft, end: Alignment.bottomRight),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.10), blurRadius: 16, offset: const Offset(0, 8))],
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

// ===== Section Card (glassy) =====
class _SectionCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  const _SectionCard({required this.child, this.padding = const EdgeInsets.all(16)});

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(18);
    return Container(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 18, offset: const Offset(0, 10)),
          BoxShadow(color: Colors.white.withOpacity(0.65), blurRadius: 6, offset: const Offset(-3, -2)),
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
              border: Border.all(color: Colors.white.withOpacity(0.6), width: 1),
              gradient:
              LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [
                Colors.white.withOpacity(0.95),
                Colors.white.withOpacity(0.7),
              ]),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

// ===== Quick Info Tiles =====
class _WhiteChipTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  const _WhiteChipTile({required this.icon, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.blueGrey.withOpacity(0.1),
            child: Icon(icon, size: 18, color: Colors.blueGrey),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.black54)),
              const SizedBox(height: 2),
              Text(value,
                  style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w700, color: Colors.black87)),
            ]),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final bool isIn;
  final String text;
  const _StatusPill({required this.isIn, required this.text});

  @override
  Widget build(BuildContext context) {
    final color = isIn ? Colors.green : Colors.red;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(isIn ? Icons.verified_rounded : Icons.schedule_rounded, size: 16, color: color),
          const SizedBox(width: 8),
          Text(text, style: TextStyle(fontWeight: FontWeight.w800, color: color)),
        ],
      ),
    );
  }
}

// ===== Bottom Bar (Book Now) =====
class _BookNowBar extends StatelessWidget {
  final Color accent;
  final Color secondary;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final VoidCallback onBookNow;
  final VoidCallback onEdit;

  const _BookNowBar({
    required this.accent,
    required this.secondary,
    required this.selectedDate,
    required this.selectedTime,
    required this.onBookNow,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final dateText = selectedDate == null ? null : DateFormat('EEE, dd MMM').format(selectedDate!);
    final timeText = selectedTime == null
        ? null
        : DateFormat('h:mm a').format(DateTime(0, 1, 1, selectedTime!.hour, selectedTime!.minute));

    return Material(
      elevation: 14,
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.98),
          border: Border(top: BorderSide(color: Colors.black.withOpacity(0.06))),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 18, offset: const Offset(0, -6))],
        ),
        child: Row(
          children: [
            Expanded(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  if (dateText != null) _miniTag(Icons.calendar_month_rounded, dateText),
                  if (timeText != null) _miniTag(Icons.access_time_filled_rounded, timeText),
                  if (dateText == null && timeText == null)
                    const Text("No slot selected", style: TextStyle(color: Colors.black54, fontSize: 12.5)),
                ],
              ),
            ),
            const SizedBox(width: 10),
            if (dateText != null || timeText != null)
              TextButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_calendar_rounded),
                label: const Text('Edit'),
              ),
            const SizedBox(width: 6),
            ElevatedButton(
              onPressed: onBookNow,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              child: const Text('Book Now', style: TextStyle(fontWeight: FontWeight.w900)),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _miniTag(IconData icon, String value) {
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
        Text(value, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: Colors.black87)),
      ]),
    );
  }
}

// ===== Booking Bottom Sheet =====
class _BookingSheet extends StatefulWidget {
  final Color accent;
  final DateTime initialDate;
  final TimeOfDay initialTime;
  final void Function(DateTime, TimeOfDay, String? reason) onConfirmed;

  const _BookingSheet({
    required this.accent,
    required this.initialDate,
    required this.initialTime,
    required this.onConfirmed,
  });

  @override
  State<_BookingSheet> createState() => _BookingSheetState();
}

class _BookingSheetState extends State<_BookingSheet> {
  late DateTime date;
  late TimeOfDay time;
  final TextEditingController _reason = TextEditingController();

  @override
  void initState() {
    super.initState();
    date = widget.initialDate;
    time = widget.initialTime;
  }

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.only(bottom: bottom),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            color: Colors.white.withOpacity(0.96),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                width: 44,
                height: 5,
                margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Book Appointment',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                ),
              ),
              const Divider(height: 1),

              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: _pickerTile(
                        icon: Icons.calendar_month_rounded,
                        label: 'Date',
                        value: DateFormat('EEE, dd MMM').format(date),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: date.isBefore(DateTime.now()) ? DateTime.now() : date,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          );
                          if (picked != null) {
                            setState(() => date = DateTime(picked.year, picked.month, picked.day));
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _pickerTile(
                        icon: Icons.access_time_rounded,
                        label: 'Time',
                        value: DateFormat('h:mm a').format(DateTime(0, 1, 1, time.hour, time.minute)),
                        onTap: () async {
                          final picked = await showTimePicker(context: context, initialTime: time);
                          if (picked != null) setState(() => time = picked);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _reason,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: 'Reason / symptoms (optional)',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          HapticFeedback.selectionClick();
                          widget.onConfirmed(date, time, _reason.text.trim().isEmpty ? null : _reason.text.trim());
                        },
                        icon: const Icon(Icons.check_circle_rounded),
                        label: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text('Confirm Booking', style: TextStyle(fontWeight: FontWeight.w900)),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.accent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }

  static Widget _pickerTile({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black.withOpacity(0.08)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: Colors.blueGrey),
            const SizedBox(width: 10),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(label,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.black54)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800)),
              ]),
            ),
            const Icon(Icons.edit_calendar_rounded, size: 18, color: Colors.blueGrey),
          ],
        ),
      ),
    );
  }
}
