// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:jnm_hospital_app/features/approval_system_module/model/approval_system_model.dart';

// class ApprovedListScreen extends StatefulWidget {
//   const ApprovedListScreen({Key? key}) : super(key: key);

//   @override
//   State<ApprovedListScreen> createState() => _ApprovedListScreenState();
// }

// class _ApprovedListScreenState extends State<ApprovedListScreen>
//     with TickerProviderStateMixin {
//   late TabController _tabController;
//   final List<List<ApprovalSystemModel>> _tabData = List.generate(5, (_) => []);
//   final List<String> _tabNames = [
//     "OPD",
//     "IPD/Daycare",
//     "EMR",
//     "DIALYSIS",
//     "INVESTIGATION"
//   ];
//   final List<IconData> _tabIcons = [
//     CupertinoIcons.clock,
//     CupertinoIcons.checkmark_circle,
//     CupertinoIcons.xmark_circle,
//     CupertinoIcons.eye,
//     CupertinoIcons.check_mark_circled_solid,
//   ];
//   static const Color bg1 = Color(0xFFF0F0F0);
//   static const Color bg2 = Color(0xFFCDDBFF);

//   // Accents
//   static const Color opdAccent = Color(0xFF00C2FF); // sky blue
//   static const Color opticalAccent = Color(0xFF7F5AF0); // violet

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 5, vsync: this);

//     // Fetch data for first tab initially
//     _fetchTabData(0);

//     // Listen for tab changes
//     _tabController.addListener(() {
//       if (_tabController.indexIsChanging) return;
//       _onTabChanged(_tabController.index);
//     });
//   }

//   // Function called when tab changes
//   void _onTabChanged(int tabIndex) {
//     print("Tab changed to index: $tabIndex (${_tabNames[tabIndex]})");

//     // Add your custom logic here when tab changes
//     _fetchTabData(tabIndex);

//     // You can call any function here when tab changes
//     _handleTabChangeLogic(tabIndex);
//   }

//   // Custom function you can modify for tab change logic
//   void _handleTabChangeLogic(int tabIndex) {
//     // Add your custom business logic here
//     switch (tabIndex) {
//       case 0:
//         // Handle pending tab logic
//         break;
//       case 1:
//         // Handle approved tab logic
//         break;
//       case 2:
//         // Handle rejected tab logic
//         break;
//       case 3:
//         // Handle review tab logic
//         break;
//       case 4:
//         // Handle completed tab logic
//         break;
//     }
//   }

//   // Dummy fetch function for a tab
//   Future<void> _fetchTabData(int tabIndex) async {

//   }

//   void _onApprove(int approvalId) {
//     // Handle approval logic
//     print("Approved item with ID: $approvalId");
//   }

//   Widget _blob(double size, Color color) {
//     return Container(
//       width: size,
//       height: size,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: color,
//         boxShadow: [
//           BoxShadow(
//               color: color.withOpacity(0.45),
//               blurRadius: size * 0.25,
//               spreadRadius: size * 0.02)
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Theme(
//       data: Theme.of(context).copyWith(
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: const Color(0xFF6366F1), // Indigo
//           brightness: Brightness.light,
//         ).copyWith(
//           primary: const Color(0xFF6366F1),
//           secondary: const Color(0xFF8B5CF6),
//           surface: Colors.white,
//           onSurface: const Color(0xFF1F2937),
//         ),
//       ),
//       child: Scaffold(
//         backgroundColor: const Color(0xFFF8FAFC),
//         body: Stack(
//           children: [
//             Container(
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [bg1, bg2],
//                 ),
//               ),
//             ),
//             // Decorative blobs
//             Positioned(
//                 top: -120,
//                 left: -80,
//                 child: _blob(220, opdAccent.withOpacity(0.10))),
//             Positioned(
//                 bottom: -140,
//                 right: -100,
//                 child: _blob(260, opticalAccent.withOpacity(0.10))),
//             SafeArea(
//               child: RefreshIndicator(
//                 onRefresh: () async {
//                   await Future.delayed(const Duration(seconds: 1));
//                 },
//                 child: CustomScrollView(
//                   slivers: [
//                     SliverToBoxAdapter(
//                       child: TabBarView(
//                         controller: _tabController,
//                         children: List.generate(5, (tabIndex) {
//                           final items = _tabData[tabIndex];
//                           if (items.isEmpty) {
//                             return Container(
//                               decoration: const BoxDecoration(
//                                 gradient: LinearGradient(
//                                   begin: Alignment.topCenter,
//                                   end: Alignment.bottomCenter,
//                                   colors: [
//                                     Color(0xFFF8FAFC),
//                                     Color(0xFFEEF2FF),
//                                   ],
//                                 ),
//                               ),
//                               child: Center(
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Container(
//                                       padding: const EdgeInsets.all(20),
//                                       decoration: BoxDecoration(
//                                         color: Colors.white,
//                                         borderRadius: BorderRadius.circular(20),
//                                         boxShadow: [
//                                           BoxShadow(
//                                             color: const Color(0xFF6366F1)
//                                                 .withOpacity(0.1),
//                                             blurRadius: 20,
//                                             offset: const Offset(0, 4),
//                                           ),
//                                         ],
//                                       ),
//                                       child: const CupertinoActivityIndicator(
//                                         radius: 16,
//                                         color: Color(0xFF6366F1),
//                                       ),
//                                     ),
//                                     const SizedBox(height: 24),
//                                     Text(
//                                       "Loading ${_tabNames[tabIndex]}...",
//                                       style: const TextStyle(
//                                         color: Color(0xFF6B7280),
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           }

//                           return Container(
//                             decoration: const BoxDecoration(
//                               gradient: LinearGradient(
//                                 begin: Alignment.topCenter,
//                                 end: Alignment.bottomCenter,
//                                 colors: [
//                                   Color(0xFFF8FAFC),
//                                   Color(0xFFEEF2FF),
//                                 ],
//                               ),
//                             ),
//                             child: CustomScrollView(
//                               physics: const BouncingScrollPhysics(),
//                               slivers: [
//                                 SliverPadding(
//                                   padding: const EdgeInsets.all(16),
//                                   sliver: SliverList(
//                                     delegate: SliverChildBuilderDelegate(
//                                       (context, index) => Container(
//                                         margin:
//                                             const EdgeInsets.only(bottom: 16),
//                                         child: ApprovalCard(
//                                           approvalData: items[index],
//                                           onApprove: _onApprove,
//                                         ),
//                                       ),
//                                       childCount: items.length,
//                                     ),
//                                   ),
//                                 ),
//                                 // Add some bottom padding
//                                 const SliverPadding(
//                                   padding: EdgeInsets.only(bottom: 24),
//                                 ),
//                               ],
//                             ),
//                           );
//                         }),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
// }

// // Enhanced ApprovalCard with beautiful iOS theme
// class ApprovalCard extends StatefulWidget {
//   final ApprovalSystemModel approvalData;
//   final Function(int) onApprove;

//   const ApprovalCard({
//     super.key,
//     required this.approvalData,
//     required this.onApprove,
//   });

//   @override
//   State<ApprovalCard> createState() => _ApprovalCardState();
// }

// class _ApprovalCardState extends State<ApprovalCard>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _scaleAnimation;
//   bool _isPressed = false;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 150),
//       vsync: this,
//     );
//     _scaleAnimation = Tween<double>(
//       begin: 1.0,
//       end: 0.98,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeInOut,
//     ));
//   }

//   Color _getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'OPD':
//         return const Color(0xFFF59E0B);
//       case 'IPD':
//         return const Color(0xFF10B981);
//       case 'DIALYSIS':
//         return const Color(0xFFEF4444);
//       case 'EMR':
//         return const Color(0xFF8B5CF6);
//       case 'INVESTIGATION':
//         return const Color(0xFF06B6D4);
//       default:
//         return const Color(0xFF6B7280);
//     }
//   }

//   IconData _getStatusIcon(String status) {
//     switch (status.toLowerCase()) {
//       case 'OPD':
//         return CupertinoIcons.clock;
//       case 'IPD':
//         return CupertinoIcons.checkmark_circle_fill;
//       case 'DIALYSIS':
//         return CupertinoIcons.xmark_circle_fill;
//       case 'EMR':
//         return CupertinoIcons.eye_fill;
//       case 'INVESTIGATION':
//         return CupertinoIcons.check_mark_circled_solid;
//       default:
//         return CupertinoIcons.circle;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTapDown: (_) {
//         setState(() => _isPressed = true);
//         _animationController.forward();
//       },
//       onTapUp: (_) {
//         setState(() => _isPressed = false);
//         _animationController.reverse();
//       },
//       onTapCancel: () {
//         setState(() => _isPressed = false);
//         _animationController.reverse();
//       },
//       onTap: () {
//         // Handle card tap if needed
//       },
//       child: AnimatedBuilder(
//         animation: _scaleAnimation,
//         builder: (context, child) {
//           return Transform.scale(
//             scale: _scaleAnimation.value,
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: _isPressed
//                         ? const Color(0xFF6366F1).withOpacity(0.2)
//                         : const Color(0xFF000000).withOpacity(0.08),
//                     blurRadius: _isPressed ? 25 : 15,
//                     offset: Offset(0, _isPressed ? 8 : 4),
//                   ),
//                 ],
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Header with gradient
//                     Container(
//                       padding: const EdgeInsets.all(20),
//                       decoration: const BoxDecoration(
//                         gradient: LinearGradient(
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                           colors: [
//                             Color(0xFF6366F1),
//                             Color(0xFF8B5CF6),
//                           ],
//                         ),
//                       ),
//                       child: Row(
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.all(12),
//                             decoration: BoxDecoration(
//                               color: Colors.white.withOpacity(0.2),
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: Icon(
//                               CupertinoIcons.doc_text,
//                               color: Colors.white,
//                               size: 24,
//                             ),
//                           ),
//                           const SizedBox(width: 16),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   "Bill #${widget.approvalData.uid}",
//                                   style: const TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   widget.approvalData.patientName!,
//                                   style: TextStyle(
//                                     color: Colors.white.withOpacity(0.9),
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 12,
//                               vertical: 6,
//                             ),
//                             decoration: BoxDecoration(
//                               color:
//                                   _getStatusColor(widget.approvalData.status!)
//                                       .withOpacity(0.2),
//                               borderRadius: BorderRadius.circular(20),
//                               border: Border.all(
//                                 color: Colors.white.withOpacity(0.3),
//                               ),
//                             ),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Icon(
//                                   _getStatusIcon(widget.approvalData.status!),
//                                   color: Colors.white,
//                                   size: 14,
//                                 ),
//                                 const SizedBox(width: 6),
//                                 Text(
//                                   widget.approvalData.status!.toUpperCase(),
//                                   style: const TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     // Content
//                     Padding(
//                       padding: const EdgeInsets.all(20),
//                       child: Column(
//                         children: [
//                           // Amount and Date Row
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     "Total Amount",
//                                     style: TextStyle(
//                                       color: const Color(0xFF6B7280),
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Text(
//                                     "₹${widget.approvalData.grandTotal!.toStringAsFixed(2)}",
//                                     style: const TextStyle(
//                                       color: Color(0xFF1F2937),
//                                       fontSize: 24,
//                                       fontWeight: FontWeight.w700,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: [
//                                   Text(
//                                     "Bill Date",
//                                     style: TextStyle(
//                                       color: const Color(0xFF6B7280),
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Text(
//                                     "${widget.approvalData.billDate!.day}/${widget.approvalData.billDate!.month}/${widget.approvalData.billDate!.year}",
//                                     style: const TextStyle(
//                                       color: Color(0xFF1F2937),
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 20),
//                           // Info Rows
//                           _buildInfoRow(
//                             "Section",
//                             widget.approvalData.section!,
//                             CupertinoIcons.building_2_fill,
//                           ),
//                           const SizedBox(height: 12),
//                           _buildInfoRow(
//                             "Doctor",
//                             "Dr. ${widget.approvalData.createdByName}",
//                             CupertinoIcons.person_fill,
//                           ),
//                           const SizedBox(height: 12),
//                           _buildInfoRow(
//                             "Patient ID",
//                             widget.approvalData.patientId.toString(),
//                             CupertinoIcons.person_crop_circle,
//                           ),
//                           if (widget.approvalData.dueAmount! > 0) ...[
//                             const SizedBox(height: 12),
//                             _buildInfoRow(
//                               "Due Amount",
//                               "₹${widget.approvalData.dueAmount!.toStringAsFixed(2)}",
//                               CupertinoIcons.exclamationmark_triangle_fill,
//                               valueColor: const Color(0xFFEF4444),
//                             ),
//                           ],
//                           const SizedBox(height: 24),
//                           // Action Button
//                           if (widget.approvalData.status!.toLowerCase() ==
//                               'pending')
//                             SizedBox(
//                               width: double.infinity,
//                               child: CupertinoButton(
//                                 onPressed: () =>
//                                     widget.onApprove(widget.approvalData.id),
//                                 color: const Color(0xFF10B981),
//                                 borderRadius: BorderRadius.circular(15),
//                                 child: const Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Icon(CupertinoIcons.checkmark_circle,
//                                         size: 18),
//                                     SizedBox(width: 8),
//                                     Text(
//                                       "Approve",
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.w600,
//                                         fontSize: 16,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildInfoRow(
//     String label,
//     String value,
//     IconData icon, {
//     Color? valueColor,
//   }) {
//     return Row(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: const Color(0xFF6366F1).withOpacity(0.1),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Icon(
//             icon,
//             size: 16,
//             color: const Color(0xFF6366F1),
//           ),
//         ),
//         const SizedBox(width: 12),
//         Text(
//           label,
//           style: const TextStyle(
//             color: Color(0xFF6B7280),
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         const Spacer(),
//         Text(
//           value,
//           style: TextStyle(
//             color: valueColor ?? const Color(0xFF1F2937),
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jnm_hospital_app/features/approval_system_module/common/widgets/common_card.dart';
import 'package:jnm_hospital_app/features/approval_system_module/model/approval_system_model.dart';

class ApprovedListScreen extends StatefulWidget {
  const ApprovedListScreen({Key? key}) : super(key: key);

  @override
  State<ApprovedListScreen> createState() => _ApprovedListScreenState();
}

class _ApprovedListScreenState extends State<ApprovedListScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final List<List<ApprovalSystemModel>> _tabData = List.generate(5, (_) => []);
  final List<String> _tabNames = [
    "OPD",
    "IPD/Daycare",
    "EMR",
    "DIALYSIS",
    "INVESTIGATION"
  ];

  static const Color bg1 = Color(0xFFF0F0F0);
  static const Color bg2 = Color(0xFFCDDBFF);
  static const Color textPrimary = Colors.black87;
  static const Color textSecondary = Colors.black54;

  // Accents
  static const Color opdAccent = Color(0xFF00C2FF); // sky blue
  static const Color opticalAccent = Color(0xFF7F5AF0); // violet
  static const double _hPad = 20;

  final List<IconData> _tabIcons = [
    CupertinoIcons.clock,
    CupertinoIcons.checkmark_circle,
    CupertinoIcons.xmark_circle,
    CupertinoIcons.eye,
    CupertinoIcons.check_mark_circled_solid,
  ];

  // Accents

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _fetchTabData(0); // fetch first tab initially

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      _fetchTabData(_tabController.index);
    });
  }

  // Dummy fetch function
  Future<void> _fetchTabData(int tabIndex) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // setState(() {
    //   _tabData[tabIndex] = List.generate(
    //     10,
    //     (i) => ApprovalSystemModel(
    //       id: i,
    //       uid: "UID-$i",
    //       section: _tabNames[tabIndex],
    //       status: _tabNames[tabIndex],
    //       patientName: "Patient $i",
    //       grandTotal: 1500.0 + i,
    //       dueAmount: (i % 3 == 0) ? 200.0 : 0.0,
    //       patientId: 1000 + i,
    //       billDate: DateTime.now(),
    //       createdByName: "Doctor $i",
    //     ),
    //   );
    // });
  }

  void _onApprove(int approvalId) {
    print("Approved item with ID: $approvalId");
  }

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
            spreadRadius: size * 0.02,
          )
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
            border: Border.all(color: Colors.cyan, width: 2)),
        child: Icon(icon, color: textPrimary),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.light,
        ),
      ),
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [bg1, bg2],
                ),
              ),
            ),
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
                onRefresh: () async {
                  await _fetchTabData(_tabController.index);
                },
                child: NestedScrollView(
                  headerSliverBuilder: (context, innerScrolled) => [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
                        child: Row(
                          children: [
                            _roundIconButton(
                              icon: Icons.arrow_back_ios_new_rounded,
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            SizedBox(width: 20,),
                            const Expanded(
                              child: Text(
                                'Approval List',
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
                    ),

                    // Your sliver app bar with tabs
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      pinned: true,
                      floating: true,
                      snap: true,
                      toolbarHeight: 0,
                      bottom: TabBar(
                        controller: _tabController,
                        isScrollable: true,
                        tabs: _tabNames
                            .map((t) => Tab(text: t.toUpperCase()))
                            .toList(),
                      ),
                    )
                  ],
                  body: TabBarView(
                    controller: _tabController,
                    children: List.generate(5, (tabIndex) {
                      final items = _tabData[tabIndex];
                      if (items.isEmpty) {
                        return const Center(
                          child: CupertinoActivityIndicator(radius: 16),
                        );
                      }
                      return CustomScrollView(
                        physics: const BouncingScrollPhysics(),
                        slivers: [
                          SliverPadding(
                            padding: const EdgeInsets.all(16),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) => Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  child: ApprovalCard(
                                    approvalData: items[index],
                                    onApprove: _onApprove,
                                  ),
                                ),
                                childCount: items.length,
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
