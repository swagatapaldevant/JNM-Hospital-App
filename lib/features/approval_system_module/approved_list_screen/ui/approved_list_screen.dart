import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/api_endpoint.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/resource.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/status.dart';
import 'package:jnm_hospital_app/features/approval_system_module/approved_list_screen/data/approved_list_usecases_impl.dart';
import 'package:jnm_hospital_app/features/approval_system_module/common/widgets/bill_card_simmer.dart';
import 'package:jnm_hospital_app/features/approval_system_module/common/widgets/common_card.dart';
import 'package:jnm_hospital_app/features/approval_system_module/model/approval_system_model.dart';
import 'package:jnm_hospital_app/features/patient_module/patient_details/ui/common_search_field.dart';

class ApprovedListScreen extends StatefulWidget {
  final List<String> tabList;
  final List<String> tabUrl;

  const ApprovedListScreen(
      {super.key, required this.tabList, required this.tabUrl});

  @override
  State<ApprovedListScreen> createState() => _ApprovedListScreenState();
}

class _ApprovedListScreenState extends State<ApprovedListScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  // Data + loading per tab
  List<List<ApprovalSystemModel>> _tabData = [];
  List<bool> _isLoading = [];

  List<String> _tabNames = [];

  List<List<ApprovalSystemModel>> _filteredTabData = [];

  final TextEditingController _search = TextEditingController();

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
    _tabController = TabController(length: widget.tabList.length, vsync: this);
    _tabData.addAll(List.generate(widget.tabList.length, (_) => []));
    _filteredTabData.addAll(List.generate(widget.tabList.length, (_) => []));
    _isLoading.addAll(List.generate(widget.tabList.length, (_) => false));

    _fetchTabData(0);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      final i = _tabController.index;
      if (_tabData[i].isEmpty && !_isLoading[i]) {
        _fetchTabData(i);
      } else {
        _filterBills(); // reapply filter when switching tabs
      }
    });
    _tabNames = widget.tabList;
  }

  Future<void> _fetchTabData(int tabIndex) async {
    final List<String> tabURL = widget.tabUrl;

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
        _filteredTabData[tabIndex] = approvals;
        _isLoading[tabIndex] = false;
      });
    } else {
      debugPrint("Error fetching approved list: ${resource.message}");
      setState(() => _isLoading[tabIndex] = false);
    }
  }

  void _filterBills() {
    final query = _search.text.trim().toLowerCase();
    final currentTab = _tabController.index;

    if (query.isEmpty) {
      _filteredTabData[currentTab] = List.from(_tabData[currentTab]);
    } else {
      _filteredTabData[currentTab] = _tabData[currentTab].where((item) {
        final billId = item.uid?.toString().toLowerCase() ?? "";
        return billId.contains(query);
      }).toList();
    }
    setState(() {});
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
                    children: List.generate(widget.tabList.length, (tabIndex) {
                      final items = _filteredTabData[tabIndex];

                      if (_isLoading[tabIndex]) {
                        return CustomScrollView(
                          slivers: [
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) => const BillCardShimmer(),
                                childCount: 6,
                              ),
                            ),
                          ],
                        );
                      }

                      return Column(
                        children: [
                          // 🔍 Search field
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: SearchField(
                              controller: _search,
                              hint: 'Search bill by id',
                              onChanged: (_) => _filterBills(),
                            ),
                          ),
                          Expanded(
                            child: items.isEmpty
                                ? const Center(
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
                                  )
                                : CustomScrollView(
                                    physics: const BouncingScrollPhysics(),
                                    slivers: [
                                      SliverPadding(
                                        padding: const EdgeInsets.all(8),
                                        sliver: SliverList(
                                          delegate: SliverChildBuilderDelegate(
                                            (context, index) => ApprovalCard(
                                              approvalData: items[index],
                                              onApprove: _onApprove,
                                              isApproved: true,
                                            ),
                                            childCount: items.length,
                                          ),
                                        ),
                                      ),
                                    ],
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
