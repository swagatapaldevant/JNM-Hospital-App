import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:jnm_hospital_app/features/patient_module/model/patient_details/patient_details_model.dart';
import 'package:jnm_hospital_app/features/patient_module/patient_details_module/ui/common_layout.dart';

class PatientReceiptDetailsScreen extends StatelessWidget {
  final ReceiptDetail receipt;

  const PatientReceiptDetailsScreen({
    super.key,
    required this.receipt,
  });

  @override
  Widget build(BuildContext context) {
    return PatientDetailsScreenLayout(
      heading: "Receipt Details",
      child: SliverPadding(
        padding: EdgeInsets.all(20.0),
        sliver: SliverList(
          delegate: SliverChildListDelegate([
            _buildInfoTile(Icons.receipt_long, "Receipt ID", receipt.id.toString(), Colors.blue),
            _buildInfoTile(Icons.confirmation_number, "Billing ID", receipt.billingId.toString(), Colors.teal),
            _buildInfoTile(Icons.person, "Patient ID", receipt.patientId.toString(), Colors.deepPurple),
            _buildInfoTile(Icons.local_hospital, "Section", receipt.section ?? "-", Colors.orange),
            _buildInfoTile(Icons.payment, "Payment Amount", "₹${receipt.paymentAmount}", Colors.green),
            _buildPaymentModeTile(receipt.paymentMode ?? "-"),
            _buildInfoTile(Icons.account_balance, "Received By", receipt.paymentRecivedByName ?? "-", Colors.indigo),
            _buildInfoTile(Icons.date_range, "Payment Date", receipt.paymentDate.toString(), Colors.blueGrey),
            _buildInfoTile(Icons.note, "Note", receipt.note ?? "N/A", Colors.brown),
          ]),
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

  Widget _buildPaymentModeTile(String mode) {
    Color color = Colors.blueGrey;
    IconData icon = Icons.payment;

    switch (mode.toLowerCase()) {
      case "cash":
        color = Colors.green;
        icon = Icons.attach_money;
        break;
      case "card":
        color = Colors.blue;
        icon = Icons.credit_card;
        break;
      case "upi":
        color = Colors.purple;
        icon = Icons.qr_code;
        break;
      case "cheque":
        color = Colors.orange;
        icon = Icons.receipt;
        break;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 10),
          Text(
            "Payment Mode: $mode",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
/*
[
                  _buildInfoTile(Icons.receipt_long, "Receipt ID", receipt.id.toString(), Colors.blue),
                  _buildInfoTile(Icons.confirmation_number, "Billing ID", receipt.billingId.toString(), Colors.teal),
                  _buildInfoTile(Icons.person, "Patient ID", receipt.patientId.toString(), Colors.deepPurple),
                  _buildInfoTile(Icons.local_hospital, "Section", receipt.section ?? "-", Colors.orange),
                  _buildInfoTile(Icons.payment, "Payment Amount", "₹${receipt.paymentAmount}", Colors.green),
                  _buildPaymentModeTile(receipt.paymentMode ?? "-"),
                  _buildInfoTile(Icons.account_balance, "Received By", receipt.paymentRecivedByName ?? "-", Colors.indigo),
                  _buildInfoTile(Icons.date_range, "Payment Date", receipt.paymentDate.toString(), Colors.blueGrey),
                  _buildInfoTile(Icons.note, "Note", receipt.note ?? "N/A", Colors.brown),
                ],*/