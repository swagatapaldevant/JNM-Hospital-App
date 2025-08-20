import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String? _selected;

  // Static background colors
  static const Color splashBg1 = Color(0xFFF0F0F0);
  static const Color splashBg2 = Color(0xFFCDDBFF);

  void _onRoleTap(String role) {
    setState(() => _selected = role); // show selected border immediately
    Future.delayed(const Duration(milliseconds: 160), () {
      if (!mounted) return;
      if (role == 'patient') {
        Navigator.pushNamed(context, '/PatientLoginScreen');
      } else if (role == 'admin') {
        Navigator.pushNamed(context, "/LoginScreen");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const textColor = Colors.black87;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Static gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [splashBg1, splashBg2],
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _LogoMark(),
                  const SizedBox(height: 28),
                  const Text(
                    "Choose your role",
                    style: TextStyle(
                      color: textColor,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "We'll tailor the experience based on your selection.",
                    style: TextStyle(
                      color: textColor.withOpacity(0.8),
                      fontSize: 15,
                    ),
                  ),
                  const Spacer(),
                  RoleCard(
                    title: 'Patient',
                    subtitle: 'Appointments · Records · Care',
                    icon: Icons.favorite_outline,
                    gradient: const [Color(0xFFFFFFFF), Color(0xFFE6F7FF)],
                    glowColor: const Color(0xFF00C2FF),
                    selected: _selected == 'patient',
                    onTap: () => _onRoleTap('patient'),
                  ),
                  const SizedBox(height: 16),
                  RoleCard(
                    title: 'Admin',
                    subtitle: 'Dashboard · Staff · Analytics',
                    icon: Icons.admin_panel_settings_outlined,
                    gradient: const [Color(0xFFFFFFFF), Color(0xFFF5ECFF)],
                    glowColor: const Color(0xFF7F5AF0),
                    selected: _selected == 'admin',
                    onTap: () => _onRoleTap('admin'),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RoleCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient; // kept for flexibility if you want to re-enable
  final Color glowColor;
  final bool selected;
  final VoidCallback onTap;

  const RoleCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.glowColor,
    required this.onTap,
    this.selected = false,
  });

  @override
  State<RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<RoleCard> {
  bool _hover = false;   // desktop/web hover
  bool _pressed = false; // tactile press state

  @override
  Widget build(BuildContext context) {
    const baseText = Colors.black87;
    final radius = BorderRadius.circular(28);

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOutCubic,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: radius,
            splashColor: widget.glowColor.withOpacity(0.15),
            highlightColor: widget.glowColor.withOpacity(0.08),
            onHighlightChanged: (v) => setState(() => _pressed = v),
            onTap: () {
              HapticFeedback.selectionClick();
              widget.onTap();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              height: 180,
              decoration: BoxDecoration(
                borderRadius: radius,
                color: AppColors.white, // clean card surface
                // classic border; highlights when selected
                border: Border.all(
                  color: widget.selected ? widget.glowColor : Colors.grey.shade300,
                  width: widget.selected ? 3 : 2,
                ),
                // tuned shadows for classic, premium depth
                boxShadow: [
                  // main drop shadow
                  BoxShadow(
                    color: Colors.black.withOpacity(_pressed ? 0.10 : 0.12),
                    blurRadius: _pressed ? 14 : 24, // softer when pressed
                    spreadRadius: 0,
                    offset: Offset(0, _pressed ? 8 : 12),
                  ),
                  // subtle top-left highlight (hint of bevel)
                  BoxShadow(
                    color: Colors.white.withOpacity(_pressed ? 0.35 : 0.50),
                    blurRadius: _pressed ? 3 : 6,
                    spreadRadius: 0,
                    offset: const Offset(-2, -2),
                  ),
                  // restrained color glow for hover/selected
                  if (_hover || widget.selected)
                    BoxShadow(
                      color: widget.glowColor.withOpacity(0.22),
                      blurRadius: _pressed ? 14 : 18,
                      spreadRadius: 0,
                    ),
                ],
              ),
              child: ClipRRect(
                borderRadius: radius,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // toned-down glossy sheen
                    Positioned.fill(
                      child: IgnorePointer(
                        child: Container(
                          decoration: BoxDecoration(
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
                    // inner hairline for crisp edge
                    Positioned.fill(
                      child: IgnorePointer(
                        child: Container(
                          margin: const EdgeInsets.all(1.0),
                          decoration: BoxDecoration(
                            borderRadius: radius.subtract(
                              const BorderRadius.all(Radius.circular(1)),
                            ),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.30),
                              width: 0.8,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // content
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Row(
                        children: [
                          // icon bubble
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 58,
                            height: 58,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: widget.glowColor.withOpacity(0.15),
                              border: Border.all(
                                color: widget.glowColor.withOpacity(0.5),
                                width: 2,
                              ),
                              boxShadow: [
                                if (!_pressed)
                                  BoxShadow(
                                    color: widget.glowColor.withOpacity(0.20),
                                    blurRadius: 10,
                                    spreadRadius: 0,
                                    offset: const Offset(0, 2),
                                  ),
                              ],
                            ),
                            child: Icon(widget.icon, size: 28, color: baseText),
                          ),
                          const SizedBox(width: 14),
                          // texts
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  widget.title,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: baseText,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.subtitle,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    height: 1.25,
                                    color: Colors.black.withOpacity(0.65),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          // arrow pill
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: (_hover || widget.selected)
                                  ? widget.glowColor.withOpacity(0.18)
                                  : Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                width: 2,
                                color: (_hover || widget.selected)
                                    ? widget.glowColor
                                    : Colors.black12,
                              ),
                              boxShadow: [
                                if (!_pressed)
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 6,
                                    spreadRadius: 0,
                                    offset: const Offset(0, 2),
                                  ),
                              ],
                            ),
                            child: const Icon(
                              Icons.arrow_forward_rounded,
                              size: 22,
                              color: baseText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoMark extends StatelessWidget {
  const _LogoMark();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Brand orb
        Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFF00C2FF), Color(0xFF7F5AF0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Image.asset("assets/images/splash/jmn_logo.jpg"),
        ),
        const SizedBox(width: 15),
        const Text(
          'JMN  HOSPITAL',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 22,
            letterSpacing: 0.25,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
