import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CommonHeader extends StatelessWidget {
  final String title;
  final List<Widget> actions;

  const CommonHeader({
    super.key,
    required this.title,
    this.actions = const [],
  });

  Widget _roundIconButton(
      {required IconData icon, required VoidCallback onTap}) {
    return InkResponse(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      radius: 28,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.cyan, width: 2)),
        child: Icon(icon, color: Colors.black87),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        child: Row(
          children: [
            _roundIconButton(
                icon: Icons.arrow_back_ios_new_rounded,
                onTap: () => Navigator.pop(context)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
