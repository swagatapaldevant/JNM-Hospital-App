import 'dart:ui'; // 👈 needed for ImageFilter
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

  Widget _roundIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
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
          color: Colors.white.withOpacity(0.6),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.cyan, width: 2),
        ),
        child: Icon(icon, color: Colors.black87),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _CommonHeaderDelegate(
        title: title,
        actions: actions,
        roundIconButton: _roundIconButton,
      ),
    );
  }
}

class _CommonHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String title;
  final List<Widget> actions;
  final Widget Function({required IconData icon, required VoidCallback onTap})
      roundIconButton;

  _CommonHeaderDelegate({
    required this.title,
    required this.actions,
    required this.roundIconButton,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final progress = (shrinkOffset / maxExtent).clamp(0.0, 1.0);

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), //  blur effect
        child: Container(
          color: Color.lerp(
            Colors.transparent,
            Colors.white.withOpacity(0.6), 
            progress,
          ),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: Row(
            children: [
              roundIconButton(
                icon: Icons.arrow_back_ios_new_rounded,
                onTap: () => Navigator.pop(context),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              ...actions,
            ],
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 70;
  @override
  double get minExtent => 70;
  @override
  bool shouldRebuild(covariant _CommonHeaderDelegate oldDelegate) => false;
}
