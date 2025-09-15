class PatientBillModel {
  PatientBillModel({
    required this.id,
    required this.uid,
    required this.section,
    required this.sectionId,
    required this.billDate,
    required this.patientId,
    required this.doctorId,
    required this.referredBy,
    required this.marketBy,
    required this.provider,
    required this.caseId,
    required this.total,
    required this.subTotal,
    required this.miscellaneousAmount,
    required this.miscellaneous,
    required this.miscellaneousType,
    required this.discountAmount,
    required this.discount,
    required this.discountType,
    required this.discountStatus,
    required this.totalPayment,
    required this.dueAmount,
    required this.craditAmount,
    required this.refundAmount,
    required this.cradituseBillId,
    required this.cradituseBillAmount,
    required this.grandTotal,
    required this.status,
    required this.financeRemark,
    required this.departmentPartyRemark,
    required this.approvalRemark,
    required this.createdBy,
    required this.refundBy,
    required this.refundAt,
    required this.editBy,
    required this.editAt,
    required this.editStatus,
    required this.billStatus,
    required this.approvedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.isDelete,
    required this.doctorName,
    required this.createdName,
  });

  final int? id;
  final String? uid;
  final String? section;
  final int? sectionId;
  final DateTime? billDate;
  final int? patientId;
  final int? doctorId;
  final int? referredBy;
  final dynamic marketBy;
  final dynamic provider;
  final int? caseId;
  final int? total;
  final int? subTotal;
  final int? miscellaneousAmount;
  final int? miscellaneous;
  final dynamic miscellaneousType;
  final int? discountAmount;
  final int? discount;
  final String? discountType;
  final String? discountStatus;
  final int? totalPayment;
  final int? dueAmount;
  final int? craditAmount;
  final int? refundAmount;
  final dynamic cradituseBillId;
  final dynamic cradituseBillAmount;
  final int? grandTotal;
  final String? status;
  final dynamic financeRemark;
  final dynamic departmentPartyRemark;
  final dynamic approvalRemark;
  final int? createdBy;
  final dynamic refundBy;
  final dynamic refundAt;
  final dynamic editBy;
  final dynamic editAt;
  final int? editStatus;
  final int? billStatus;
  final dynamic approvedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? isDelete;
  final String? doctorName;
  final String? createdName;

  factory PatientBillModel.fromJson(Map<String, dynamic> json) {
    return PatientBillModel(
      id: json["id"],
      uid: json["uid"],
      section: json["section"],
      sectionId: json["section_id"],
      billDate: DateTime.tryParse(json["bill_date"] ?? ""),
      patientId: json["patient_id"],
      doctorId: json["doctor_id"],
      referredBy: json["referred_by"],
      marketBy: json["market_by"],
      provider: json["provider"],
      caseId: json["case_id"],
      total: json["total"],
      subTotal: json["sub_total"],
      miscellaneousAmount: json["miscellaneous_amount"],
      miscellaneous: json["miscellaneous"],
      miscellaneousType: json["miscellaneous_type"],
      discountAmount: json["discount_amount"],
      discount: json["discount"],
      discountType: json["discount_type"],
      discountStatus: json["discount_status"],
      totalPayment: json["total_payment"],
      dueAmount: json["due_amount"],
      craditAmount: json["cradit_amount"],
      refundAmount: json["refund_amount"],
      cradituseBillId: json["cradituse_bill_id"],
      cradituseBillAmount: json["cradituse_bill_amount"],
      grandTotal: json["grand_total"],
      status: json["status"],
      financeRemark: json["finance_remark"],
      departmentPartyRemark: json["department_party_remark"],
      approvalRemark: json["approval_remark"],
      createdBy: json["created_by"],
      refundBy: json["refund_by"],
      refundAt: json["refund_at"],
      editBy: json["edit_by"],
      editAt: json["edit_at"],
      editStatus: json["edit_status"],
      billStatus: json["bill_status"],
      approvedBy: json["approved_by"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      isDelete: json["is_delete"],
      doctorName: json["doctor_name"],
      createdName: json["created_name"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "uid": uid,
        "section": section,
        "section_id": sectionId,
        "bill_date": billDate?.toIso8601String(),
        "patient_id": patientId,
        "doctor_id": doctorId,
        "referred_by": referredBy,
        "market_by": marketBy,
        "provider": provider,
        "case_id": caseId,
        "total": total,
        "sub_total": subTotal,
        "miscellaneous_amount": miscellaneousAmount,
        "miscellaneous": miscellaneous,
        "miscellaneous_type": miscellaneousType,
        "discount_amount": discountAmount,
        "discount": discount,
        "discount_type": discountType,
        "discount_status": discountStatus,
        "total_payment": totalPayment,
        "due_amount": dueAmount,
        "cradit_amount": craditAmount,
        "refund_amount": refundAmount,
        "cradituse_bill_id": cradituseBillId,
        "cradituse_bill_amount": cradituseBillAmount,
        "grand_total": grandTotal,
        "status": status,
        "finance_remark": financeRemark,
        "department_party_remark": departmentPartyRemark,
        "approval_remark": approvalRemark,
        "created_by": createdBy,
        "refund_by": refundBy,
        "refund_at": refundAt,
        "edit_by": editBy,
        "edit_at": editAt,
        "edit_status": editStatus,
        "bill_status": billStatus,
        "approved_by": approvedBy,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "is_delete": isDelete,
        "doctor_name": doctorName,
        "created_name": createdName,
      };
}
