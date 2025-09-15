import 'package:jnm_hospital_app/core/network/apiClientRepository/api_client.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/api_endpoint.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/locator.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/resource.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/status.dart';
import 'package:jnm_hospital_app/core/services/localStorage/shared_pref.dart';
import 'package:jnm_hospital_app/features/patient_module/patient_bills/data/patient_bills_usecases.dart';

class PatientBillsUsecasesImpl implements PatientBillsUsecases {
  @override
  Future<Resource> getPatientBills(Map<String, String> requestData) async {
    final ApiClient apiClient = getIt<ApiClient>();
    final SharedPref pref = getIt<SharedPref>();
     String token = await pref.getUserAuthToken();
    
    Resource resource = await apiClient.postRequest(
      url: ApiEndPoint.getpatientBills,
      header: {
        "Authorization": "Bearer $token"
      },
      requestData: requestData
    );
    if (resource.status == STATUS.SUCCESS) {
      return resource;
    } else {
      return resource;
    }
  }
}