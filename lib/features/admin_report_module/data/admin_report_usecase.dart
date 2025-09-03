import 'package:jnm_hospital_app/core/network/apiHelper/resource.dart';

abstract class AdminReportUsecase {
  Future<Resource> opdPatientReportData(
      {required Map<String, dynamic> requestData});

  Future<Resource> getFilterData({required Map<String, dynamic> requestData});

  Future<Resource> emgPatientReportData(
      {required Map<String, dynamic> requestData});

  Future<Resource> billingReportData(
      {required Map<String, dynamic> requestData});

  Future<Resource> birthReportData({required Map<String, dynamic> requestData});

  Future<Resource> deathReportData({required Map<String, dynamic> requestData});
  Future<Resource> dischargeReportData({required Map<String, dynamic> requestData});
  Future<Resource> ipdReportData({required Map<String, dynamic> requestData});
  Future<Resource> dialysisReportData({required Map<String, dynamic> requestData});
  Future<Resource> getFilteredDataForIpd({required Map<String, dynamic> requestData});
  Future<Resource> getFilteredDataForBillingReport({required Map<String, dynamic> requestData});
  Future<Resource> getBillingDetails({required String deptId, required int billId});
  Future<Resource> getCollectionReportDetails({required Map<String, dynamic> requestData});
  Future<Resource> getUserWiseCollectionReportDetails({required Map<String, dynamic> requestData});
  Future<Resource> getDoctorPayoutDetails({required Map<String, dynamic> requestData});
  Future<Resource> getDoctorPayoutDetailsData({required Map<String, dynamic> requestData, required String id, required String date});

}
