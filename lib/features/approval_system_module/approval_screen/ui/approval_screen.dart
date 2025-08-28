import 'package:flutter/material.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/locator.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/status.dart';
import 'package:jnm_hospital_app/features/approval_system_module/common/widgets/common_card.dart';
import 'package:jnm_hospital_app/features/approval_system_module/common/widgets/common_layout.dart';
import 'package:jnm_hospital_app/features/approval_system_module/model/approval_system_model.dart';
import 'package:jnm_hospital_app/features/approval_system_module/approval_screen/data/approval_usecases.dart';

import '../../common/widgets/common_header.dart' show CommonHeader;

class ApprovalScreen extends StatefulWidget {
  const ApprovalScreen(
      {super.key, required this.apiEndpoint, required this.title});

  final String apiEndpoint;
  final String title;

  @override
  State<ApprovalScreen> createState() => _ApprovalScreenState();
}

class _ApprovalScreenState extends State<ApprovalScreen> {
  List<ApprovalSystemModel> bills = [];
  int currentPage = 1;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchBills();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !isLoading && bills.isNotEmpty) {
        currentPage += 1;
        _fetchBills();
      }
    });
  }

  ScrollController _scrollController = ScrollController();

  Future<void> _fetchBills() async {
    setState(() {
      isLoading = true;
    });
    final response = await getIt<ApprovalUsecases>()
        .getApprovalData(widget.apiEndpoint, currentPage);
    if (response.status == STATUS.SUCCESS) {
      print(response.data);
      List<dynamic> data = response.data ?? [];
      if (bills.isEmpty) {
        setState(() {
          bills =
              data.map((item) => ApprovalSystemModel.fromJson(item)).toList();
        });
      } else {
        setState(() {
          if (data.isNotEmpty) {
            bills.addAll(data
                .map((item) => ApprovalSystemModel.fromJson(item))
                .toList());
          }
        });
      }
    } else {
      setState(() {
        bills = [];
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ApprovalSystemLayout(
      controller: _scrollController,
      slivers: [
        CommonHeader(title: widget.title),
        if (isLoading)
          const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          )
        else if (bills.isEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                  child: Text("No Data found", style: TextStyle(fontSize: 18))),
            ),
          ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final bill = bills[index];
              return ApprovalCard(approvalData: bill);
            },
            childCount: bills.length,
          ),
        ),

        // SliverToBoxAdapter(
        //   child: Pagination(
        //     currentPage: currentPage,
        //     totalPages: totalPages,
        //     onPageChanged: (page) {
        //       setState(() {
        //         currentPage = page;
        //       });
        //     },
        //   ),
        // )
      ],
    );
  }
}

// class Pagination extends StatelessWidget {
//   final int currentPage;
//   final int totalPages;
//   final ValueChanged<int> onPageChanged;

//   const Pagination({
//     Key? key,
//     required this.currentPage,
//     required this.totalPages,
//     required this.onPageChanged,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     List<Widget> pageButtons = [];

//     for (int i = 1; i <= totalPages; i++) {
//       pageButtons.add(
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 4),
//           child: ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: i == currentPage
//                   ? Theme.of(context).colorScheme.primary
//                   : Colors.grey.shade300,
//               foregroundColor: i == currentPage ? Colors.white : Colors.black,
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//             onPressed: () => onPageChanged(i),
//             child: Text("$i"),
//           ),
//         ),
//       );
//     }

//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         // Previous button
//         IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed:
//               currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
//         ),

//         // Page numbers
//         ...pageButtons,

//         // Next button
//         IconButton(
//           icon: const Icon(Icons.arrow_forward),
//           onPressed: currentPage < totalPages
//               ? () => onPageChanged(currentPage + 1)
//               : null,
//         ),
//       ],
//     );
//   }
// }

class Pagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;

  const Pagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  List<Widget> _buildPageButtons(BuildContext context) {
    List<Widget> buttons = [];

    if (totalPages <= 5) {
      // Show all pages if 5 or fewer
      for (int i = 1; i <= totalPages; i++) {
        buttons.add(_buildPageButton(context, i));
      }
    } else {
      // Always show first page
      buttons.add(_buildPageButton(context, 1));

      if (currentPage > 3) {
        buttons.add(_buildDotsIndicator());
      }

      // Show current page and neighbors
      int start = (currentPage - 1).clamp(2, totalPages - 1);
      int end = (currentPage + 1).clamp(2, totalPages - 1);

      // Adjust to always show 3 numbers in middle section
      if (currentPage <= 3) {
        start = 2;
        end = 3.clamp(2, totalPages - 1);
      } else if (currentPage >= totalPages - 2) {
        start = (totalPages - 2).clamp(2, totalPages - 1);
        end = totalPages - 1;
      }

      for (int i = start; i <= end; i++) {
        if (i != 1 && i != totalPages) {
          buttons.add(_buildPageButton(context, i));
        }
      }

      if (currentPage < totalPages - 2) {
        buttons.add(_buildDotsIndicator());
      }

      // Always show last page if more than 1 page
      if (totalPages > 1) {
        buttons.add(_buildPageButton(context, totalPages));
      }
    }

    return buttons;
  }

  Widget _buildPageButton(BuildContext context, int pageNumber) {
    final isActive = pageNumber == currentPage;

    return Padding(
      key: ValueKey('page_$pageNumber'),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: () => onPageChanged(pageNumber),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: isActive
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF667eea),
                      Color(0xFF764ba2),
                    ],
                  )
                : null,
            color: isActive ? null : Colors.white,
            border: Border.all(
              color: isActive ? Colors.transparent : const Color(0xFFE5E7EB),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: isActive
                    ? const Color(0xFF667eea).withOpacity(0.3)
                    : Colors.black.withOpacity(0.05),
                blurRadius: isActive ? 8 : 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              '$pageNumber',
              style: TextStyle(
                color: isActive ? Colors.white : const Color(0xFF6B7280),
                fontSize: 16,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDotsIndicator() {
    return Padding(
      key: const ValueKey('dots'),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: const Text(
        '...',
        style: TextStyle(
          color: Color(0xFF9CA3AF),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required String keyValue,
  }) {
    final isEnabled = onPressed != null;

    return Container(
      key: ValueKey(keyValue),
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(
          icon,
          size: 18,
          color: isEnabled ? const Color(0xFF667eea) : const Color(0xFFD1D5DB),
        ),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        splashRadius: 20,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey('pagination_${currentPage}_$totalPages'),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildNavButton(
            icon: Icons.chevron_left_rounded,
            onPressed:
                currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
            keyValue: 'prev_button',
          ),
          const SizedBox(width: 16),
          Row(
            key: ValueKey('page_buttons_${currentPage}_$totalPages'),
            children: _buildPageButtons(context),
          ),
          const SizedBox(width: 16),
          _buildNavButton(
            icon: Icons.chevron_right_rounded,
            onPressed: currentPage < totalPages
                ? () => onPageChanged(currentPage + 1)
                : null,
            keyValue: 'next_button',
          ),
        ],
      ),
    );
  }
}
