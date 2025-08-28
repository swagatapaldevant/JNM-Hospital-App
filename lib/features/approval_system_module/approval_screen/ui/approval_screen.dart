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
          !isLoading &&
          bills.isNotEmpty) {
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

  Future<void> approveData(int billId) async {
    if (bills.isNotEmpty) {
      final response = await getIt<ApprovalUsecases>()
          .approveData(ApiEndPoint.approveData, billId);
      if (response.status == STATUS.SUCCESS) {
        CommonUtils().flutterSnackBar(
            context: context, mes: "Approval successful", messageType: 1);
      } else {
        CommonUtils().flutterSnackBar(
            context: context, mes: "Approval failed", messageType: 2);
      }
    }
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
              return ApprovalCard(approvalData: bill, onApprove: approveData);
            },
            childCount: bills.length,
          ),
        )
      ],
    );
  }
}
