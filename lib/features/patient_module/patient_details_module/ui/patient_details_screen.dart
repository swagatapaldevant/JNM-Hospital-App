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
  // Background palette (kept exactly the same)
  static const Color bg1 = Color(0xFFF0F0F0);
  static const Color bg2 = Color(0xFFCDDBFF);
  static const Color textPrimary = Colors.black87;

  // Accents (kept exactly the same)
  static const Color opdAccent = Color(0xFF00C2FF); // sky blue
  static const Color opticalAccent = Color(0xFF7F5AF0); // violet
  static const double _hPad = 20;

  final SharedPref _pref = getIt<SharedPref>();
  final PatientDetailsUsecase _patientDetailsUsecase =
      getIt<PatientDetailsUsecase>();

  PatientDetailsResponse? patientDetailsData;

  String _patientName = '';
  String _patientAge = ''; // retained but not used directly (age is computed)
  String _patientGender = '';
  String _patientPhone = '';

  bool _loading = true;
  bool isLoading = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // Soft initial loading shimmer
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
    // TODO: call your API refresh here
    await getPatientDetails();
    await Future.delayed(const Duration(milliseconds: 350));
    if (!mounted) return;
    setState(() => _loading = false);
  }

  Future<void> getPatientDetails() async {
    setState(() {
      isLoading = true;
    });

    final Resource resource = await _patientDetailsUsecase.getPatientDetails();

    if (resource.status == STATUS.SUCCESS) {
      final data = resource.data as Map<String, dynamic>;
      patientDetailsData = PatientDetailsResponse.fromJson(data);
      // debug
      // print(patientDetailsData);
    } else {
      // Optionally show a toast/snack if failed
      // debugPrint('Failed to fetch patient details: ${resource.message}');
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final name =
        (patientDetailsData?.patientDetails?.name?.trim().isNotEmpty ?? false)
            ? patientDetailsData!.patientDetails?.name!
            : _patientName;

    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Soft background (unchanged)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [bg1, bg2],
              ),
            ),
          ),
          // Decorative blobs (unchanged)
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
                          Expanded(
                            child: Text(
                              name!.isNotEmpty ? name : 'Patient Details',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
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

                  // === Patient Identity Card (modern & glassy) ===
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: _hPad, vertical: 12),
                      child: (patientDetailsData == null && _loading)
                          ? _identitySkeleton()
                          : _PatientIdentityCard(
                              name: name,
                              gender:
                                  (patientDetailsData?.patientDetails?.gender ??
                                          _patientGender)
                                      .toString(),
                              phone:
                                  (patientDetailsData?.patientDetails?.phone ??
                                          _patientPhone)
                                      .toString(),
                              bloodGroup: (patientDetailsData
                                          ?.patientDetails?.bloodGroup ??
                                      '')
                                  .toString(),
                              identificationName: (patientDetailsData
                                          ?.patientDetails
                                          ?.identificationNumber ??
                                      '')
                                  .toString(),
                              identificationNumber: (patientDetailsData
                                          ?.patientDetails
                                          ?.identificationNumber ??
                                      '')
                                  .toString(),
                              guardianName: (patientDetailsData
                                          ?.patientDetails?.guardianName ??
                                      '')
                                  .toString(),
                              relation: (patientDetailsData
                                          ?.patientDetails?.guardianName ??
                                      '')
                                  .toString(),
                              address: (patientDetailsData
                                          ?.patientDetails?.address ??
                                      '')
                                  .toString(),
                              dobYears:
                                  patientDetailsData?.patientDetails?.dobYear,
                              dobMonths:
                                  patientDetailsData?.patientDetails?.dobMonth,
                              dobDays:
                                  patientDetailsData?.patientDetails?.dobDay,
                              dateOfBirthIso: patientDetailsData
                                  ?.patientDetails?.dateOfBirth
                                  ?.toString(),
                            ),
                    ),
                  ),

                  // Patient Records Grid (unchanged logic, with minor polish)
                  if (patientDetailsData != null)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: buildPatientDetailsGrid(patientDetailsData!),
                      ),
                    )
                  else if (!isLoading)
                    const SliverToBoxAdapter(child: SizedBox.shrink())
                  else
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: Center(child: CircularProgressIndicator()),
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

  // ================== Sections ==================

  Widget buildPatientDetailsGrid(PatientDetailsResponse patientDetailsData) {
    final tiles = <Widget>[];

    if (patientDetailsData.opdDetails.isNotEmpty) {
      tiles.add(GlassTile(
        icon: Icons.local_hospital,
        label: "OPD",
        onTap: () {
          Navigator.pushNamed(
            context,
            RouteGenerator.kPatientOpdDetailsScreen,
            arguments: patientDetailsData.opdDetails,
          );
        },
      ));
    }
    if (patientDetailsData.ipdDetails.isNotEmpty) {
      tiles.add(GlassTile(
        icon: Icons.bed,
        label: "IPD",
      ));
    }
    if (patientDetailsData.daycareDetails.isNotEmpty) {
      tiles.add(GlassTile(
        icon: Icons.healing,
        label: "Daycare",
        onTap: () {
          Navigator.pushNamed(
            context,
            RouteGenerator.kPatientDaycareDetailsScreen,
            arguments: patientDetailsData.daycareDetails,
          );
        },
      ));
    }
    if (patientDetailsData.emgDetails.isNotEmpty) {
      tiles.add(GlassTile(
        icon: Icons.emergency,
        label: "Emergency",
        onTap: () {
          Navigator.pushNamed(
            context,
            RouteGenerator.kPatientEmgDetailsScreen,
            arguments: patientDetailsData.emgDetails,
          );
        },
      ));
    }
    if (patientDetailsData.receiptDetails.isNotEmpty) {
      tiles.add(GlassTile(
        icon: Icons.receipt_long,
        label: "Receipts",
        onTap: () {
          Navigator.pushNamed(
            context,
            RouteGenerator.kPatientReceiptDetailsScreen,
            arguments: patientDetailsData.receiptDetails,
          );
        },
      ));
    }
    if (patientDetailsData.billDetails.isNotEmpty) {
      tiles.add(GlassTile(
        icon: Icons.payments,
        label: "Bills",
        onTap: () {
          Navigator.pushNamed(
            context,
            RouteGenerator.kPatientBillDetailsScreen,
            arguments: patientDetailsData.billDetails,
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
      tiles.add( GlassTile(
          icon: Icons.history,
          label: "EMR",
          onTap: () {
            Navigator.pushNamed(
              context,
              RouteGenerator.kPatientEmrDetailsScreen,
              arguments: patientDetailsData.emrDetails,
            );
          },

      ));
    }

    if (tiles.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 180),
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

  // Shimmer/skeleton for identity card while loading
  Widget _identitySkeleton() {
    return _GlassCard(
      child: _Pulse(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white70,
                  )),
              const SizedBox(width: 14),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 18, width: 180, color: Colors.white70),
                  const SizedBox(height: 10),
                  Container(
                      height: 30,
                      width: double.infinity,
                      color: Colors.white70),
                ],
              )),
            ]),
            const SizedBox(height: 18),
            Container(height: 14, width: 220, color: Colors.white70),
          ],
        ),
      ),
    );
  }
}

// ============ Identity Card & Building Blocks ============

class _PatientIdentityCard extends StatelessWidget {
  final String name;
  final String gender;
  final String phone;
  final String bloodGroup;
  final String identificationName;
  final String identificationNumber;
  final String guardianName;
  final String relation;
  final String address;
  final int? dobYears;
  final int? dobMonths;
  final int? dobDays;
  final String? dateOfBirthIso;

  const _PatientIdentityCard({
    required this.name,
    required this.gender,
    required this.phone,
    required this.bloodGroup,
    required this.identificationName,
    required this.identificationNumber,
    required this.guardianName,
    required this.relation,
    required this.address,
    this.dobYears,
    this.dobMonths,
    this.dobDays,
    this.dateOfBirthIso,
  });

  @override
  Widget build(BuildContext context) {
    final initials = _initialsFromName(name);
    final ageText = _prettyAge(
      dobYears: dobYears,
      dobMonths: dobMonths,
      dobDays: dobDays,
      dateOfBirthIso: dateOfBirthIso,
    );

    return _GlassCard(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: Avatar + Name + Chips
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _GradientAvatar(initials: initials),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Text(
                      name.isNotEmpty ? name : 'Unknown Patient',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: _PatientDetailsScreenState.textPrimary,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Chips row
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        if (gender.trim().isNotEmpty)
                          _chip(icon: Icons.person_outline, label: gender),
                        if (ageText.isNotEmpty)
                          _chip(icon: Icons.cake_outlined, label: ageText),
                        if (bloodGroup.trim().isNotEmpty &&
                            bloodGroup.toUpperCase() != "NULL")
                          _chip(
                              icon: Icons.bloodtype_outlined,
                              label: bloodGroup.toUpperCase()),
                        if (identificationName.trim().isNotEmpty)
                          _chip(
                            icon: Icons.badge_outlined,
                            label: identificationNumber.trim().isNotEmpty
                                ? "$identificationName • $identificationNumber"
                                : identificationName,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(),

          // Contact & Guardian section
          const SizedBox(height: 8),
          _iconLine(
            icon: Icons.phone_rounded,
            title: 'Phone',
            value: phone.isNotEmpty ? phone : '—',
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _smallActionButton(
                  tooltip: 'Copy',
                  icon: Icons.copy_rounded,
                  onTap: () {
                    if (phone.trim().isEmpty) return;
                    Clipboard.setData(ClipboardData(text: phone));
                    _snack(context, 'Phone copied');
                  },
                ),
                const SizedBox(width: 6),
                _smallActionButton(
                  tooltip: 'Call',
                  icon: Icons.call_rounded,
                  onTap: () {
                    // Integrate url_launcher if desired
                    _snack(context, 'Would call $phone');
                  },
                ),
              ],
            ),
          ),
          if (guardianName.trim().isNotEmpty || relation.trim().isNotEmpty) ...[
            const SizedBox(height: 10),
            _iconLine(
              icon: Icons.family_restroom_rounded,
              title: 'Guardian',
              value: [
                if (guardianName.trim().isNotEmpty) guardianName.trim(),
                if (relation.trim().isNotEmpty) "($relation)"
              ].join(' ').trim(),
            ),
          ],
          if (address.trim().isNotEmpty) ...[
            const SizedBox(height: 10),
            _iconLine(
              icon: Icons.location_on_outlined,
              title: 'Address',
              value: address.trim(),
            ),
          ],

          const SizedBox(height: 6),
        ],
      ),
    );
  }

  // Simple floating snackbar helper
  void _snack(BuildContext context, String message) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 1400),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  // --- Small building blocks ---

  static Widget _chip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.6), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.blueGrey[800]),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _iconLine({
    required IconData icon,
    required String title,
    required String value,
    Widget? trailing,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.blueGrey[700]),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: Colors.black87)),
              const SizedBox(height: 3),
              Text(value,
                  style: const TextStyle(
                      fontSize: 13, color: Colors.black54, height: 1.25)),
            ],
          ),
        ),
        if (trailing != null) trailing,
      ],
    );
  }

  static Widget _smallActionButton({
    required IconData icon,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        borderRadius: BorderRadius.circular(10),
        child: Ink(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, size: 18, color: Colors.blueGrey[800]),
        ),
      ),
    );
  }
}

class _GradientAvatar extends StatelessWidget {
  final String initials;

  const _GradientAvatar({required this.initials});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _PatientDetailsScreenState.opdAccent, // keep your palette
            _PatientDetailsScreenState.opticalAccent,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

// --- Shared helpers ---
String _initialsFromName(String name) {
  final parts =
      name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
  if (parts.isEmpty) return 'P';
  if (parts.length == 1) return parts.first.characters.first.toUpperCase();
  return (parts.first.characters.first + parts.last.characters.first)
      .toUpperCase();
}

/// Prefer dob_year/month/day if present; else parse ISO dob.
/// Safely handles weird combos (e.g., dob_day = 0) and future dates.
String _prettyAge({
  int? dobYears,
  int? dobMonths,
  int? dobDays,
  String? dateOfBirthIso,
}) {
  // If API pieces are present, use them (hide zeros).
  if (dobYears != null || dobMonths != null || dobDays != null) {
    final y = (dobYears ?? 0);
    final m = (dobMonths ?? 0);
    final d = (dobDays ?? 0);
    final parts = <String>[];
    if (y > 0) parts.add('$y yr');
    if (m > 0) parts.add('$m mo');
    if (d > 0) parts.add('$d d');
    return parts.isNotEmpty ? parts.join(' ') : '';
  }

  // Otherwise compute from ISO.
  if (dateOfBirthIso != null && dateOfBirthIso.trim().isNotEmpty) {
    final dob = DateTime.tryParse(dateOfBirthIso);
    if (dob != null) {
      final now = DateTime.now();
      int years = now.year - dob.year;
      int months = now.month - dob.month;
      int days = now.day - dob.day;

      if (days < 0) {
        months -= 1;
        final prevMonthDays = DateTime(now.year, now.month, 0).day;
        days += prevMonthDays;
      }
      if (months < 0) {
        years -= 1;
        months += 12;
      }
      final parts = <String>[];
      if (years > 0) parts.add('$years yr');
      if (months > 0) parts.add('$months mo');
      if (parts.isEmpty && days >= 0) parts.add('$days d');
      return parts.join(' ');
    }
  }
  return '';
}

// ====== Your existing glass + tiles + skeleton from original code ======

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

