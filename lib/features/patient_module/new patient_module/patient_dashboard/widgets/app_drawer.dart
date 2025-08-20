import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  static const Color _opdAccent = Color(0xFF00C2FF);
  static const Color _opticalAccent = Color(0xFF7F5AF0);

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
                    child: const Center(
                      child: Text(
                        'JD', // TODO: user initials
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('John Doe',  // TODO: user name
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 16.5,
                            )),
                        SizedBox(height: 2),
                        Text('Patient ID: JMN-2048', // TODO: real ID
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
                      Navigator.pop(context);
                      // TODO: logout flow
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
