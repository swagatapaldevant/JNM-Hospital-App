import 'package:jnm_hospital_app/core/network/apiClientRepository/api_client.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/api_endpoint.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/locator.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/resource.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/status.dart';
import 'package:jnm_hospital_app/core/services/localStorage/shared_pref.dart';
import 'package:jnm_hospital_app/features/patient_module/investigation/data/investigation_usecases.dart';
import 'package:jnm_hospital_app/features/patient_module/model/investigation_report/investigation_report_model.dart';

class InvestigationUsecasesImpl implements InvestigationUsecases {
  @override
  Future<Resource> getInvestigationReport(InvestigationReportModel reportFilter) async {
    final ApiClient _apiClient = getIt<ApiClient>();
    final SharedPref _pref = getIt<SharedPref>();

    String token = await _pref.getUserAuthToken();
    Map<String, String> header = {"Authorization": "Bearer $token"};
    // print("Bearer$token");
    Resource resource = await _apiClient.postRequest(
        url: ApiEndPoint.getInvestigationReport,
        header: header,
        requestData: {"from_date": "2025-08-01", "to_date": "2025-08-31"});
    if (resource.status == STATUS.SUCCESS) {
      return resource;
    } else {
      return resource;
    }
  }
}
