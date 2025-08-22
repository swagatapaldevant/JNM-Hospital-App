import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:jnm_hospital_app/features/patient_module/model/patient_details/patient_details_model.dart';
import 'package:jnm_hospital_app/features/patient_module/patient_details_module/ui/common_layout.dart';

class PatientBillDetailsScreen extends StatelessWidget {
  final BillDetail bill;

  const PatientBillDetailsScreen({super.key, required this.bill});

  @override
  Widget build(BuildContext context) {
    return PatientDetailsScreenLayout(
      heading: "Bill Details",
      child: SliverPadding(
        padding: const EdgeInsets.all(20.0),
        sliver: SliverList(
          delegate: SliverChildListDelegate([
            _buildInfoTile(Icons.confirmation_number, "Bill ID",
                bill.id?.toString() ?? "N/A", Colors.blue),
            _buildInfoTile(Icons.local_hospital, "Section",
                bill.section ?? "unknown", Colors.teal),
            _buildInfoTile(Icons.date_range, "Bill Date",
                bill.billDate?.toString() ?? "N/A", Colors.deepPurple),
            _buildInfoTile(Icons.person, "Patient ID",
                bill.patientId?.toString() ?? "N/A", Colors.orange),
            _buildInfoTile(Icons.medical_services, "Doctor ID",
                bill.doctorId?.toString() ?? "N/A", Colors.indigo),
            const Divider(height: 24, thickness: 1.2),
            _buildInfoTile(
                Icons.payments, "Total", "₹${bill.total ?? 0}", Colors.green),
            _buildInfoTile(Icons.calculate, "Sub Total", "₹${bill.subTotal ?? 0}",
                Colors.blueGrey),
            _buildInfoTile(Icons.discount, "Discount",
                "₹${bill.discountAmount ?? 0}", Colors.redAccent),
            _buildInfoTile(Icons.attach_money, "Total Payment",
                "₹${bill.totalPayment ?? 0}", Colors.greenAccent),
            _buildInfoTile(Icons.account_balance_wallet, "Due Amount",
                "₹${bill.dueAmount ?? 0}", Colors.red),
            _buildInfoTile(Icons.summarize, "Grand Total",
                "₹${bill.grandTotal ?? 0}", Colors.blue),
            const Divider(height: 24, thickness: 1.2),
            _buildStatusTile(bill.status ?? "Unknown"),
          ]),
        ),
      ),
    );
  }

  Widget _buildInfoTile(
      IconData icon, String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    )),
                const SizedBox(height: 2),
                Text(value,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStatusTile(String status) {
    Color statusColor =
        status.toLowerCase() == "done" ? Colors.green : Colors.orange;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.verified, color: statusColor),
          const SizedBox(width: 8),
          Text(
            "Status: $status",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }
}
