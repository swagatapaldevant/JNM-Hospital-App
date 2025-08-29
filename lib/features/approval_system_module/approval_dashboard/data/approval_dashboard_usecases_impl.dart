import 'package:jnm_hospital_app/core/network/apiClientRepository/api_client.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/api_endpoint.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/locator.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/resource.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/status.dart';
import 'package:jnm_hospital_app/core/services/localStorage/shared_pref.dart';
import 'package:jnm_hospital_app/features/approval_system_module/approval_dashboard/data/approval_dashboard_usecases.dart';

class ApprovalDashboardUseCasesImpl implements ApprovalDashboardUseCases {
  @override
  Future<Resource> getPendingCount() async {
    final ApiClient _apiClient = getIt<ApiClient>();
    final SharedPref _pref = getIt<SharedPref>();
    
    Resource resource = await _apiClient.getRequest(
      url: ApiEndPoint.approvalDeptWiseCount,
      header: {},

    );
    if (resource.status == STATUS.SUCCESS) {
      return resource;
    } else {
      return resource;
    }
  }

}
