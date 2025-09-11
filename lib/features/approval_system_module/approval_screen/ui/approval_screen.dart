import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool _isPaging = false; // bottom loader while fetching next page
  bool _hasMore = true; // stop when server returns no more rows
  bool _mounted = true; // guard async setState after dispose

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
      final newItems =
          data.map((e) => ApprovalSystemModel.fromJson(e)).toList();

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
        // ---- Prefill discount snapshots from API ----
        for (final b in newItems) {
          if (_discountsByBill.containsKey(b.id)) continue;

          final total = (b.total ?? 0).toDouble();
          final discountAmt = (b.discount ?? 0).toDouble();
          final mode = _parseDiscountMode(b.discountType);

          // what should appear in the editor input:
          final inputValue = mode == DiscountMode.flat
              ? discountAmt
              : (total > 0 ? (discountAmt / total) * 100.0 : 0.0);

          double grandTotal = double.parse(b.grandTotal.toString());

          _discountsByBill[b.id] = DiscountSnapshot(
            mode: mode,
            inputValue: inputValue,
            discountAmount: discountAmt,
            grandTotal: grandTotal,
          );
        }
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

  // Future<void> approveData(int billId) async {
  //   if (_bills.isEmpty) return;
  //
  //   final response = await getIt<ApprovalUsecases>()
  //       .approveData(
  //       ApiEndPoint.approveData,
  //       billId,
  //     {
  //       "discount":_inputValue.toString(),
  //       "discount_type": _mode.toString(),
  //       "discount_amount":_mode.toString() == "flat"?_inputValue.toString():_grandTotal.toString()
  //     }
  //
  //
  //
  //   );
  //
  //   if (!_mounted) return;
  //
  //   if (response.status == STATUS.SUCCESS) {
  //     // _fetchBills(initial: true);
  //
  //     CommonUtils().flutterSnackBar(
  //       context: context,
  //       mes: "Approval successful",
  //       messageType: 1,
  //     );
  //     // OPTIONAL: Refresh the list or locally mark approved
  //     _currentPage = 1;
  //     _hasMore = true;
  //     await _fetchBills(initial: true);
  //   } else {
  //     CommonUtils().flutterSnackBar(
  //       context: context,
  //       mes: "Approval failed",
  //       messageType: 2,
  //     );
  //   }
  // }

  Future<void> approveData(int billId) async {
    final snap = _discountsByBill[billId];
    if (snap == null) {
      // Fallback: no edits captured; infer from the model on the fly
      final b = _bills.firstWhere((x) => x.id == billId);
      final mode = _parseDiscountMode(b.discountType);
      final total = (b.total ?? 0).toDouble();
      final discountAmt = (b.discount ?? 0).toDouble();
      final inputValue = mode == DiscountMode.flat
          ? discountAmt
          : (total > 0 ? (discountAmt / total) * 100.0 : 0.0);

      _discountsByBill[billId] = DiscountSnapshot(
        mode: mode,
        inputValue: inputValue,
        discountAmount: discountAmt,
        grandTotal: (total - discountAmt).clamp(0, double.infinity),
      );
    }
    final s = _discountsByBill[billId]!;

    final payload = {
      // What the user typed (₹ or % based on mode)
      "discount": s.inputValue.toStringAsFixed(2),

      // The server-friendly type string
      "discount_type": _apiDiscountType(s.mode),

      // Always send the computed ₹ amount explicitly
      "discount_amount": s.discountAmount.toStringAsFixed(2),

      // (Optional) If your API accepts it, include grand total for transparency
      // "grand_total": s.grandTotal.toStringAsFixed(2),
    };

    final response = await getIt<ApprovalUsecases>()
        .approveData(ApiEndPoint.approveData, billId, payload);

    if (!_mounted) return;

    if (response.status == STATUS.SUCCESS) {
      CommonUtils().flutterSnackBar(
        context: context, mes: "Approval successful", messageType: 1,
      );
      _currentPage = 1;
      _hasMore = true;
      await _fetchBills(initial: true);
    } else {
      CommonUtils().flutterSnackBar(
        context: context, mes: "Approval failed", messageType: 2,
      );
    }
  }


  Future<void> _confirmApprove(BuildContext context, int billId) async {
    if (!_mounted) return;

    final bool? ok = await showModalBottomSheet<bool>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      // we draw our own container
      builder: (ctx) => _ApproveSheet(billId: billId),
    );

    if (ok == true) {
      await approveData(billId);
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
                onApprove: (id) => _confirmApprove(context, id),
                onDiscountChanged: ({
                  required DiscountMode mode,
                  required double inputValue,
                  required double discountAmount,
                  required double grandTotal,
                }) {
                  setState(() {
                    _discountsByBill[bill.id] = DiscountSnapshot(
                      mode: mode,
                      inputValue: inputValue,
                      discountAmount: discountAmount,
                      grandTotal: grandTotal,
                    );
                  });

                  debugPrint(
                    'Bill #${bill.id} -> mode: ${mode.name}, input: $inputValue, '
                        'amount: $discountAmount, grand: $grandTotal',
                  );
                },
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

class _ApproveSheet extends StatefulWidget {
  const _ApproveSheet({required this.billId});

  final int billId;

  @override
  State<_ApproveSheet> createState() => _ApproveSheetState();
}

class _ApproveSheetState extends State<_ApproveSheet> {
  bool _submitting = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: cs.shadow.withOpacity(0.15),
                  blurRadius: 24,
                  spreadRadius: 0,
                  offset: const Offset(0, 12),
                ),
              ],
              border: Border.all(color: cs.outlineVariant.withOpacity(0.4)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: cs.outlineVariant.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Icon badge with gradient
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [cs.primary, cs.secondary],
                    ),
                  ),
                  child: Icon(Icons.verified_rounded,
                      size: 28, color: cs.onPrimary),
                ),
                const SizedBox(height: 12),

                Text(
                  'Approve this request?',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                Text(
                  'Are you sure you want to approve #${widget.billId}? '
                  'This action cannot be undone.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: cs.onSurfaceVariant,
                    height: 1.35,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                // Fancy info row (optional—kept minimal since we only have id)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: cs.outlineVariant.withOpacity(0.35)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.receipt_long_rounded,
                          size: 20, color: cs.onSurfaceVariant),
                      const SizedBox(width: 8),
                      Text(
                        'Bill ID: ${widget.billId}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    // Cancel
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _submitting
                            ? null
                            : () => Navigator.pop(context, false),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text('Not now'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Approve
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _submitting
                            ? null
                            : () async {
                                HapticFeedback.lightImpact();
                                setState(() => _submitting = true);

                                // Tiny delay purely for UX polish so the loader is visible.
                                await Future.delayed(
                                    const Duration(milliseconds: 300));

                                if (mounted) {
                                  Navigator.pop(context, true);
                                }
                              },
                        icon: _submitting
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.check_rounded),
                        label:
                            Text(_submitting ? 'Approving…' : 'Yes, approve'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class DiscountSnapshot {
  final DiscountMode mode;      // flat | percent
  final double inputValue;      // what user typed (₹ or %)
  final double discountAmount;  // computed ₹
  final double grandTotal;      // computed ₹

  const DiscountSnapshot({
    required this.mode,
    required this.inputValue,
    required this.discountAmount,
    required this.grandTotal,
  });
}

final Map<int, DiscountSnapshot> _discountsByBill = {};

DiscountMode _parseDiscountMode(String? raw) {
  final v = (raw ?? '').trim().toLowerCase();
  const percentTokens = {'percent', 'percentage', '%', 'pct', 'p'};
  const flatTokens = {'flat', 'amount', 'rs', '₹', 'f'};
  if (percentTokens.contains(v)) return DiscountMode.percent;
  if (flatTokens.contains(v)) return DiscountMode.flat;
  return DiscountMode.flat;
}

String _apiDiscountType(DiscountMode m) =>
    m == DiscountMode.percent ? 'percentage' : 'flat';
