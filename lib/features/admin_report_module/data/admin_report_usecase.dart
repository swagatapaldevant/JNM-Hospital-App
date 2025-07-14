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

}
