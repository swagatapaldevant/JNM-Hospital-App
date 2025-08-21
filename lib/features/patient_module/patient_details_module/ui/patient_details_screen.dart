import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/locator.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/resource.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/status.dart';
import 'package:jnm_hospital_app/core/services/localStorage/shared_pref.dart';
import 'package:jnm_hospital_app/core/services/routeGenerator/route_generator.dart';
import 'package:jnm_hospital_app/features/patient_module/model/patient_details/patient_details_model.dart';
import 'package:jnm_hospital_app/features/patient_module/new%20patient_module/patient_dashboard/widgets/app_drawer.dart';
import 'package:jnm_hospital_app/features/patient_module/patient_details_module/data/patient_details_usecase.dart';

class PatientDetailsScreen extends StatefulWidget {
  const PatientDetailsScreen({super.key});

  @override
  State<PatientDetailsScreen> createState() => _PatientDetailsScreenState();
}

class _PatientDetailsScreenState extends State<PatientDetailsScreen>
    with TickerProviderStateMixin {
  // Background palette
  static const Color bg1 = Color(0xFFF0F0F0);
  static const Color bg2 = Color(0xFFCDDBFF);
  static const Color textPrimary = Colors.black87;
  final SharedPref _pref = getIt<SharedPref>();
  final PatientDetailsUsecase _patientDetailsUsecase =
      getIt<PatientDetailsUsecase>();
  PatientDetailsResponse? patientDetailsData;

  String _patientName = '';
  String _patientAge = '';
  String _patientGender = '';
  String _patientPhone = '';

  // Accents
  static const Color opdAccent = Color(0xFF00C2FF); // sky blue
  static const Color opticalAccent = Color(0xFF7F5AF0); // violet
  static const double _hPad = 20;

  bool _loading = true;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    // Simulate initial fetch
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() => _loading = false);
    });
    loadPatientData();
    getPatientDetails();
  }

  Future<void> loadPatientData() async {
    _patientName = await _pref.getUserName() ?? "No name";
    _patientGender = await _pref.getUserGender() ?? "No gender";
    _patientPhone = await _pref.getUserPhone() ?? "No phone";
    setState(() {});
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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> getPatientDetails() async {
    setState(() {
      isLoading = true;
    });

    final Resource resource = await _patientDetailsUsecase.getPatientDetails();

    if (resource.status == STATUS.SUCCESS) {
      // Handle successful response
      print("Success");
      final data = resource.data as Map<String, dynamic>;
      patientDetailsData = PatientDetailsResponse.fromJson(data);
      print(patientDetailsData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppDrawer(),
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
                              icon: Icons.arrow_back_ios_new_rounded,
                              onTap: () => Navigator.pop(context)),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Patient Details',
                              style: TextStyle(
                                color: textPrimary,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  //patient details card
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: _hPad, vertical: 12),
                      child: _GlassCard(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Row 1: Patient Name + Age
                          Row(
                            children: [
                              Expanded(
                                child: _buildInfoItem(
                                  icon: Icons.person,
                                  label: "Patient Name",
                                  value: _patientName,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildInfoItem(
                                  icon: Icons.cake,
                                  label: "Age",
                                  value: _patientAge,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 24),

                          // Row 2: Gender + Phone
                          Row(
                            children: [
                              Expanded(
                                child: _buildInfoItem(
                                  icon: Icons
                                      .male, // can also check female/female_outlined
                                  label: "Gender",
                                  value: _patientGender,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildInfoItem(
                                  icon: Icons.phone,
                                  label: "Phone",
                                  value: _patientPhone,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                    ),
                  ),
                  if (patientDetailsData != null)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: buildPatientDetailsGrid(patientDetailsData!),
                      ),
                    )
                  else
                    SliverToBoxAdapter(
                      child: Center(
                        child: CircularProgressIndicator(),
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

  Widget buildPatientDetailsGrid(PatientDetailsResponse patientDetailsData) {
    final tiles = <Widget>[];

    if (patientDetailsData.opdDetails.isNotEmpty) {
      tiles.add(const GlassTile(icon: Icons.local_hospital, label: "OPD"));
    }
    if (patientDetailsData.ipdDetails.isNotEmpty) {
      tiles.add(const GlassTile(icon: Icons.bed, label: "IPD"));
    }
    if (patientDetailsData.daycareDetails.isNotEmpty) {
      tiles.add(const GlassTile(icon: Icons.healing, label: "Daycare"));
    }
    if (patientDetailsData.emgDetails.isNotEmpty) {
      tiles.add(const GlassTile(icon: Icons.emergency, label: "Emergency"));
    }
    if (patientDetailsData.receiptDetails.isNotEmpty) {
      tiles.add(
        GlassTile(icon: Icons.receipt_long, label: "Receipts", onTap: () {
          Navigator.pushNamed(
            context,
            RouteGenerator.kPatientReceiptDetailsScreen,
            arguments: patientDetailsData.receiptDetails.first,
          );
        } )
        );
    }
    if (patientDetailsData.billDetails.isNotEmpty) {
      tiles.add(GlassTile(
        icon: Icons.payments,
        label: "Bills",
        onTap: () {
          Navigator.pushNamed(
            context,
            RouteGenerator.kPatientBillDetailsScreen,
            arguments: patientDetailsData.billDetails.first,
          );
        },
      ));
    }
    if (patientDetailsData.refundDetails.isNotEmpty) {
      tiles.add(const GlassTile(icon: Icons.undo, label: "Refunds"));
    }
    if (patientDetailsData.noteDetails.isNotEmpty) {
      tiles.add(const GlassTile(icon: Icons.note, label: "Notes"));
    }
    if (patientDetailsData.emrDetails.isNotEmpty) {
      tiles.add(const GlassTile(icon: Icons.history, label: "EMR"));
    }

    if (tiles.isEmpty) {
      return const SizedBox.shrink(); // nothing to show
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7), // light glassy bg
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // heading
          const Padding(
            padding: EdgeInsets.only(left: 12, bottom: 15),
            child: Text(
              "Patient Records",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ),

          // grid
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 180), // ⬅ min height
            child: GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 1,
              children: tiles,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: Colors.blueGrey),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black54,
          ),
          textAlign: TextAlign.center, // 🔹 center the text itself
        ),
      ],
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
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 16,
                offset: const Offset(0, 6)),
            BoxShadow(
                color: Colors.white.withOpacity(0.85),
                blurRadius: 4,
                offset: const Offset(-2, -2)),
          ],
        ),
        child: Icon(icon, color: textPrimary),
      ),
    );
  }
}

class GlassTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const GlassTile({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap?.call();
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 195, 146, 252).withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1.2,
              ),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 28, color: Colors.blueGrey[800]),
                const SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
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
