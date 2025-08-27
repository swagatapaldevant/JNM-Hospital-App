import 'package:flutter/material.dart';
import 'package:jnm_hospital_app/features/approval_system_module/model/approval_system_model.dart';

class ApprovalCard extends StatelessWidget {

  final ApprovalSystemModel approvalData;

  ApprovalCard({super.key, required this.approvalData});

   @override
   Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildBillTypeChip(approvalData.section!),
                Text(
                  approvalData.billDate?.toLocal().toString().split(' ')[0] ?? '',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 6),

            Text("Bill ID: ${approvalData.id}",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text("Patient: ${approvalData.patientName}"),

            const Divider(),

            // Amounts
            Text("Total: ₹${approvalData.total?.toStringAsFixed(2)}"),
            Text("Discount: ₹${approvalData.discount?.toStringAsFixed(2)}"),
            Text(
              "Grand Total: ₹${approvalData.grandTotal?.toStringAsFixed(2)}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("Payment: ₹${approvalData.totalPayment?.toStringAsFixed(2)}"),
            Text(
              "Due: ₹${approvalData.dueAmount?.toStringAsFixed(2)}",
              style: const TextStyle(color: Colors.red),
            ),

            const Divider(),

            // Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Created by: ${approvalData.createdBy}",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                ElevatedButton(
                  onPressed: () {
                    // handle approve action
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text("Approve"),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillTypeChip(String type) {
    Color color;
    switch (type) {
      case "IPD":
        color = Colors.deepPurple;
        break;
      case "OPD":
        color = Colors.teal;
        break;
      case "DAYCARE":
        color = Colors.blue;
        break;
      case "INVESTIGATION":
        color = Colors.orange;
        break;
      default:
        color = Colors.grey;
    }
    return Chip(
      label: Text(type, style: const TextStyle(color: Colors.white)),
      backgroundColor: color,
    );
  }
}