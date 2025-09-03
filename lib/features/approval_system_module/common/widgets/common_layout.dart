import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jnm_hospital_app/core/services/routeGenerator/route_generator.dart';
import 'package:jnm_hospital_app/features/patient_module/model/patient_details/patient_details_model.dart';
import 'package:jnm_hospital_app/features/patient_module/new%20patient_module/patient_dashboard/widgets/app_drawer.dart';

class ApprovalSystemLayout extends StatefulWidget {
  const ApprovalSystemLayout({super.key, required this.slivers, this.controller});

  final List<Widget> slivers;
  final ScrollController? controller;

  @override
  State<ApprovalSystemLayout> createState() => _ApprovalSystemLayoutState();
}

class _ApprovalSystemLayoutState extends State<ApprovalSystemLayout>
    with TickerProviderStateMixin {
  // Background palette
  static const Color bg1 = Color(0xFFF0F0F0);
  static const Color bg2 = Color(0xFFCDDBFF);

  PatientDetailsResponse? patientDetailsData;

  // Accents
  static const Color opdAccent = Color(0xFF00C2FF); // sky blue
  static const Color opticalAccent = Color(0xFF7F5AF0); // violet

  @override
  void initState() {
    super.initState();
  }

  Future<void> _onRefresh() async {
    HapticFeedback.lightImpact();
    // TODO: call your API here
    await Future.delayed(const Duration(seconds: 1)); // simulate
    if (!mounted) return;
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Soft background
          // if (isLoading)
          Positioned.fill(
            child: Container(
              color:
                  Colors.black.withOpacity(0.4), // transparent dark background
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.white,
                ),
              ),
            ),
          ),
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
                controller: widget.controller,
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                slivers: widget.slivers,
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
      tiles.add(GlassTile(
          icon: Icons.receipt_long,
          label: "Receipts",
          onTap: () {
            Navigator.pushNamed(
              context,
              RouteGenerator.kPatientReceiptDetailsScreen,
              arguments: patientDetailsData.receiptDetails.first,
            );
          }));
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
