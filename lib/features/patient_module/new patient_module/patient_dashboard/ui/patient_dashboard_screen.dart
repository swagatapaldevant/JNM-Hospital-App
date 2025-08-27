import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/status.dart';
import 'package:jnm_hospital_app/core/services/routeGenerator/route_generator.dart';
import 'package:jnm_hospital_app/features/patient_module/model/dashboard/doctor_model.dart';
import 'package:jnm_hospital_app/features/patient_module/new%20patient_module/patient_dashboard/data/dashboard_usecases_impl.dart';
import 'package:jnm_hospital_app/features/patient_module/new%20patient_module/patient_dashboard/widgets/app_drawer.dart';

class PatientDashboardScreen extends StatefulWidget {
  const PatientDashboardScreen({super.key});

  @override
  State<PatientDashboardScreen> createState() => _PatientDashboardScreenState();
}

class _PatientDashboardScreenState extends State<PatientDashboardScreen>
    with TickerProviderStateMixin {
  // Background palette
  static const Color bg1 = Color(0xFFF0F0F0);
  static const Color bg2 = Color(0xFFCDDBFF);
  static const Color textPrimary = Colors.black87;
  static const Color textSecondary = Colors.black54;

  // Accents
  static const Color opdAccent = Color(0xFF00C2FF); // sky blue
  static const Color opticalAccent = Color(0xFF7F5AF0); // violet
  static const double _hPad = 20;

  bool _loading = true;

  // --- Sample Data (replace with API/Repository) ---
  List<DoctorModel> _doctorsToday = [];

  List<_Appointment> _opdUpcoming = const [
    _Appointment(
      typeLabel: 'OPD',
      doctor: 'Dr. Ananya Gupta',
      specialization: 'Cardiologist',
      when: 'Today, 12:15 PM',
      token: 'A-17',
      location: 'OPD Block · Rm 203',
      accent: opdAccent,
    ),
    _Appointment(
      typeLabel: 'OPD',
      doctor: 'Dr. Arjun Mehta',
      specialization: 'Dermatologist',
      when: 'Tomorrow, 10:00 AM',
      token: 'B-03',
      location: 'OPD Block · Rm 110',
      accent: opdAccent,
    ),
  ];

  List<_Appointment> _opticalUpcoming = const [
    _Appointment(
      typeLabel: 'Optical',
      doctor: 'Dr. Kavya Iyer',
      specialization: 'Optometrist',
      when: 'Tomorrow, 10:30 AM',
      token: 'OPT-05',
      location: 'Optical Center · Rm 02',
      accent: opticalAccent,
    ),
  ];

  Color _getCardColor(String color) {
    final Color defaultColor = opticalAccent;

    Map<String, Color> colorMap = {
      '#b9d8ff': Color(0xFFB9D8FF),
    };
    return colorMap[color] ?? defaultColor;
  }

  @override
  void initState() {
    super.initState();
    // Simulate initial fetch
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() => _loading = false);
    });
    getDoctorData();
  }

  Future<void> _onRefresh() async {
    HapticFeedback.lightImpact();
    setState(() => _loading = true);
    // TODO: call your API here
    await Future.delayed(const Duration(seconds: 1)); // simulate
    if (!mounted) return;

    // Example: you could also shuffle/add items here to visualize updates
    setState(() => _loading = false);
  }

  String get _prettyToday {
    final now = DateTime.now();
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
    const wds = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${wds[now.weekday - 1]}, ${now.day} ${months[now.month - 1]} ${now.year}';
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> getDoctorData() async {
    setState(() {
      _loading = true;
    });
    final resource = await DashboardUsecaseImpl().getDoctors();
    if (resource.status == STATUS.SUCCESS) {
      //print(resource.data);
      resource.data.forEach((doctor) {
        _doctorsToday.add(DoctorModel.fromJson(doctor));
      });
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Soft background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [bg1, bg2],
              ),
            ),
          ),
          // Decorative blobs
          Positioned(
              top: -120,
              left: -80,
              child: _blob(220, opdAccent.withOpacity(0.10))),
          Positioned(
              bottom: -140,
              right: -100,
              child: _blob(260, opticalAccent.withOpacity(0.10))),

          SafeArea(
            child: RefreshIndicator(
              color: opdAccent,
              onRefresh: _onRefresh,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                slivers: [
                  // Header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(_hPad, 20, _hPad, 10),
                      child: Row(
                        children: [
                          _roundIconButton(
                            icon: Icons.menu_rounded,
                            onTap: () =>
                                _scaffoldKey.currentState?.openDrawer(),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Dashboard',
                              style: TextStyle(
                                color: textPrimary,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                          _roundIconButton(
                              icon: Icons.notifications_none_rounded,
                              onTap: () {}),
                        ],
                      ),
                    ),
                  ),

                  // Date
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: _hPad),
                      child: Text(
                        _prettyToday,
                        style: TextStyle(
                          color: textSecondary,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),

                  // Greeting + Quick actions
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(_hPad, 16, _hPad, 0),
                      child: _GlassCard(
                        padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Hi there 👋',
                              style: TextStyle(
                                  color: textPrimary,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Wishing you a healthy day! Here’s what’s lined up for you.',
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.70),
                                  fontSize: 14.5,
                                  height: 1.35),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _QuickActionChip(
                                  icon: Icons.event_available_rounded,
                                  label: 'Book OPD',
                                  color: opdAccent,
                                  onTap: () {
                                    HapticFeedback.selectionClick();
                                    Navigator.pushNamed(
                                        context, RouteGenerator.kOPDRegistrationScreen);
                                  },
                                ),
                                _QuickActionChip(
                                  icon: Icons.visibility_outlined,
                                  label: 'Optical',
                                  color: opticalAccent,
                                  onTap: () => HapticFeedback.selectionClick(),
                                ),
                                _QuickActionChip(
                                  icon: Icons.receipt_long_outlined,
                                  label: 'Prescriptions',
                                  color: const Color(0xFF20C997),
                                  onTap: () => HapticFeedback.selectionClick(),
                                ),
                                _QuickActionChip(
                                  icon: Icons.receipt_long_outlined,
                                  label: 'Details',
                                  color: opticalAccent,
                                  onTap: () {
                                    HapticFeedback.selectionClick();
                                    Navigator.pushNamed(
                                        context, "/PatientDetailsScreen");
                                  },
                                ),
                                _QuickActionChip(
                                  icon: Icons.currency_exchange,
                                  label: 'Rate Enquiry',
                                  color: const Color(0xFF20C997),
                                  onTap: () {
                                    HapticFeedback.selectionClick();
                                    Navigator.pushNamed(
                                        context, RouteGenerator.kRateEnquiryScreen);
                                  },
                                ),
                                _QuickActionChip(
                                  icon: Icons.search,
                                  label: 'Investigation',
                                  color: opdAccent,
                                  onTap: () {
                                    HapticFeedback.selectionClick();
                                    Navigator.pushNamed(
                                        context, RouteGenerator.kInvestigationScreen);
                                  },
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Today's Doctors
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(_hPad, 18, _hPad, 8),
                      child: _SectionHeader(
                          title: "Today's Doctors",
                          actionText: 'See all',
                          onAction: () {}),
                    ),
                  ),
                  if (_loading)
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: _hPad),
                      sliver: SliverList.separated(
                        itemCount: 1,
                        itemBuilder: (_, __) =>
                            const _DoctorCardSkeleton(),
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                      ),
                    )
                  else if(_doctorsToday.isEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: _hPad),
                        child: const _EmptyStateCard(
                          icon: Icons.local_hospital_outlined,
                          message: 'No doctors available today',
                          hint: 'Check back later or book an appointment.',
                        ),
                      ),
                    )
                  else
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 156,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: _hPad),
                        physics: const BouncingScrollPhysics(),
                        itemCount: _doctorsToday.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, i) => _DoctorCard(
                          doctor: _doctorsToday[i],
                          accent: _getCardColor(_doctorsToday[i].color ?? ""),
                          onTap: () {
                            Navigator.pushNamed(context, "/DoctorDetailsScreen", arguments:_doctorsToday[i]);
                          }
                        ),
                      ),
                    ),
                  ),

                  // OPD Upcoming (separate list)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(_hPad, 22, _hPad, 8),
                      child: _SectionHeader(
                          title: 'Upcoming Appointment',
                          actionText: 'View all',
                          onAction: () {}),
                    ),
                  ),
                  if (_loading)
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: _hPad),
                      sliver: SliverList.separated(
                        itemCount: 2,
                        itemBuilder: (_, __) =>
                            const _AppointmentCardSkeleton(),
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                      ),
                    )
                  else if (_opdUpcoming.isEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: _hPad),
                        child: const _EmptyStateCard(
                          icon: Icons.local_hospital_outlined,
                          message: 'No upcoming OPD appointments',
                          hint: 'Book a new OPD slot from Quick actions.',
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: _hPad),
                      sliver: SliverList.separated(
                        itemCount: _opdUpcoming.length,
                        itemBuilder: (context, i) =>
                            _AppointmentCard(appt: _opdUpcoming[i]),
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                      ),
                    ),

                  // Optical Upcoming (separate list)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(_hPad, 22, _hPad, 8),
                      child: _SectionHeader(
                          title: 'Optical Appointment',
                          actionText: 'View all',
                          onAction: () {}),
                    ),
                  ),
                  if (_loading)
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: _hPad),
                      sliver: SliverList.separated(
                        itemCount: 1,
                        itemBuilder: (_, __) =>
                            const _AppointmentCardSkeleton(),
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                      ),
                    )
                  else if (_opticalUpcoming.isEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: _hPad),
                        child: const _EmptyStateCard(
                          icon: Icons.visibility_outlined,
                          message: 'No upcoming Optical appointments',
                          hint: 'Schedule a new visit from Quick actions.',
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: _hPad),
                      sliver: SliverList.separated(
                        itemCount: _opticalUpcoming.length,
                        itemBuilder: (context, i) =>
                            _AppointmentCard(appt: _opticalUpcoming[i]),
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                      ),
                    ),

                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Helpers / Decor ----------

  Widget _blob(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
              color: color.withOpacity(0.45),
              blurRadius: size * 0.25,
              spreadRadius: size * 0.02)
        ],
      ),
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
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.cyan, width: 2)
        ),
        child: Icon(icon, color: textPrimary),
      ),
    );
  }
}

// ===== Models =====
class _Doctor {
  final String name;
  final String specialization;
  final String time;
  const _Doctor(
      {required this.name, required this.specialization, required this.time});
}

class _Appointment {
  final String typeLabel; // 'OPD' or 'Optical'
  final String doctor;
  final String specialization;
  final String when;
  final String token;
  final String location;
  final Color accent;
  const _Appointment({
    required this.typeLabel,
    required this.doctor,
    required this.specialization,
    required this.when,
    required this.token,
    required this.location,
    required this.accent,
  });
}

// ===== Reusable UI =====

class _GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  const _GlassCard(
      {required this.child, this.padding = const EdgeInsets.all(18)});

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(22);
    return Container(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.10),
              blurRadius: 22,
              offset: const Offset(0, 12)),
          BoxShadow(
              color: Colors.white.withOpacity(0.6),
              blurRadius: 6,
              offset: const Offset(-2, -2)),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              borderRadius: radius,
              color: Colors.white.withOpacity(0.78),
              border:
                  Border.all(color: Colors.white.withOpacity(0.6), width: 1),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.88),
                  Colors.white.withOpacity(0.72)
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

class _SectionHeader extends StatelessWidget {
  final String title;
  final String actionText;
  final VoidCallback onAction;

  const _SectionHeader(
      {required this.title, required this.actionText, required this.onAction});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title,
            style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w700)),
        const Spacer(),
        InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onAction,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: Text(
              actionText,
              style: TextStyle(
                  color: Colors.black.withOpacity(0.65),
                  fontWeight: FontWeight.w600,
                  fontSize: 13.5),
            ),
          ),
        ),
      ],
    );
  }
}

class _QuickActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _QuickActionChip(
      {required this.icon,
      required this.label,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: color.withOpacity(0.45))),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 8),
              const Text(
                '',
                // placeholder to keep structure; actual text below:
              ),
              Text(
                label,
                style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                    fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DoctorCard extends StatelessWidget {
  final DoctorModel doctor;
  final Color accent;
  final VoidCallback onTap;

  const _DoctorCard({
    required this.doctor,
    required this.accent,
    required this.onTap,
  });

  String? _getDoctorSpecialization(String? details) {
    if (details == null || details.isEmpty) return null;
    final parts = details.split('//');
    return parts.isNotEmpty ? parts[0].trim() : null;
  }

  String? _getDoctorDegree(String? details) {
    if (details == null || details.isEmpty) return null;
    final parts = details.split('//');
    return parts.isNotEmpty ? parts[1].trim() : null;
  }

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(18);
    final screenW = MediaQuery.of(context).size.width;
    final double cardWidth = screenW < 360 ? screenW - 40 : 248;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Ink(
          width: cardWidth,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: radius,
            border: Border.all(color: accent.withOpacity(0.45), width: 2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _AvatarBadge(name: doctor.name ?? "Dr. NA", color: accent),
                const SizedBox(width: 12),
                // TEXT COLUMN — wraps instead of overflowing
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Doctor name: up to 2 lines
                      Text(
                        doctor.name ?? "Dr. NA",
                        maxLines: 2,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          letterSpacing: 0.2,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 10),
                      
                      Wrap(
                        spacing: 10,
                        runSpacing: 6,
                        children: [
                          _TypePill(
                            text: _getDoctorSpecialization(doctor.details) ??
                                "No details available",
                            color: accent,
                          ),
                          // _TypePill(
                          //   text: _getDoctorDegree(doctor.details) ??
                          //       "No Degree available",
                          //   color: accent,
                          // ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Time row (single line, compact) - constrained to available width
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.schedule, size: 16, color: accent),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              _formatDoctorAvailableTime(doctor.avilableTime),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDoctorAvailableTime(String? availableTime) {
    if (availableTime == null || availableTime.isEmpty) {
      return "No timing info";
    }
    List<String>time = availableTime.split('--').map((e) => e.trim()).toList();
    String formattedTime = '${time[0]} to ${time[1]}';

    return formattedTime;
  }
}

class _AvatarBadge extends StatelessWidget {
  final String name;
  final Color color;
  const _AvatarBadge({required this.name, required this.color});

  @override
  Widget build(BuildContext context) {
    final initials = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((e) => e.isNotEmpty)
        .map((e) => e.characters.first)
        .take(2)
        .join();
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
          radius: 26,
          backgroundColor: color.withOpacity(0.14),
          child: Text(
            initials.isEmpty ? '?' : initials,
            style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w700,
                fontSize: 16),
          ),
        ),
        Positioned(
          right: -2,
          bottom: -2,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2)),
            child: const Icon(Icons.check, size: 12, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final _Appointment appt;
  const _AppointmentCard({required this.appt});

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(18);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: radius,
        onTap: () => HapticFeedback.selectionClick(),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white, borderRadius: radius,
            border: Border.all(color: appt.accent.withOpacity(0.45), width: 2),
            //boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 14, offset: const Offset(0, 6))],
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon badge
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: appt.accent.withOpacity(0.12),
                    border: Border.all(color: appt.accent.withOpacity(0.45)),
                  ),
                  child: Icon(
                    appt.typeLabel.toLowerCase() == 'opd'
                        ? Icons.local_hospital_outlined
                        : Icons.visibility_outlined,
                    color: appt.accent,
                  ),
                ),
                const SizedBox(width: 12),
                // Texts
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _TypePill(text: appt.typeLabel, color: appt.accent),
                        Row(
                          children: [
                            // const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                appt.when,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.70),
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          appt.doctor,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2),
                        ),
                        const SizedBox(height: 2),
                        Text(appt.specialization,
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.65),
                                fontSize: 13.5)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.place_outlined,
                                size: 16, color: appt.accent),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                appt.location,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.75),
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ]),
                ),
                const SizedBox(width: 10),
                _TokenPill(text: appt.token, color: appt.accent),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TypePill extends StatelessWidget {
  final String text;
  final Color color;
  const _TypePill({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: color.withOpacity(0.12),
        border: Border.all(color: color.withOpacity(0.45)),
      ),
      child: Text(
        text,
        style: TextStyle(
            color: Colors.black.withOpacity(0.85),
            fontWeight: FontWeight.w700,
            fontSize: 12.5,
            letterSpacing: 0.3),
      ),
    );
  }
}

class _TokenPill extends StatelessWidget {
  final String text;
  final Color color;
  const _TokenPill({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: color.withOpacity(0.12),
        border: Border.all(color: color.withOpacity(0.45)),
      ),
      child: Text(text,
          style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w700,
              fontSize: 12.5,
              letterSpacing: 0.3)),
    );
  }
}

// ===== Skeleton Loaders (Pulsing) =====

class _Pulse extends StatefulWidget {
  final Widget child;
  const _Pulse({required this.child});

  @override
  State<_Pulse> createState() => _PulseState();
}

class _PulseState extends State<_Pulse> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, child) {
        final t = Tween<double>(begin: 0.5, end: 1.0).transform(
            CurvedAnimation(parent: _c, curve: Curves.easeInOut).value);
        return Opacity(opacity: t, child: child);
      },
      child: widget.child,
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double height;
  final double width;
  final double radius;
  const _SkeletonBox(
      {required this.height, required this.width, this.radius = 10});

  @override
  Widget build(BuildContext context) {
    return _Pulse(
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.6),
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: Colors.white.withOpacity(0.7)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 4))
          ],
        ),
      ),
    );
  }
}

class _DoctorCardSkeleton extends StatelessWidget {
  const _DoctorCardSkeleton();

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final double cardWidth = screenW < 360 ? screenW - 40 : 248; // matches real card

    return Container(
      width: cardWidth,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // gentle sheen
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.white.withOpacity(0.18),
                      Colors.white.withOpacity(0.04),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.22, 0.55],
                  ),
                ),
              ),
            ),
          ),
          // inner hairline
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                margin: const EdgeInsets.all(1.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.30),
                    width: 0.8,
                  ),
                ),
              ),
            ),
          ),
          // content placeholders
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SkeletonBox(height: 52, width: 32, radius: 26),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    // Simulate two lines of a long name safely
                    _SkeletonBox(height: 14, width: 180),
                    SizedBox(height: 6),
                    _SkeletonBox(height: 14, width: 140),
                    SizedBox(height: 10),
                    // specialization line
                    _SkeletonBox(height: 12, width: 140),
                    SizedBox(height: 10),
                    // time row
                    _SkeletonBox(height: 12, width: 120),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AppointmentCardSkeleton extends StatelessWidget {
  const _AppointmentCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 14,
              offset: const Offset(0, 6))
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SkeletonBox(height: 48, width: 48, radius: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                // pill + when
                _SkeletonBox(height: 12, width: 160, radius: 8),
                SizedBox(height: 10),
                _SkeletonBox(height: 14, width: 180),
                SizedBox(height: 6),
                _SkeletonBox(height: 12, width: 120),
                SizedBox(height: 10),
                _SkeletonBox(height: 12, width: 200),
              ],
            ),
          ),
          const SizedBox(width: 10),
          const _SkeletonBox(height: 28, width: 60, radius: 999),
        ],
      ),
    );
  }
}

class _EmptyStateCard extends StatelessWidget {
  final IconData icon;
  final String message;
  final String hint;
  const _EmptyStateCard(
      {required this.icon, required this.message, required this.hint});

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(18);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: radius,
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 6))
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: Colors.black.withOpacity(0.06)),
            child: Icon(icon, color: Colors.black54),
          ),
          const SizedBox(width: 12),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(message,
                  style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w800,
                      fontSize: 14.5)),
              const SizedBox(height: 4),
              Text(hint,
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.65), fontSize: 13)),
            ]),
          ),
        ],
      ),
    );
  }
}
