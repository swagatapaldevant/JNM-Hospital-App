import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:jnm_hospital_app/features/patient_module/model/patient_details/patient_details_model.dart';

class PatientBillDetailsScreen extends StatelessWidget {
  final BillDetail bill;

  const PatientBillDetailsScreen({super.key, required this.bill});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bill Details"),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1.2,
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  _buildInfoTile(Icons.confirmation_number, "Bill ID", bill.id.toString(), Colors.blue),
                  _buildInfoTile(Icons.local_hospital, "Section", bill.section ?? "unknown", Colors.teal),
                  _buildInfoTile(Icons.date_range, "Bill Date", bill.billDate.toString(), Colors.deepPurple),
                  _buildInfoTile(Icons.person, "Patient ID", bill.patientId.toString(), Colors.orange),
                  _buildInfoTile(Icons.medical_services, "Doctor ID", bill.doctorId.toString(), Colors.indigo),
                  const Divider(height: 24, thickness: 1.2),
                  _buildInfoTile(Icons.payments, "Total", "₹${bill.total}", Colors.green),
                  _buildInfoTile(Icons.calculate, "Sub Total", "₹${bill.subTotal}", Colors.blueGrey),
                  _buildInfoTile(Icons.discount, "Discount", "₹${bill.discountAmount}", Colors.redAccent),
                  _buildInfoTile(Icons.attach_money, "Total Payment", "₹${bill.totalPayment}", Colors.greenAccent),
                  _buildInfoTile(Icons.account_balance_wallet, "Due Amount", "₹${bill.dueAmount}", Colors.red),
                  _buildInfoTile(Icons.summarize, "Grand Total", "₹${bill.grandTotal}", Colors.blue),
                  const Divider(height: 24, thickness: 1.2),
                  _buildStatusTile(bill.status ?? "Unknown"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value, Color color) {
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
