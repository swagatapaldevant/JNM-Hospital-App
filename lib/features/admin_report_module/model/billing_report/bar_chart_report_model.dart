class BarchartReportModel {
  String? section;
  String? total;
  String? discountAmount;
  String? grandTotal;
  String? totalPayment;
  String? dueAmount;

  BarchartReportModel(
      {this.section,
        this.total,
        this.discountAmount,
        this.grandTotal,
        this.totalPayment,
        this.dueAmount});

  BarchartReportModel.fromJson(Map<String, dynamic> json) {
    section = json['section'];
    total = json['total'];
    discountAmount = json['discount_amount'];
    grandTotal = json['grand_total'];
    totalPayment = json['total_payment'];
    dueAmount = json['due_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['section'] = this.section;
    data['total'] = this.total;
    data['discount_amount'] = this.discountAmount;
    data['grand_total'] = this.grandTotal;
    data['total_payment'] = this.totalPayment;
    data['due_amount'] = this.dueAmount;
    return data;
  }
}