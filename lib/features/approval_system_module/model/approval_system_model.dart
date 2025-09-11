class ApprovalSystemModel {
  final int id;
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
  final String? miscellaneousType;
  final int? discountAmount;
  final int? discount;
  final String? discountType;
  final String? discountStatus;
  final int? totalPayment;
  final int? dueAmount;
  final int? craditAmount;
  final int? refundAmount;
  final int? cradituseBillId;
  final int? cradituseBillAmount;
  final int? grandTotal;
  final String? status;
  final String? financeRemark;
  final String? departmentPartyRemark;
  final int? createdBy;
  final int? refundBy;
  final DateTime? refundAt;
  final int? editBy;
  final DateTime? editAt;
  final int? editStatus;
  final int? billStatus;
  final int? approvedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? isDelete;
  final String? patientName;
  final String? createdByName;
  final String? approvalRemark;

  ApprovalSystemModel({
    required this.id,
    required this.uid,
    required this.section,
    required this.sectionId,
    required this.billDate,
    required this.patientId,
    required this.doctorId,
    this.referredBy,
    this.marketBy,
    this.provider,
    this.caseId,
    required this.total,
    required this.subTotal,
    required this.miscellaneousAmount,
    required this.miscellaneous,
    this.miscellaneousType,
    required this.discountAmount,
    required this.discount,
    required this.discountType,
    required this.discountStatus,
    required this.totalPayment,
    required this.dueAmount,
    required this.craditAmount,
    required this.refundAmount,
    this.cradituseBillId,
    this.cradituseBillAmount,
    required this.grandTotal,
    required this.status,
    this.financeRemark,
    this.departmentPartyRemark,
    required this.createdBy,
    this.refundBy,
    this.refundAt,
    required this.editBy,
    required this.editAt,
    required this.editStatus,
    required this.billStatus,
    this.approvedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.isDelete,
    required this.patientName,
    required this.createdByName,
    required this.approvalRemark
  });

  
  factory ApprovalSystemModel.fromJson(Map<String, dynamic> json) {
    return ApprovalSystemModel(
      id: json['id'],
      uid: json['uid'],
      section: json['section'],
      sectionId: json['section_id'],
      billDate: DateTime.parse(json['bill_date']),
      patientId: json['patient_id'],
      doctorId: json['doctor_id'],
      referredBy: json['referred_by'],
      marketBy: json['market_by'],
      provider: json['provider'],
      caseId: json['case_id'],
      total: json['total'],
      subTotal: json['sub_total'],
      miscellaneousAmount: json['miscellaneous_amount'],
      miscellaneous: json['miscellaneous'],
      miscellaneousType: json['miscellaneous_type'],
      discountAmount: json['discount_amount'],
      discount: json['discount'],
      discountType: json['discount_type'],
      discountStatus: json['discount_status'],
      totalPayment: json['total_payment'],
      dueAmount: json['due_amount'],
      craditAmount: json['cradit_amount'],
      refundAmount: json['refund_amount'],
      cradituseBillId: json['cradituse_bill_id'],
      cradituseBillAmount: json['cradituse_bill_amount'],
      grandTotal: json['grand_total'],
      status: json['status'],
      financeRemark: json['finance_remark'],
      departmentPartyRemark: json['department_party_remark'],
      createdBy: json['created_by'],
      refundBy: json['refund_by'],
      refundAt: json['refund_at'] != null ? DateTime.tryParse(json['refund_at']) : null,
      editBy: json['edit_by'] ?? 0,
      editAt: json['edit_at'] != null ? DateTime.tryParse(json['edit_at']) : null,
      editStatus: json['edit_status'],
      billStatus: json['bill_status'],
      approvedBy: json['approved_by'],
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : null,
      isDelete: json['is_delete'],
      patientName: json['patient_name'],
      createdByName: json['created_by_name'],
      approvalRemark: json["approval_remark"]
    );
  }

  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'section': section,
      'section_id': sectionId,
      'bill_date': billDate?.toIso8601String(),
      'patient_id': patientId,
      'doctor_id': doctorId,
      'referred_by': referredBy,
      'market_by': marketBy,
      'provider': provider,
      'case_id': caseId,
      'total': total,
      'sub_total': subTotal,
      'miscellaneous_amount': miscellaneousAmount,
      'miscellaneous': miscellaneous,
      'miscellaneous_type': miscellaneousType,
      'discount_amount': discountAmount,
      'discount': discount,
      'discount_type': discountType,
      'discount_status': discountStatus,
      'total_payment': totalPayment,
      'due_amount': dueAmount,
      'cradit_amount': craditAmount,
      'refund_amount': refundAmount,
      'cradituse_bill_id': cradituseBillId,
      'cradituse_bill_amount': cradituseBillAmount,
      'grand_total': grandTotal,
      'status': status,
      'finance_remark': financeRemark,
      'department_party_remark': departmentPartyRemark,
      'created_by': createdBy,
      'refund_by': refundBy,
      'refund_at': refundAt?.toIso8601String(),
      'edit_by': editBy,
      'edit_at': editAt?.toIso8601String(),
      'edit_status': editStatus,
      'bill_status': billStatus,
      'approved_by': approvedBy,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'is_delete': isDelete,
      'patient_name': patientName,
      'created_by_name': createdByName,
      'approval_remark': approvalRemark
    };
  }
}
