import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PatientLoginScreen extends StatefulWidget {
  const PatientLoginScreen({super.key});

  @override
  State<PatientLoginScreen> createState() => _PatientLoginScreenState();
}

class _PatientLoginScreenState extends State<PatientLoginScreen> {

  static const Color splashBg1 = Color(0xFFF0F0F0);
  static const Color splashBg2 = Color(0xFFCDDBFF);


  static const Color patientAccent = Color(0xFF00C2FF); // sky blue
  static const Color adminAccent = Color(0xFF7F5AF0);   // violet
  static const Color textColor = Colors.black87;

  final _phoneCtrl = TextEditingController();
  final _phoneFocus = FocusNode();

  bool get _isValidPhone {
    final digits = _phoneCtrl.text.replaceAll(RegExp(r'\D'), '');
    return digits.length == 10;
  }

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _phoneFocus.dispose();
    super.dispose();
  }

  void _submit() {
    HapticFeedback.lightImpact();
    if (!_isValidPhone) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 10-digit phone number')),
      );
      return;
    }

    // Navigator.pushNamed(context, '/PatientOtpScreen');
    Navigator.pushNamed(context, "/PatientDashboardScreen");
  }

  void _goAdmin() {
    HapticFeedback.selectionClick();
    Navigator.pushNamed(context, "/LoginScreen");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // keeps bottom padding adjustment when keyboard is open
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Soft static gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [splashBg1, splashBg2],
              ),
            ),
          ),


          Positioned(
            top: -120,
            left: -80,
            child: _blob(220, patientAccent.withOpacity(0.10)),
          ),
          Positioned(
            bottom: -140,
            right: -100,
            child: _blob(260, adminAccent.withOpacity(0.10)),
          ),

          // Content
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final bottomInset = MediaQuery.of(context).viewInsets.bottom;
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottomInset),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top bar
                          Center(
                            child: const Text(
                              'Patient  Login',
                              style: TextStyle(
                                color: textColor,
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),

                           SizedBox(height:MediaQuery.of(context).size.height*0.1 ),

                          // Headline
                          const Text(
                            'Welcome 👋',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Enter your phone number to continue.',
                            style: TextStyle(
                              color: Colors.black87.withOpacity(0.75),
                              fontSize: 15.5,
                            ),
                          ),


                          SizedBox(height: MediaQuery.of(context).size.height*0.05,),

                          // Glass card with phone field + button
                          _GlassCard(
                            accent: patientAccent,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Phone number',
                                  style: TextStyle(
                                    color: Colors.black87.withOpacity(0.8),
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                _PhoneField(
                                  controller: _phoneCtrl,
                                  focusNode: _phoneFocus,
                                  accent: patientAccent,
                                  onChanged: (_) => setState(() {}),
                                ),
                                const SizedBox(height: 16),
                                _PrimaryButton(
                                  //label: 'Send OTP',
                                  label: 'Sign in',
                                  enabled: _isValidPhone,
                                  accent: patientAccent,
                                  onTap: _submit,
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Icon(Icons.lock_outline,
                                        size: 16, color: Colors.black.withOpacity(0.55)),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        'By continuing, you agree to our Terms & Privacy Policy.',
                                        style: TextStyle(
                                          color: Colors.black.withOpacity(0.55),
                                          fontSize: 12.5,
                                          height: 1.2,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 12),

                          // --- OR divider ---
                          _OrDivider(),

                          const SizedBox(height: 12),

                          // Login as Admin section
                          _AdminAccessCard(
                            accent: adminAccent,
                            onTap: _goAdmin,
                          ),

                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Decorative blob
  Widget _blob(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5),
            blurRadius: size * 0.25,
            spreadRadius: size * 0.02,
          ),
        ],
      ),
    );
  }

  // Circular icon button (top-left back)
  Widget _roundIconButton({required IconData icon, required VoidCallback onTap}) {
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
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.85),
              blurRadius: 4,
              offset: const Offset(-2, -2),
            ),
          ],
        ),
        child:  Icon(icon, color: textColor),
      ),
    );
  }
}

/// A soft glass-like card container
class _GlassCard extends StatelessWidget {
  final Widget child;
  final Color accent;

  const _GlassCard({required this.child, required this.accent});

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(28);

    return Container(
      decoration: BoxDecoration(
        borderRadius: radius,
        // Outer subtle depth
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.6),
            blurRadius: 6,
            offset: const Offset(-2, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
            decoration: BoxDecoration(
              borderRadius: radius,
              color: Colors.white.withOpacity(0.78),
              border: Border.all(
                color: Colors.white.withOpacity(0.6),
                width: 1,
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.88),
                  Colors.white.withOpacity(0.72),
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

/// Phone number input with +91 prefix and validation state
class _PhoneField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Color accent;
  final ValueChanged<String>? onChanged;

  const _PhoneField({
    required this.controller,
    required this.focusNode,
    required this.accent,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(18);

    return Container(
      decoration: BoxDecoration(
        borderRadius: radius,
        color: Colors.white,
        border: Border.all(color: Colors.black12, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.8),
            blurRadius: 6,
            offset: const Offset(-2, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Country code (static +91 — tweak if you need selector)
          Container(
            margin: const EdgeInsets.all(6),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: accent.withOpacity(0.10),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: accent.withOpacity(0.40)),
            ),
            child: Row(
              children: [
                const Text(
                  '+91',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14.5,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(Icons.flag_outlined, size: 16, color: Colors.black.withOpacity(0.6)),
              ],
            ),
          ),

          // Phone input
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              keyboardType: TextInputType.phone,
              autofillHints: const [AutofillHints.telephoneNumber],
              textInputAction: TextInputAction.done,
              maxLength: 10, // 10-digit Indian numbers; adjust if needed
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              onChanged: onChanged,
              decoration: InputDecoration(
                counterText: '',
                hintText: 'Enter 10-digit number',
                hintStyle: TextStyle(color: Colors.black.withOpacity(0.4)),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
                suffixIcon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: controller.text.replaceAll(RegExp(r'\D'), '').length == 10
                      ? Icon(Icons.check_circle_rounded,
                      key: const ValueKey('ok'),
                      color: accent,
                      size: 22)
                      : const SizedBox(width: 22, key: ValueKey('empty')),
                ),
              ),
              style: const TextStyle(
                fontSize: 16.5,
                letterSpacing: 0.2,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
              onSubmitted: (_) => FocusScope.of(context).unfocus(),
            ),
          ),
        ],
      ),
    );
  }
}

/// Primary CTA button
class _PrimaryButton extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback onTap;
  final Color accent;

  const _PrimaryButton({
    required this.label,
    required this.enabled,
    required this.onTap,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(16);

    return Opacity(
      opacity: enabled ? 1 : 0.6,
      child: GestureDetector(
        onTap: enabled
            ? () {
          HapticFeedback.selectionClick();
          onTap();
        }
            : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: radius,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                accent,
                const Color(0xFF7F5AF0),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7F5AF0).withOpacity(0.25),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.sms_rounded, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Divider with "OR"
class _OrDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final color = Colors.black.withOpacity(0.2);
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: color)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'or',
            style: TextStyle(
              color: Colors.black.withOpacity(0.55),
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
            ),
          ),
        ),
        Expanded(child: Container(height: 1, color: color)),
      ],
    );
  }
}

/// "Login as Admin" promo card
class _AdminAccessCard extends StatelessWidget {
  final Color accent;
  final VoidCallback onTap;

  const _AdminAccessCard({
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(18);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: radius,
            border: Border.all(color: accent.withOpacity(0.45), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: accent.withOpacity(0.12),
                    border: Border.all(color: accent.withOpacity(0.45)),
                  ),
                  child: Icon(Icons.admin_panel_settings_outlined,
                      color: accent, size: 22),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Login as Admin',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward_rounded, color: accent),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


