class PatientDetailsResponse {
    PatientDetailsResponse({
        required this.billDetails,
        required this.patientDetails,
        required this.opdDetails,
        required this.totalCredit,
        required this.totalDue,
        required this.opdEnquiry,
        required this.emgDetails,
        required this.ipdDetails,
        required this.daycareDetails,
        required this.receiptDetails,
        required this.refundDetails,
        required this.noteDetails,
        required this.emrDetails,
    });

    final List<BillDetail> billDetails;
    final PatientDetails? patientDetails;
    final List<dynamic> opdDetails;
    final int? totalCredit;
    final int? totalDue;
    final List<dynamic> opdEnquiry;
    final List<dynamic> emgDetails;
    final List<dynamic> ipdDetails;
    final List<dynamic> daycareDetails;
    final List<ReceiptDetail> receiptDetails;
    final List<dynamic> refundDetails;
    final List<dynamic> noteDetails;
    final List<dynamic> emrDetails;

    factory PatientDetailsResponse.fromJson(Map<String, dynamic> json){ 
        return PatientDetailsResponse(
            billDetails: json["bill_details"] == null ? [] : List<BillDetail>.from(json["bill_details"]!.map((x) => BillDetail.fromJson(x))),
            patientDetails: json["patient_details"] == null ? null : PatientDetails.fromJson(json["patient_details"]),
            opdDetails: json["opd_details"] == null ? [] : List<dynamic>.from(json["opd_details"]!.map((x) => x)),
            totalCredit: json["totalCredit"],
            totalDue: json["totalDue"],
            opdEnquiry: json["opd_enquiry"] == null ? [] : List<dynamic>.from(json["opd_enquiry"]!.map((x) => x)),
            emgDetails: json["emg_details"] == null ? [] : List<dynamic>.from(json["emg_details"]!.map((x) => x)),
            ipdDetails: json["ipd_details"] == null ? [] : List<dynamic>.from(json["ipd_details"]!.map((x) => x)),
            daycareDetails: json["daycare_details"] == null ? [] : List<dynamic>.from(json["daycare_details"]!.map((x) => x)),
            receiptDetails: json["receipt_details"] == null ? [] : List<ReceiptDetail>.from(json["receipt_details"]!.map((x) => ReceiptDetail.fromJson(x))),
            refundDetails: json["refund_details"] == null ? [] : List<dynamic>.from(json["refund_details"]!.map((x) => x)),
            noteDetails: json["note_details"] == null ? [] : List<dynamic>.from(json["note_details"]!.map((x) => x)),
            emrDetails: json["emr_details"] == null ? [] : List<dynamic>.from(json["emr_details"]!.map((x) => x)),
        );
    }

    Map<String, dynamic> toJson() => {
        "bill_details": billDetails.map((x) => x?.toJson()).toList(),
        "patient_details": patientDetails?.toJson(),
        "opd_details": opdDetails.map((x) => x).toList(),
        "totalCredit": totalCredit,
        "totalDue": totalDue,
        "opd_enquiry": opdEnquiry.map((x) => x).toList(),
        "emg_details": emgDetails.map((x) => x).toList(),
        "ipd_details": ipdDetails.map((x) => x).toList(),
        "daycare_details": daycareDetails.map((x) => x).toList(),
        "receipt_details": receiptDetails.map((x) => x?.toJson()).toList(),
        "refund_details": refundDetails.map((x) => x).toList(),
        "note_details": noteDetails.map((x) => x).toList(),
        "emr_details": emrDetails.map((x) => x).toList(),
    };

}

class BillDetail {
    BillDetail({
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
        required this.createdAt,
        required this.updatedAt,
        required this.isDelete,
    });

    final int? id;
    final String? uid;
    final String? section;
    final int? sectionId;
    final DateTime? billDate;
    final int? patientId;
    final int? doctorId;
    final dynamic referredBy;
    final dynamic marketBy;
    final dynamic provider;
    final dynamic caseId;
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
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final int? isDelete;

    factory BillDetail.fromJson(Map<String, dynamic> json){ 
        return BillDetail(
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
            createdAt: DateTime.tryParse(json["created_at"] ?? ""),
            updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
            isDelete: json["is_delete"],
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
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "is_delete": isDelete,
    };

}

class PatientDetails {
    PatientDetails({
        required this.id,
        required this.name,
        required this.guardianName,
        required this.guardianContactNo,
        required this.guardianRealation,
        required this.maritalStatus,
        required this.bloodGroup,
        required this.gender,
        required this.dateOfBirth,
        required this.dobYear,
        required this.dobMonth,
        required this.dobDay,
        required this.phone,
        required this.alternativeNo,
        required this.email,
        required this.address,
        required this.district,
        required this.state,
        required this.country,
        required this.pinCode,
        required this.identificationName,
        required this.identificationNumber,
        required this.remarks,
        required this.isActive,
        required this.isDelete,
        required this.createdBy,
        required this.createdAt,
        required this.updatedAt,
    });

    final int? id;
    final String? name;
    final dynamic guardianName;
    final dynamic guardianContactNo;
    final dynamic guardianRealation;
    final dynamic maritalStatus;
    final dynamic bloodGroup;
    final String? gender;
    final dynamic dateOfBirth;
    final int? dobYear;
    final int? dobMonth;
    final int? dobDay;
    final String? phone;
    final dynamic alternativeNo;
    final dynamic email;
    final String? address;
    final dynamic district;
    final String? state;
    final String? country;
    final dynamic pinCode;
    final dynamic identificationName;
    final dynamic identificationNumber;
    final dynamic remarks;
    final bool? isActive;
    final bool? isDelete;
    final dynamic createdBy;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    factory PatientDetails.fromJson(Map<String, dynamic> json){ 
        return PatientDetails(
            id: json["id"],
            name: json["name"],
            guardianName: json["guardian_name"],
            guardianContactNo: json["guardian_contact_no"],
            guardianRealation: json["guardian_realation"],
            maritalStatus: json["marital_status"],
            bloodGroup: json["blood_group"],
            gender: json["gender"],
            dateOfBirth: json["date_of_birth"],
            dobYear: json["dob_year"],
            dobMonth: json["dob_month"],
            dobDay: json["dob_day"],
            phone: json["phone"],
            alternativeNo: json["alternative_no"],
            email: json["email"],
            address: json["address"],
            district: json["district"],
            state: json["state"],
            country: json["country"],
            pinCode: json["pin_code"],
            identificationName: json["identification_name"],
            identificationNumber: json["identification_number"],
            remarks: json["remarks"],
            isActive: json["is_active"],
            isDelete: json["is_delete"],
            createdBy: json["created_by"],
            createdAt: DateTime.tryParse(json["created_at"] ?? ""),
            updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "guardian_name": guardianName,
        "guardian_contact_no": guardianContactNo,
        "guardian_realation": guardianRealation,
        "marital_status": maritalStatus,
        "blood_group": bloodGroup,
        "gender": gender,
        "date_of_birth": dateOfBirth,
        "dob_year": dobYear,
        "dob_month": dobMonth,
        "dob_day": dobDay,
        "phone": phone,
        "alternative_no": alternativeNo,
        "email": email,
        "address": address,
        "district": district,
        "state": state,
        "country": country,
        "pin_code": pinCode,
        "identification_name": identificationName,
        "identification_number": identificationNumber,
        "remarks": remarks,
        "is_active": isActive,
        "is_delete": isDelete,
        "created_by": createdBy,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };

}

class ReceiptDetail {
    ReceiptDetail({
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
        required this.paymentRecivedByName,
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
    final String? paymentRecivedByName;

    factory ReceiptDetail.fromJson(Map<String, dynamic> json){ 
        return ReceiptDetail(
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
            paymentRecivedByName: json["payment_recived_by_name"],
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
        "payment_recived_by_name": paymentRecivedByName,
    };

}
