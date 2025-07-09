class BillingReportModel {
  int? id;
  String? uid;
  String? section;
  String? billDate;
  int? patientId;
  String? patientName;
  String? phone;
  String? doctorName;
  String? total;
  String? grandTotal;
  String? discountAmount;
  String? totalPayment;
  String? refundAmount;
  String? dueAmount;
  String? cradituseBillAmount;
  String? refBy;
  String? marBy;
  String? proBy;
  int? billStatus;
  String? creDate;
  int? dueAmountTotal;
  int? refundAmountTotal;
  int? adjustmentAmountTotal;
  Amounts? amounts;

  BillingReportModel(
      {this.id,
        this.uid,
        this.section,
        this.billDate,
        this.patientId,
        this.patientName,
        this.phone,
        this.doctorName,
        this.total,
        this.grandTotal,
        this.discountAmount,
        this.totalPayment,
        this.refundAmount,
        this.dueAmount,
        this.cradituseBillAmount,
        this.refBy,
        this.marBy,
        this.proBy,
        this.billStatus,
        this.creDate,
        this.dueAmountTotal,
        this.refundAmountTotal,
        this.adjustmentAmountTotal,
        this.amounts});

  BillingReportModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    section = json['section'];
    billDate = json['bill_date'];
    patientId = json['patient_id'];
    patientName = json['patient_name'];
    phone = json['phone'];
    doctorName = json['doctor_name'];
    total = json['total'];
    grandTotal = json['grand_total'];
    discountAmount = json['discount_amount'];
    totalPayment = json['total_payment'];
    refundAmount = json['refund_amount'];
    dueAmount = json['due_amount'];
    cradituseBillAmount = json['cradituse_bill_amount'];
    refBy = json['ref_by'];
    marBy = json['mar_by'];
    proBy = json['pro_by'];
    billStatus = json['bill_status'];
    creDate = json['cre_date'];
    dueAmountTotal = json['due_amount_total'];
    refundAmountTotal = json['refund_amount_total'];
    adjustmentAmountTotal = json['adjustment_amount_total'];
    amounts =
    json['amounts'] != null ? new Amounts.fromJson(json['amounts']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uid'] = this.uid;
    data['section'] = this.section;
    data['bill_date'] = this.billDate;
    data['patient_id'] = this.patientId;
    data['patient_name'] = this.patientName;
    data['phone'] = this.phone;
    data['doctor_name'] = this.doctorName;
    data['total'] = this.total;
    data['grand_total'] = this.grandTotal;
    data['discount_amount'] = this.discountAmount;
    data['total_payment'] = this.totalPayment;
    data['refund_amount'] = this.refundAmount;
    data['due_amount'] = this.dueAmount;
    data['cradituse_bill_amount'] = this.cradituseBillAmount;
    data['ref_by'] = this.refBy;
    data['mar_by'] = this.marBy;
    data['pro_by'] = this.proBy;
    data['bill_status'] = this.billStatus;
    data['cre_date'] = this.creDate;
    data['due_amount_total'] = this.dueAmountTotal;
    data['refund_amount_total'] = this.refundAmountTotal;
    data['adjustment_amount_total'] = this.adjustmentAmountTotal;
    if (this.amounts != null) {
      data['amounts'] = this.amounts!.toJson();
    }
    return data;
  }
}

class Amounts {
  int? due;
  int? refund;
  int? adjustment;

  Amounts({this.due, this.refund, this.adjustment});

  Amounts.fromJson(Map<String, dynamic> json) {
    due = json['due'];
    refund = json['refund'];
    adjustment = json['adjustment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['due'] = this.due;
    data['refund'] = this.refund;
    data['adjustment'] = this.adjustment;
    return data;
  }
}