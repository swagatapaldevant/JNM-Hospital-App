class DeptDoctorModel {
    DeptDoctorModel({
        required this.id,
        required this.empId,
        required this.roleId,
        required this.salutation,
        required this.name,
        required this.email,
        required this.phoneNo,
        required this.fatherName,
        required this.motherName,
        required this.gender,
        required this.maritalStatus,
        required this.bloodGroup,
        required this.dob,
        required this.joiningDate,
        required this.whatsappNo,
        required this.emgNo,
        required this.profileImg,
        required this.currentAddress,
        required this.permanentAddress,
        required this.qualification,
        required this.experience,
        required this.specialization,
        required this.note,
        required this.panNumber,
        required this.identificationName,
        required this.identificationNumber,
        required this.signature,
        required this.departmentId,
        required this.categoryId,
        required this.subCategoryId,
        required this.doctorType,
        required this.doctorFees,
        required this.chargeId,
        required this.commissionType,
        required this.commissionAmount,
        required this.salaryMasterId,
        required this.basicSalary,
        required this.userType,
        required this.isActive,
        required this.isDelete,
        required this.createdAt,
        required this.updatedAt,
    });

    final int? id;
    final String? empId;
    final int? roleId;
    final String? salutation;
    final String? name;
    final dynamic email;
    final String? phoneNo;
    final dynamic fatherName;
    final dynamic motherName;
    final String? gender;
    final dynamic maritalStatus;
    final dynamic bloodGroup;
    final dynamic dob;
    final dynamic joiningDate;
    final dynamic whatsappNo;
    final dynamic emgNo;
    final dynamic profileImg;
    final String? currentAddress;
    final dynamic permanentAddress;
    final String? qualification;
    final String? experience;
    final String? specialization;
    final dynamic note;
    final dynamic panNumber;
    final dynamic identificationName;
    final dynamic identificationNumber;
    final String? signature;
    final int? departmentId;
    final int? categoryId;
    final int? subCategoryId;
    final String? doctorType;
    final String? doctorFees;
    final int? chargeId;
    final String? commissionType;
    final String? commissionAmount;
    final dynamic salaryMasterId;
    final String? basicSalary;
    final String? userType;
    final int? isActive;
    final int? isDelete;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    factory DeptDoctorModel.fromJson(Map<String, dynamic> json){ 
        return DeptDoctorModel(
            id: json["id"],
            empId: json["empId"],
            roleId: json["role_id"],
            salutation: json["salutation"],
            name: json["name"],
            email: json["email"],
            phoneNo: json["phone_no"],
            fatherName: json["father_name"],
            motherName: json["mother_name"],
            gender: json["gender"],
            maritalStatus: json["marital_status"],
            bloodGroup: json["blood_group"],
            dob: json["dob"],
            joiningDate: json["joining_date"],
            whatsappNo: json["whatsapp_no"],
            emgNo: json["emg_no"],
            profileImg: json["profile_img"],
            currentAddress: json["current_address"],
            permanentAddress: json["permanent_address"],
            qualification: json["qualification"],
            experience: json["experience"],
            specialization: json["specialization"],
            note: json["note"],
            panNumber: json["pan_number"],
            identificationName: json["identification_name"],
            identificationNumber: json["identification_number"],
            signature: json["signature"],
            departmentId: json["department_id"],
            categoryId: json["category_id"],
            subCategoryId: json["sub_category_id"],
            doctorType: json["doctor_type"],
            doctorFees: json["doctor_fees"],
            chargeId: json["charge_id"],
            commissionType: json["commission_type"],
            commissionAmount: json["commission_amount"],
            salaryMasterId: json["salary_master_id"],
            basicSalary: json["basic_salary"],
            userType: json["user_type"],
            isActive: json["is_active"],
            isDelete: json["is_delete"],
            createdAt: DateTime.tryParse(json["created_at"] ?? ""),
            updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "empId": empId,
        "role_id": roleId,
        "salutation": salutation,
        "name": name,
        "email": email,
        "phone_no": phoneNo,
        "father_name": fatherName,
        "mother_name": motherName,
        "gender": gender,
        "marital_status": maritalStatus,
        "blood_group": bloodGroup,
        "dob": dob,
        "joining_date": joiningDate,
        "whatsapp_no": whatsappNo,
        "emg_no": emgNo,
        "profile_img": profileImg,
        "current_address": currentAddress,
        "permanent_address": permanentAddress,
        "qualification": qualification,
        "experience": experience,
        "specialization": specialization,
        "note": note,
        "pan_number": panNumber,
        "identification_name": identificationName,
        "identification_number": identificationNumber,
        "signature": signature,
        "department_id": departmentId,
        "category_id": categoryId,
        "sub_category_id": subCategoryId,
        "doctor_type": doctorType,
        "doctor_fees": doctorFees,
        "charge_id": chargeId,
        "commission_type": commissionType,
        "commission_amount": commissionAmount,
        "salary_master_id": salaryMasterId,
        "basic_salary": basicSalary,
        "user_type": userType,
        "is_active": isActive,
        "is_delete": isDelete,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };

}
