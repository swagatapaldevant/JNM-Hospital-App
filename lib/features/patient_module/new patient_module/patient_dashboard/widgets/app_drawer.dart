import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/locator.dart';
import 'package:jnm_hospital_app/core/services/localStorage/shared_pref.dart';
import 'package:jnm_hospital_app/core/services/routeGenerator/route_generator.dart';
import 'package:jnm_hospital_app/core/utils/commonWidgets/custom_button.dart';
import 'package:jnm_hospital_app/core/utils/helper/screen_utils.dart';


//convert AppDrawer to Stateful widget
class AppDrawer extends StatefulWidget {
  AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String patientName = "NA";
  String patientId = "NA";
  String patientInitials = "NA";

  static const Color _opdAccent = Color(0xFF00C2FF);
  static const Color _opticalAccent = Color(0xFF7F5AF0);
  SharedPref _pref = getIt<SharedPref>();

  @override
  void initState() {
    super.initState();
    _loadPatientData();
  }

  void _loadPatientData() async {
    final SharedPref _pref = getIt<SharedPref>();
    patientName = await _pref.getName();
    patientId = (await _pref.getUserId()).toString();
    patientInitials = _getInitials(patientName);
    setState(() {});
  }

  String _getInitials(String patientName) {
    List<String> names = patientName.trim().split(" ");
    String initials = names.first[0] + names.last[0];
    //print(initials);
    return initials;
  }

  commonDialog({
  required String title,
  required String msg,
  required String activeButtonLabel,
  Color? activeButtonLabelColor,
  Color? activeButtonSolidColor,
  IconData? icon,
  bool isCancelButtonShow = true,
  Function()? activeButtonOnClicked,
  required BuildContext context,
}) {
  showDialog(
    barrierDismissible: false, // iOS feel: must click button
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue.shade400,
                Colors.deepPurple.shade400,
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(ScreenUtils().screenWidth(context) * 0.08),
            child: Column(
              mainAxisSize: MainAxisSize.min, // shrink to content like iOS
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: ScreenUtils().screenHeight(context) * 0.1,
                  width: ScreenUtils().screenWidth(context) * 0.2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.9),
                        Colors.white.withOpacity(0.6),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Icon(
                    icon ?? Icons.info_outline,
                    color: Colors.deepPurple.shade600,
                    size: 36,
                  ),
                ),
                SizedBox(height: ScreenUtils().screenHeight(context) * 0.02),
                Text(
                  title,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontFamily: "SF Pro Display",
                        color: Colors.white,
                        fontSize: ScreenUtils().screenWidth(context) * 0.05,
                        fontWeight: FontWeight.w600,
                      ),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: ScreenUtils().screenHeight(context) * 0.02),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    msg,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontFamily: "SF Pro Text",
                          color: Colors.white70,
                          fontSize: ScreenUtils().screenWidth(context) * 0.038,
                          fontWeight: FontWeight.w400,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: ScreenUtils().screenHeight(context) * 0.04),
                Row(
                  children: [
                    if (isCancelButtonShow)
                      Expanded(
                        child: CustomButton(
                          borderRadius: 12,
                          labelTextSize:
                              ScreenUtils().screenWidth(context) * 0.034,
                          verticalPadding:
                              ScreenUtils().screenWidth(context) * 0.022,
                          horizontalPadding:
                              ScreenUtils().screenWidth(context) * 0.06,
                          labelTextColor: Colors.deepPurple.shade600,
                          color: Colors.white,
                          borderColor: Colors.transparent,
                          onPressed: () => Navigator.pop(context),
                          text: "Cancel",
                        ),
                      ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomButton(
                        borderRadius: 12,
                        labelTextSize:
                            ScreenUtils().screenWidth(context) * 0.034,
                        verticalPadding:
                            ScreenUtils().screenWidth(context) * 0.022,
                        horizontalPadding:
                            ScreenUtils().screenWidth(context) * 0.06,
                        labelTextColor: Colors.white,
                        color: Colors.deepPurple.shade600,
                        borderColor: Colors.transparent,
                        onPressed: activeButtonOnClicked,
                        text: activeButtonLabel,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 12,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [_opdAccent, _opticalAccent],
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.2),
                      border: Border.all(color: Colors.white.withOpacity(0.7)),
                    ),
                    child: Center(
                      child: Text(
                        patientInitials,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(patientName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 16.5,
                            )),
                        SizedBox(height: 2),
                        Text('Patient ID: JMN-$patientId',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _DrawerItem(
                    icon: Icons.dashboard_outlined,
                    label: 'Home',
                    onTap: () => Navigator.pop(context),
                  ),
                  _DrawerItem(
                    icon: Icons.event_available_outlined,
                    label: 'My Appointments',
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Navigator.pushNamed(context, '/Appointments');
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.visibility_outlined,
                    label: 'Optical Orders',
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Navigator.pushNamed(context, '/OpticalOrders');
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.receipt_long_outlined,
                    label: 'Prescriptions',
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Navigator.pushNamed(context, '/Prescriptions');
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.payments_outlined,
                    label: 'Payments',
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Navigator.pushNamed(context, '/Payments');
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.description_outlined,
                    label: 'Reports',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Divider(height: 12),
                  _DrawerItem(
                    icon: Icons.settings_outlined,
                    label: 'Settings',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.help_outline_rounded,
                    label: 'Help & Support',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.logout_rounded,
                    label: 'Logout',
                    danger: true,
                    onTap: () {
                      commonDialog(
                          title: "Logout",
                          msg: "Are you sure you want to logout?",
                          activeButtonLabel: "Logout",
                          context: context,
                          activeButtonOnClicked: () {
                            _pref.clearOnLogout();
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              RouteGenerator.kPatientLoginScreen,
                              (Route<dynamic> route) => false,
                            );
                          });
                    },
                  ),
                ],
              ),
            ),

            // Footer
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'JMN Hospital • v1.0.0',
                style: TextStyle(
                  color: Colors.black.withOpacity(0.5),
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool danger;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = danger ? Colors.redAccent : Colors.black87;
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 15,
          letterSpacing: 0.2,
        ),
      ),
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      dense: true,
      horizontalTitleGap: 8,
      minLeadingWidth: 20,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }
}
