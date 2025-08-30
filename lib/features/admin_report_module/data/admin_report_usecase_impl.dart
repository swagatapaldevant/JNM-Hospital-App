import 'package:jnm_hospital_app/core/network/apiClientRepository/api_client.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/api_endpoint.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/locator.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/resource.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/status.dart';
import 'package:jnm_hospital_app/core/services/localStorage/shared_pref.dart';

import 'admin_report_usecase.dart';

class AdminReportUsecaseImplementation extends AdminReportUsecase {
  final ApiClient _apiClient = getIt<ApiClient>();
  final SharedPref _pref = getIt<SharedPref>();

  @override
  Future<Resource> opdPatientReportData(
      {required Map<String, dynamic> requestData}) async {
    String token = await _pref.getUserAuthToken();
    Map<String, String> header = {
      "Authorization": "Bearer $token"
    };
    print("Bearer$token");
    Resource resource = await _apiClient.postRequest(
        url: ApiEndPoint.opdPatientReport, header: header, requestData: requestData);
    if (resource.status == STATUS.SUCCESS) {
      return resource;
    } else {
      return resource;
    }
  }


  @override
  Future<Resource> getFilterData(
      {required Map<String, dynamic> requestData}) async {
    String token = await _pref.getUserAuthToken();
    Map<String, String> header = {
      "Authorization": "Bearer $token"
    };
    print("Bearer$token");
    Resource resource = await _apiClient.getRequest(
        url: ApiEndPoint.getFilterData, header: header, requestData: requestData);
    if (resource.status == STATUS.SUCCESS) {
      return resource;
    } else {
      return resource;
    }
  }


  @override
  Future<Resource> emgPatientReportData(
      {required Map<String, dynamic> requestData}) async {
    String token = await _pref.getUserAuthToken();
    Map<String, String> header = {
      "Authorization": "Bearer $token"
    };
    print("Bearer$token");
    Resource resource = await _apiClient.postRequest(
        url: ApiEndPoint.emgPatientReport, header: header, requestData: requestData);
    if (resource.status == STATUS.SUCCESS) {
      return resource;
    } else {
      return resource;
    }
  }


  @override
  Future<Resource> billingReportData(
      {required Map<String, dynamic> requestData}) async {
    String token = await _pref.getUserAuthToken();
    Map<String, String> header = {
      "Authorization": "Bearer $token"
    };
    print("Bearer$token");
    Resource resource = await _apiClient.postRequest(
        url: ApiEndPoint.billingReport, header: header, requestData: requestData);
    if (resource.status == STATUS.SUCCESS) {
      return resource;
    } else {
      return resource;
    }
  }

  @override
  Future<Resource> birthReportData(
      {required Map<String, dynamic> requestData}) async {
    String token = await _pref.getUserAuthToken();
    Map<String, String> header = {
      "Authorization": "Bearer $token"
    };
    print("Bearer$token");
    Resource resource = await _apiClient.postRequest(
        url: ApiEndPoint.birthReport, header: header, requestData: requestData);
    if (resource.status == STATUS.SUCCESS) {
      return resource;
    } else {
      return resource;
    }
  }

  @override
  Future<Resource> deathReportData(
      {required Map<String, dynamic> requestData}) async {
    String token = await _pref.getUserAuthToken();
    Map<String, String> header = {
      "Authorization": "Bearer $token"
    };
    print("Bearer$token");
    Resource resource = await _apiClient.postRequest(
        url: ApiEndPoint.deathReport, header: header, requestData: requestData);
    if (resource.status == STATUS.SUCCESS) {
      return resource;
    } else {
      return resource;
    }
  }


  @override
  Future<Resource> dischargeReportData(
      {required Map<String, dynamic> requestData}) async {
    String token = await _pref.getUserAuthToken();
    Map<String, String> header = {
      "Authorization": "Bearer $token"
    };
    print("Bearer$token");
    Resource resource = await _apiClient.postRequest(
        url: ApiEndPoint.dischargeReport, header: header, requestData: requestData);
    if (resource.status == STATUS.SUCCESS) {
      return resource;
    } else {
      return resource;
    }
  }


  @override
  Future<Resource> ipdReportData(
      {required Map<String, dynamic> requestData}) async {
    String token = await _pref.getUserAuthToken();
    Map<String, String> header = {
      "Authorization": "Bearer $token"
    };
    print("Bearer$token");
    Resource resource = await _apiClient.postRequest(
        url: ApiEndPoint.ipdReport, header: header, requestData: requestData);
    if (resource.status == STATUS.SUCCESS) {
      return resource;
    } else {
      return resource;
    }
  }


  @override
  Future<Resource> dialysisReportData(
      {required Map<String, dynamic> requestData}) async {
    String token = await _pref.getUserAuthToken();
    Map<String, String> header = {
      "Authorization": "Bearer $token"
    };
    print("Bearer$token");
    Resource resource = await _apiClient.postRequest(
        url: ApiEndPoint.dialysisReport, header: header, requestData: requestData);
    if (resource.status == STATUS.SUCCESS) {
      return resource;
    } else {
      return resource;
    }
  }

  @override
  Future<Resource> getFilteredDataForIpd(
      {required Map<String, dynamic> requestData}) async {
    String token = await _pref.getUserAuthToken();
    Map<String, String> header = {
      "Authorization": "Bearer $token"
    };
    print("Bearer$token");
    Resource resource = await _apiClient.getRequest(
        url: ApiEndPoint.filteredReportIpd, header: header, requestData: requestData);
    if (resource.status == STATUS.SUCCESS) {
      return resource;
    } else {
      return resource;
    }
  }


  @override
  Future<Resource> getFilteredDataForBillingReport(
      {required Map<String, dynamic> requestData}) async {
    String token = await _pref.getUserAuthToken();
    Map<String, String> header = {
      "Authorization": "Bearer $token"
    };
    print("Bearer$token");
    Resource resource = await _apiClient.getRequest(
        url: ApiEndPoint.billingFilterData, header: header, requestData: requestData);
    if (resource.status == STATUS.SUCCESS) {
      return resource;
    } else {
      return resource;
    }
  }

  @override
  Future<Resource> getBillingDetails({required String deptId, required int billId}) async {
    String token = await _pref.getUserAuthToken();
    Map<String, String> header = {
      "Authorization": "Bearer $token"
    };
    print("Bearer$token");
    Resource resource = await _apiClient.getRequest(
        url: '${ApiEndPoint.billingDetails}/$deptId/$billId', 
        header: header);
    if (resource.status == STATUS.SUCCESS) {
      return resource;
    } else {
      return resource;
    }
  }


}