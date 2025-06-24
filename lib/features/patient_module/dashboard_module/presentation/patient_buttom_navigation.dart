import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/app_dimensions.dart';
import 'package:jnm_hospital_app/features/patient_module/dashboard_module/presentation/home_screen.dart';
import 'package:jnm_hospital_app/features/patient_module/notification_module/presentation/notification_screen.dart';
import 'package:jnm_hospital_app/features/patient_module/profile_module/presentation/profile_screen.dart';
import 'package:jnm_hospital_app/features/patient_module/report_module/presentation/report_module_screen.dart';

class PatientButtonNavigation extends StatefulWidget {
  const PatientButtonNavigation({super.key});

  @override
  State<PatientButtonNavigation> createState() => _PatientButtonNavigationState();
}

class _PatientButtonNavigationState extends State<PatientButtonNavigation> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late final List<Widget> _screens;
  late final List<AnimationController> _fadeControllers;
  late final List<Animation<double>> _fadeAnimations;
  DateTime? currentBackPressTime;

  @override
  void initState() {
    super.initState();

    _screens = const [
      HomeScreen(),
      ReportModuleScreen(),
      NotificationScreen(),
      ProfileScreen(),
    ];

    // Initialize fade animations for each screen
    _fadeControllers = List.generate(
      _screens.length,
          (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      )..forward(),
    );

    _fadeAnimations = _fadeControllers
        .map(
          (controller) => Tween<double>(begin: 0, end: 1).animate(controller),
    )
        .toList();
  }

  void _onTabTapped(int index) {
    if (_currentIndex == index) return;

    // Fade out old screen
    _fadeControllers[_currentIndex].reverse();

    setState(() => _currentIndex = index);

    // Fade in new screen
    _fadeControllers[_currentIndex].forward();
  }

  @override
  void dispose() {
    for (var controller in _fadeControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppDimensions.init(context);
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        DateTime now = DateTime.now();
        if (didPop ||
            currentBackPressTime == null ||
            now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
          currentBackPressTime = now;
          Fluttertoast.showToast(msg: 'Tap back again to Exit');
          // return false;
        } else {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: List.generate(_screens.length, (index) {
            return FadeTransition(
              opacity: _fadeAnimations[index],
              child: _screens[index],
            );
          }),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.white, width: 2.0)),
            color: AppColors.gray3.withOpacity(0.9),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onTabTapped,
            backgroundColor: Colors.transparent,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            selectedItemColor: AppColors.arrowBackground,
            unselectedItemColor: AppColors.gray8,
            selectedFontSize: 14,
            unselectedFontSize: 12,
            selectedLabelStyle: TextStyle(
              fontFamily: "Roboto",
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: TextStyle(
              fontFamily: "Roboto",
              fontWeight: FontWeight.w500,
            ),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home, size: 30),
                label: 'home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.report_gmailerrorred, size: 30),
                label: 'report',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications, size: 30),
                label: 'notifications',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person, size: 30),
                label: 'profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

