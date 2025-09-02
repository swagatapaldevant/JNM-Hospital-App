import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/api_endpoint.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/resource.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/status.dart';
import 'package:jnm_hospital_app/features/approval_system_module/approved_list_screen/data/approved_list_usecases_impl.dart';
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

  // Data + loading per tab
  final List<List<ApprovalSystemModel>> _tabData = List.generate(5, (_) => []);
  final List<bool> _isLoading = List.generate(5, (_) => false);

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);

    // Fetch first tab initially
    _fetchTabData(0);

    // Fetch when tab changes (with simple caching)
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      final i = _tabController.index;
      if (_tabData[i].isEmpty && !_isLoading[i]) {
        _fetchTabData(i);
      }
    });
  }

  Future<void> _fetchTabData(int tabIndex) async {
    final List<String> tabURL = [
      'opd',
      'ipd',
      'emr',
      'dialysis',
      'investigation'
    ];

    setState(() => _isLoading[tabIndex] = true);

    final Resource resource = await ApprovedListUsecasesImpl()
        .fetchApprovedList('${ApiEndPoint.approvalList}/${tabURL[tabIndex]}');

    if (!mounted) return;

    if (resource.status == STATUS.SUCCESS) {
      final List<dynamic> rawList = resource.data ?? [];
      final approvals =
          rawList.map((e) => ApprovalSystemModel.fromJson(e)).toList();

      setState(() {
        _tabData[tabIndex] = approvals;
        _isLoading[tabIndex] = false;
      });
    } else {
      debugPrint("Error fetching approved list: ${resource.message}");
      setState(() => _isLoading[tabIndex] = false);
    }
  }

  void _onApprove(int approvalId) {
    debugPrint("Approved item with ID: $approvalId");
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
          border: Border.all(color: Colors.cyan, width: 2),
        ),
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
            // Background
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

            // Content
            SafeArea(
              child: RefreshIndicator(
                onRefresh: () async => _fetchTabData(_tabController.index),
                child: NestedScrollView(
                  headerSliverBuilder: (context, innerScrolled) => [
                    // Header row
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
                        child: Row(
                          children: [
                            _roundIconButton(
                              icon: Icons.arrow_back_ios_new_rounded,
                              onTap: () => Navigator.of(context).pop(),
                            ),
                            const SizedBox(width: 20),
                            const Expanded(
                              child: Text(
                                'Approved List',
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

                    // Fancy TabBar
                    SliverAppBar(
                      backgroundColor: Colors.transparent,
                      automaticallyImplyLeading: false,
                      pinned: true,
                      floating: true,
                      snap: true,
                      toolbarHeight: 0,
                      bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(64),
                        child: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.6)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 18,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: TabBar(
                            controller: _tabController,
                            isScrollable: true,
                            dividerColor: Colors.transparent,
                            labelPadding:
                                const EdgeInsets.symmetric(horizontal: 12),
                            indicatorPadding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 4),
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicator: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFF8EA6FF), // soft indigo
                                  Color(0xFF6FD6FF), // sky
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF6FD6FF).withOpacity(0.35),
                                  blurRadius: 14,
                                  offset: Offset(0, 6),
                                ),
                              ],
                            ),
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.black87,
                            overlayColor:
                                MaterialStateProperty.resolveWith<Color?>(
                              (states) => states.contains(MaterialState.pressed)
                                  ? Colors.black12
                                  : Colors.transparent,
                            ),
                            tabs: List.generate(_tabNames.length, (i) {
                              return Tab(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(_tabIcons[i], size: 16),
                                    const SizedBox(width: 8),
                                    Text(
                                      _tabNames[i].toUpperCase(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.2,
                                        fontSize: 12.5,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
                  ],
                  body: TabBarView(
                    controller: _tabController,
                    children: List.generate(5, (tabIndex) {
                      final items = _tabData[tabIndex];

                      // Loading state per tab
                      if (_isLoading[tabIndex]) {
                        return const Center(
                            child: CupertinoActivityIndicator(radius: 16));
                      }

                      // Empty state after loading
                      if (items.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Text(
                              'No Data found',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      }

                      // Content list
                      return CustomScrollView(
                        physics: const BouncingScrollPhysics(),
                        slivers: [
                          SliverPadding(
                            padding: const EdgeInsets.all(8),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) => Container(
                                  //margin: const EdgeInsets.only(bottom: 16),
                                  child: ApprovalCard(
                                    approvalData: items[index],
                                    onApprove: _onApprove,
                                    isApproved: true,
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
