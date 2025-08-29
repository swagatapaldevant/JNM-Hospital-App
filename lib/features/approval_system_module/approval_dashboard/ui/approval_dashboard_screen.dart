import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/api_endpoint.dart';
import 'package:jnm_hospital_app/core/services/routeGenerator/route_generator.dart';
import 'package:jnm_hospital_app/features/approval_system_module/common/widgets/glasscard.dart';
import 'package:jnm_hospital_app/features/patient_module/new%20patient_module/patient_dashboard/widgets/app_drawer.dart';

class ApprovalDashboardScreen extends StatefulWidget {
  const ApprovalDashboardScreen({super.key});

  @override
  State<ApprovalDashboardScreen> createState() =>
      _ApprovalDashboardScreenState();
}

class _ApprovalDashboardScreenState extends State<ApprovalDashboardScreen>
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


  @override
  void initState() {
    super.initState();
    // Simulate initial fetch
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() => _loading = false);
    });
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
                          // _roundIconButton(
                          //   icon: Icons.menu_rounded,
                          //   onTap: () =>
                          //       _scaffoldKey.currentState?.openDrawer(),
                          // ),
                          const Expanded(
                            child: Text(
                              'Approval Dashboard',
                              style: TextStyle(
                                color: textPrimary,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
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
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: buildPatientDetailsGrid(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPatientDetailsGrid(
      BuildContext context) {
    final tiles = <Widget>[];

    tiles.add(GlassTile(
      icon: Icons.local_hospital,
      label: "OPD",
      onTap: () {
        Navigator.pushNamed(
            context,
            RouteGenerator.kApprovalDetailscreen,
            arguments: {
              'apiEndpoint': ApiEndPoint.approvalSystemOPD,
              'title': 'OPD Approval'
            }
        );
      },
    ));

    tiles.add(GlassTile(
      icon: Icons.bed,
      label: "IPD/Daycare",
      onTap: () {
        Navigator.pushNamed(
            context,
            RouteGenerator.kApprovalDetailscreen,
            arguments: {
              'apiEndpoint': ApiEndPoint.approvalSystemIPD,
              'title': 'IPD/Daycare Approval'
            }
        );
      },
    ));


    tiles.add(GlassTile(
      icon: Icons.history,
      label: "EMR",
      onTap: () {
        Navigator.pushNamed(
            context,
            RouteGenerator.kApprovalDetailscreen,
            arguments: {
              'apiEndpoint': ApiEndPoint.approvalSystemEMR,
              'title': 'EMR Approval'
            }
        );
      },
    ));

    tiles.add(GlassTile(
      icon: Icons.receipt_long,
      label: "DIALYSIS",
      onTap: () {
        Navigator.pushNamed(
          context,
          RouteGenerator.kApprovalDetailscreen,
          arguments: {
            'apiEndpoint': ApiEndPoint.approvalSystemDialysis,
            'title': 'Dialysis Approval'
          },
        );
      },
    ));


    tiles.add(GlassTile(
      icon: Icons.payments,
      label: "INVESTIGATION",
      onTap: () {
        Navigator.pushNamed(
          context,
          RouteGenerator.kApprovalDetailscreen,
          arguments: {
            'apiEndpoint': ApiEndPoint.approvalSystemInvestigation,
            'title': 'Investigation Approval'
          },
        );
      },
    ));



    if (tiles.isEmpty) return const SizedBox.shrink();
    const double _maxContentWidth = 720.0;
    final screenW = MediaQuery.of(context).size.width;
    final contentW = screenW < _maxContentWidth ? screenW : _maxContentWidth;

    int crossAxisCount;
    if (contentW < 380) {
      crossAxisCount = 2;
    } else if (contentW < 640) {
      crossAxisCount = 2;
    } else {
      crossAxisCount = 4;
    }

    final aspect = contentW < 380 ? 0.15 : 1.1;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 12, bottom: 15),
            child: Text(
              "Approval System",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ),
          GridView.count(
            crossAxisCount: crossAxisCount,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: aspect,
            children: tiles,
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
            border: Border.all(color: Colors.cyan, width: 2)),
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


