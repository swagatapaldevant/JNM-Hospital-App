import 'package:flutter/material.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/api_endpoint.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/locator.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/status.dart';
import 'package:jnm_hospital_app/core/utils/helper/common_utils.dart';
import 'package:jnm_hospital_app/features/approval_system_module/common/widgets/common_card.dart';
import 'package:jnm_hospital_app/features/approval_system_module/common/widgets/common_layout.dart';
import 'package:jnm_hospital_app/features/approval_system_module/model/approval_system_model.dart';
import 'package:jnm_hospital_app/features/approval_system_module/approval_screen/data/approval_usecases.dart';

import '../../common/widgets/common_header.dart' show CommonHeader;

class ApprovalScreen extends StatefulWidget {
  const ApprovalScreen({
    super.key,
    required this.apiEndpoint,
    required this.title,
  });

  final String apiEndpoint;
  final String title;

  @override
  State<ApprovalScreen> createState() => _ApprovalScreenState();
}

class _ApprovalScreenState extends State<ApprovalScreen> {
  final ScrollController _scrollController = ScrollController();

  final List<ApprovalSystemModel> _bills = [];
  int _currentPage = 1;

  bool _isInitialLoading = false; // full-screen first load
  bool _isPaging = false;         // bottom loader while fetching next page
  bool _hasMore = true;           // stop when server returns no more rows
  bool _mounted = true;           // guard async setState after dispose

  @override
  void initState() {
    super.initState();
    _fetchBills(initial: true);

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _mounted = false;
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_hasMore || _isPaging || _isInitialLoading) return;

    // Trigger when user nears the bottom (200px before end)
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _currentPage += 1;
      _fetchBills();
    }
  }

  Future<void> _fetchBills({bool initial = false}) async {
    if (initial) {
      setState(() => _isInitialLoading = true);
    } else {
      setState(() => _isPaging = true);
    }

    final response = await getIt<ApprovalUsecases>()
        .getApprovalData(widget.apiEndpoint, _currentPage);

    if (!_mounted) return;

    if (response.status == STATUS.SUCCESS) {
      final List<dynamic> data = (response.data ?? []) as List<dynamic>;
      final newItems = data.map((e) => ApprovalSystemModel.fromJson(e)).toList();

      setState(() {
        if (initial) {
          _bills
            ..clear()
            ..addAll(newItems);
        } else {
          _bills.addAll(newItems);
        }
        // If the server returned empty, there are no more pages.
        _hasMore = newItems.isNotEmpty;
      });
    } else {
      if (initial) {
        setState(() {
          _bills.clear();
          _hasMore = false;
        });
      }
      // Show a non-blocking error
      CommonUtils().flutterSnackBar(
        context: context,
        mes: "Failed to load data",
        messageType: 2,
      );
    }

    setState(() {
      _isInitialLoading = false;
      _isPaging = false;
    });
  }

  Future<void> approveData(int billId) async {
    if (_bills.isEmpty) return;

    final response = await getIt<ApprovalUsecases>()
        .approveData(ApiEndPoint.approveData, billId);

    if (!_mounted) return;

    if (response.status == STATUS.SUCCESS) {

     // _fetchBills(initial: true);

      CommonUtils().flutterSnackBar(
        context: context,
        mes: "Approval successful",
        messageType: 1,
      );
      // OPTIONAL: Refresh the list or locally mark approved
      _currentPage = 1;
      _hasMore = true;
      await _fetchBills(initial: true);
    } else {
      CommonUtils().flutterSnackBar(
        context: context,
        mes: "Approval failed",
        messageType: 2,
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return ApprovalSystemLayout(
      controller: _scrollController,
      slivers: [
        CommonHeader(title: widget.title),

        // Initial full-screen loader
        if (_isInitialLoading)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: CircularProgressIndicator()),
          )

        // Empty state (only after initial load)
        else if (_bills.isEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(
                  "No Data found",
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          )

        // List + bottom loader
        else ...[
            SliverList.separated(
              itemCount: _bills.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final bill = _bills[index];
                return ApprovalCard(
                  approvalData: bill, 
                  onApprove: approveData,
                );
              },
            ),

            // Bottom space so last card isn't hidden under system bars
            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            // Bottom loader only when paging (keeps it below the screen)
            if (_isPaging)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),

            // Optional: “No more data” indicator
            if (!_isPaging && !_hasMore)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Center(
                    child: Text(
                      "You've reached the end",
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                ),
              ),
          ],
      ],
    );
  }
}
