import 'package:jnm_hospital_app/core/network/apiClientRepository/api_client.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/api_endpoint.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/locator.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/resource.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/status.dart';
import 'package:jnm_hospital_app/core/services/localStorage/shared_pref.dart';
import 'package:jnm_hospital_app/features/patient_module/investigation/data/investigation_usecases.dart';
 
class InvestigationUsecasesImpl implements InvestigationUsecases {
  @override
  Future<Resource> getInvestigationReport(Map<String, dynamic> reportFilter) async {
    final ApiClient _apiClient = getIt<ApiClient>();
    final SharedPref _pref = getIt<SharedPref>();

    String token = await _pref.getUserAuthToken();
    Map<String, String> header = {"Authorization": "Bearer $token"};
    // print("Bearer$token");
    Resource resource = await _apiClient.postRequest(
        url: ApiEndPoint.getInvestigationReport,
        header: header,
        requestData: reportFilter);
    if (resource.status == STATUS.SUCCESS) {
      return resource;
    } else {
      return resource;
    }
  }
}
