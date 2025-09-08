import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/api_endpoint.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/locator.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/status.dart';
import 'package:jnm_hospital_app/core/services/localStorage/shared_pref.dart';
import 'package:jnm_hospital_app/core/services/routeGenerator/route_generator.dart';
import 'package:jnm_hospital_app/core/utils/helper/common_utils.dart';
import 'package:jnm_hospital_app/features/approval_system_module/approval_dashboard/data/approval_dashboard_usecases_impl.dart';
import 'package:jnm_hospital_app/features/approval_system_module/common/widgets/glasscard.dart';
import 'package:jnm_hospital_app/features/patient_module/patient_dashboard/widgets/app_drawer.dart';

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

  bool isLoading = true;

  final Map<String, int> _pendingCount = {};
  final SharedPref _pref = getIt<SharedPref>();
  List<String> approvalPermissionList = [];

  void loadApprovalPerms() async {
    approvalPermissionList = await _pref.getApprovalPermissionList();
    print(approvalPermissionList);
  }

  Future<void> getPendingCount() async {
    setState(() {
      isLoading = true;
    });

    final resource = await ApprovalDashboardUseCasesImpl().getPendingCount();

    if (resource.status == STATUS.SUCCESS) {
      final data = resource.data as List;
      setState(() {
        _pendingCount.clear();
        for (var item in data) {
          _pendingCount[item['section']] = item['total_count'];
        }
        isLoading = false;
      });
    } else {
      setState(() {
        CommonUtils().flutterSnackBar(
            context: context,
            mes: resource.message ?? "Failed to get Approval List Count",
            messageType: 4);
        isLoading = false;
      });
    }

    print(_pendingCount);
  }

  final Map<String, Map<String, dynamic>> approvalConfig = {
    "OPD": {
      "icon": Icons.local_hospital,
      "label": "OPD",
      "api": ApiEndPoint.approvalSystemOPD,
      "title": "OPD Approval",
      "other_ids": [],
      "approve_list_url_suffx": "opd"
    },
    "IPD": {
      "icon": Icons.bed,
      "label": "IPD/Daycare",
      "api": ApiEndPoint.approvalSystemIPD,
      "title": "IPD/Daycare Approval",
      "other_ids": ["DAYCARE"],
      "approve_list_url_suffx": "ipd"
    },
    "OT": {
      "icon": Icons.history,
      "label": "OT",
      "api": ApiEndPoint.approvalSystemOT,
      "title": "OT Approval",
      "other_ids": [],
      "approve_list_url_suffx": "ot"
    },
    "EMG": {
      "icon": Icons.history,
      "label": "EMG",
      "api": ApiEndPoint.approvalSystemEMG,
      "title": "EMG Approval",
      "other_ids": [],
      "approve_list_url_suffx": "emr"
    },
    "OP": {
      "icon": Icons.receipt_long,
      "label": "OP",
      "api": ApiEndPoint.approvalSystemOP,
      "title": "OP Approval",
      "other_ids": [],
      "approve_list_url_suffx": "op"
    },
    "DIALYSIS": {
      "icon": Icons.receipt_long,
      "label": "DIALYSIS",
      "api": ApiEndPoint.approvalSystemDialysis,
      "title": "Dialysis Approval",
      "other_ids": [],
      "approve_list_url_suffx": "dialysis"
    },
    "INVESTIGATION": {
      "icon": Icons.payments,
      "label": "INVESTIGATION",
      "api": ApiEndPoint.approvalSystemInvestigation,
      "title": "Investigation Approval",
      "other_ids": [],
      "approve_list_url_suffx": "investigation"
    },
  };

  @override
  void initState() {
    super.initState();
    getPendingCount();
    loadApprovalPerms();
  }

  Future<void> _onRefresh() async {
    HapticFeedback.lightImpact();
    getPendingCount();
    await Future.delayed(const Duration(seconds: 1)); // simulate
    if (!mounted) return;

    // Example: you could also shuffle/add items here to visualize updates
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

  List<String> tabList = [];
  List<String> tabUrl = [];

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
                  SliverPersistentHeader(
                    delegate: _ApprovalDashboardHeaderDelegate(() {}),
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
                              "Wishing you a healthy day! Heres what's lined up for you.",
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
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            RouteGenerator.kApprovedListScreen,
                            arguments: {
                              "tabList": tabList,
                              "tabUrl": tabUrl,
                            },
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF4CAF50),
                                Color(0xFF2E7D32)
                              ], // green success
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(18),
                          child: Row(
                            children: [
                              // Icon
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white24,
                                ),
                                child: const Icon(Icons.check_circle_rounded,
                                    color: Colors.white, size: 28),
                              ),
                              const SizedBox(width: 16),

                              // Text
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      "Approved List",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "See all requests you’ve already approved",
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const Icon(Icons.arrow_forward_ios_rounded,
                                  color: Colors.white, size: 18),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 16,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPatientDetailsGrid(BuildContext context) {
    tabList.clear();
    tabUrl.clear();
    final tiles = approvalConfig.entries
        .map((entry) {
          final key = entry.key;
          final config = entry.value;
          int count = 0;

          if (!approvalPermissionList.contains(key)) {
            return null;
          } else {
            tabList.add(config["label"]);
            tabUrl.add(config["approve_list_url_suffx"]);
          }

          count += _pendingCount[key] ?? 0;

          config["other_ids"].forEach((id) {
            count += _pendingCount[id] ?? 0;
          });
          return GlassTile(
            icon: config["icon"] as IconData,
            label: config["label"],
            pendingCount: _pendingCount[key]?.toString() ?? "0",
            onTap: () {
              Navigator.pushNamed(
                context,
                RouteGenerator.kApprovalDetailscreen,
                arguments: {
                  'apiEndpoint': config["api"],
                  'title': config["title"],
                },
              );
            },
          );
        })
        .whereType<Widget>()
        .toList();

    //if (tiles.isEmpty) return const SizedBox.shrink();
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

    final aspect = contentW < 380 ? 0.95 : 1.0;

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
          isLoading
              ? GridView.count(
                  crossAxisCount: crossAxisCount,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: aspect,
                  children: List.generate(
                    6,
                    (index) => _PulseSkeleton(),
                  ),
                )
              : tiles.isEmpty
                  ? const SizedBox.shrink()
                  : GridView.count(
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

class _ApprovalDashboardHeaderDelegate extends SliverPersistentHeaderDelegate {
  final VoidCallback onNotificationTap;

  _ApprovalDashboardHeaderDelegate(this.onNotificationTap);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Approval Dashboard',
              style: TextStyle(
                // color: ,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
          ),
          _roundIconButton(
            icon: Icons.notifications_none_rounded,
            onTap: onNotificationTap,
          ),
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
        child: Icon(icon),
      ),
    );
  }

  @override
  double get maxExtent => 70;

  @override
  double get minExtent => 70;

  @override
  bool shouldRebuild(covariant _ApprovalDashboardHeaderDelegate oldDelegate) {
    return oldDelegate.onNotificationTap != onNotificationTap;
  }
}

class _PulseSkeleton extends StatefulWidget {
  @override
  State<_PulseSkeleton> createState() => _PulseSkeletonState();
}

class _PulseSkeletonState extends State<_PulseSkeleton>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _shimmerController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();

    // Pulse animation for opacity
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _pulseAnimation =
        Tween<double>(begin: 0.4, end: 1.0).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Shimmer animation for gradient movement
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    _shimmerAnimation = Tween<double>(
      begin: -2.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOutSine,
    ));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: Listenable.merge([_pulseAnimation, _shimmerAnimation]),
      builder: (context, child) {
        return FadeTransition(
          opacity: _pulseAnimation,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment(-1.0 + _shimmerAnimation.value, -1.0),
                end: Alignment(1.0 + _shimmerAnimation.value, 1.0),
                colors: isDark
                    ? [
                        Colors.grey.shade800,
                        Colors.grey.shade700,
                        Colors.grey.shade600,
                        Colors.grey.shade700,
                        Colors.grey.shade800,
                      ]
                    : [
                        Colors.grey.shade200,
                        Colors.grey.shade100,
                        Colors.white,
                        Colors.grey.shade100,
                        Colors.grey.shade200,
                      ],
                stops: const [0.0, 0.35, 0.5, 0.65, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: (isDark ? Colors.black : Colors.grey.shade300)
                      .withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
