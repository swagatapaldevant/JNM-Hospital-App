import 'package:jnm_hospital_app/core/network/apiHelper/resource.dart';
import 'package:jnm_hospital_app/features/approval_system_module/model/pagination.dart';

abstract class ApprovalUsecases {
  Future<Resource> getApprovalData(String url, PaginationModel requestData);
 // Future<Resource> approveData(String url, PaginationModel requestData);
}
