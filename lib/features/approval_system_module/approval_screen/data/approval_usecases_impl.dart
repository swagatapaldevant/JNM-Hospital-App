import 'package:jnm_hospital_app/core/network/apiClientRepository/api_client.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/api_endpoint.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/locator.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/resource.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/status.dart';
import 'package:jnm_hospital_app/core/services/localStorage/shared_pref.dart';
import 'package:jnm_hospital_app/features/approval_system_module/model/pagination.dart';
import 'package:jnm_hospital_app/features/approval_system_module/approval_screen/data/approval_usecases.dart';

class ApprovalUsecasesImpl implements ApprovalUsecases {
  @override
  Future<Resource> getApprovalData(String url, PaginationModel requestData) async {
    final ApiClient _apiClient = getIt<ApiClient>();
    final SharedPref _pref = getIt<SharedPref>();
    
    Resource resource = await _apiClient.postRequest(
      url: url,
      header: {},
      requestData: requestData.toJson()
    );
    if (resource.status == STATUS.SUCCESS) {
      return resource;
    } else {
      return resource;
    }
  }

}