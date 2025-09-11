import 'package:jnm_hospital_app/core/network/apiHelper/resource.dart';

abstract class ApprovalUsecases {
  Future<Resource> getApprovalData(String url, int requestData);
  Future<Resource> approveData(String url, int billId, Map<String, dynamic> requestData);
}
