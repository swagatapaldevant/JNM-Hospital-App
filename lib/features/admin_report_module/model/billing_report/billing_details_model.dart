class BillingDetailsModel {
    BillingDetailsModel({
        required this.bill,
        required this.billInfo,
        required this.payments,
        required this.refund,
        required this.reused,
        required this.section,
    });

    final Bill? bill;
    final List<BillInfo> billInfo;
    final List<Payment> payments;
    final List<dynamic> refund; /**TODO: Refund model */
    final List<dynamic> reused; /**TODO: Reused model */
    final String? section;

    factory BillingDetailsModel.fromJson(Map<String, dynamic> json){ 
        return BillingDetailsModel(
            bill: json["bill"] == null ? null : Bill.fromJson(json["bill"]),
            billInfo: json["bill_info"] == null ? [] : List<BillInfo>.from(json["bill_info"]!.map((x) => BillInfo.fromJson(x))),
            payments: json["payments"] == null ? [] : List<Payment>.from(json["payments"]!.map((x) => Payment.fromJson(x))),
            refund: json["refund"] == null ? [] : List<dynamic>.from(json["refund"]!.map((x) => x)),
            reused: json["reused"] == null ? [] : List<dynamic>.from(json["reused"]!.map((x) => x)),
            section: json["section"],
        );
    }

    Map<String, dynamic> toJson() => {
        "bill": bill?.toJson(),
        "bill_info": billInfo.map((x) => x?.toJson()).toList(),
        "payments": payments.map((x) => x?.toJson()).toList(),
        "refund": refund.map((x) => x).toList(),
        "reused": reused.map((x) => x).toList(),
        "section": section,
    };

}

class Bill {
    Bill({
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
        required this.enquiryId,
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
    final int? enquiryId;

    factory Bill.fromJson(Map<String, dynamic> json){ 
        return Bill(
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
            enquiryId: json["enquiry_id"],
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
        "enquiry_id": enquiryId,
    };

}

class BillInfo {
    BillInfo({
        required this.id,
        required this.billingId,
        required this.chargeCategoryId,
        required this.chargeSubCategoryId,
        required this.date,
        required this.chargeId,
        required this.chargeName,
        required this.doctorId,
        required this.standardCharges,
        required this.commisionAmount,
        required this.discountPercentage,
        required this.discountAmount,
        required this.qty,
        required this.amount,
        required this.isDelete,
        required this.createdAt,
        required this.updatedAt,
        required this.doctorName,
        required this.actualChargeName,
    });

    final int? id;
    final int? billingId;
    final int? chargeCategoryId;
    final int? chargeSubCategoryId;
    final DateTime? date;
    final int? chargeId;
    final String? chargeName;
    final dynamic doctorId;
    final int? standardCharges;
    final int? commisionAmount;
    final int? discountPercentage;
    final int? discountAmount;
    final int? qty;
    final int? amount;
    final int? isDelete;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final dynamic doctorName;
    final String? actualChargeName;

    factory BillInfo.fromJson(Map<String, dynamic> json){ 
        return BillInfo(
            id: json["id"],
            billingId: json["billing_id"],
            chargeCategoryId: json["charge_category_id"],
            chargeSubCategoryId: json["charge_sub_category_id"],
            date: DateTime.tryParse(json["date"] ?? ""),
            chargeId: json["charge_id"],
            chargeName: json["charge_name"],
            doctorId: json["doctor_id"],
            standardCharges: json["standard_charges"],
            commisionAmount: json["commision_amount"],
            discountPercentage: json["discount_percentage"],
            discountAmount: json["discount_amount"],
            qty: json["qty"],
            amount: json["amount"],
            isDelete: json["is_delete"],
            createdAt: DateTime.tryParse(json["created_at"] ?? ""),
            updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
            doctorName: json["doctor_name"],
            actualChargeName: json["actual_charge_name"],
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "billing_id": billingId,
        "charge_category_id": chargeCategoryId,
        "charge_sub_category_id": chargeSubCategoryId,
        "date": date?.toIso8601String(),
        "charge_id": chargeId,
        "charge_name": chargeName,
        "doctor_id": doctorId,
        "standard_charges": standardCharges,
        "commision_amount": commisionAmount,
        "discount_percentage": discountPercentage,
        "discount_amount": discountAmount,
        "qty": qty,
        "amount": amount,
        "is_delete": isDelete,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "doctor_name": doctorName,
        "actual_charge_name": actualChargeName,
    };

}

class Payment {
    Payment({
        required this.id,
        required this.billingId,
        required this.patientId,
        required this.section,
        required this.sectionId,
        required this.paymentAmount,
        required this.paymentMode,
        required this.paymentBank,
        required this.paymentRecivedBy,
        required this.paymentDate,
        required this.note,
        required this.createdAt,
        required this.updatedAt,
        required this.createdName,
    });

    final int? id;
    final int? billingId;
    final int? patientId;
    final String? section;
    final int? sectionId;
    final int? paymentAmount;
    final String? paymentMode;
    final dynamic paymentBank;
    final int? paymentRecivedBy;
    final DateTime? paymentDate;
    final dynamic note;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final String? createdName;

    factory Payment.fromJson(Map<String, dynamic> json){ 
        return Payment(
            id: json["id"],
            billingId: json["billing_id"],
            patientId: json["patient_id"],
            section: json["section"],
            sectionId: json["section_id"],
            paymentAmount: json["payment_amount"],
            paymentMode: json["payment_mode"],
            paymentBank: json["payment_bank"],
            paymentRecivedBy: json["payment_recived_by"],
            paymentDate: DateTime.tryParse(json["payment_date"] ?? ""),
            note: json["note"],
            createdAt: DateTime.tryParse(json["created_at"] ?? ""),
            updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
            createdName: json["created_name"],
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "billing_id": billingId,
        "patient_id": patientId,
        "section": section,
        "section_id": sectionId,
        "payment_amount": paymentAmount,
        "payment_mode": paymentMode,
        "payment_bank": paymentBank,
        "payment_recived_by": paymentRecivedBy,
        "payment_date": paymentDate?.toIso8601String(),
        "note": note,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "created_name": createdName,
    };

}

/*TODO: Refund and Reuse models*/