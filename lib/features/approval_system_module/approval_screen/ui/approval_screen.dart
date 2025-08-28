import 'package:flutter/material.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/api_endpoint.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/locator.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/status.dart';
import 'package:jnm_hospital_app/features/approval_system_module/common/widgets/common_card.dart';
import 'package:jnm_hospital_app/features/approval_system_module/common/widgets/common_layout.dart';
import 'package:jnm_hospital_app/features/approval_system_module/model/approval_system_model.dart';
import 'package:jnm_hospital_app/features/approval_system_module/model/pagination.dart';
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
  final int totalPages = 5;
  @override
  void initState() {
    super.initState();
    _fetchBills();
  }

  bool isLoading = false;

  Future<void> _fetchBills() async {
    setState(() {
      isLoading = true;
    });
    final response = await getIt<ApprovalUsecases>().getApprovalData(
        widget.apiEndpoint, PaginationModel(page: 1, searchData: 1));
    if (response.status == STATUS.SUCCESS) {
      print(response.data);
      List<dynamic> data = response.data ?? [];
      setState(() {
        bills = data.map((item) => ApprovalSystemModel.fromJson(item)).toList();
      });
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

class Pagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;

  const Pagination({
    Key? key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> pageButtons = [];

    for (int i = 1; i <= totalPages; i++) {
      pageButtons.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: i == currentPage
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey.shade300,
              foregroundColor: i == currentPage ? Colors.white : Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => onPageChanged(i),
            child: Text("$i"),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Previous button
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed:
              currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
        ),

        // Page numbers
        ...pageButtons,

        // Next button
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: currentPage < totalPages
              ? () => onPageChanged(currentPage + 1)
              : null,
        ),
      ],
    );
  }
}
