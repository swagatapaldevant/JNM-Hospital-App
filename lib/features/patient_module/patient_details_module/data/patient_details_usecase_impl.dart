import 'package:jnm_hospital_app/core/network/apiClientRepository/api_client.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/api_endpoint.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/locator.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/resource.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/status.dart';
import 'package:jnm_hospital_app/core/services/localStorage/shared_pref.dart';
import 'package:jnm_hospital_app/features/patient_module/patient_details_module/data/patient_details_usecase.dart';

class PatientDetailsUsecaseImpl extends PatientDetailsUsecase {
  final ApiClient _apiClient = getIt<ApiClient>();
  final SharedPref _pref = getIt<SharedPref>();

  @override
  Future<Resource> getPatientDetails() async {
    String token = await _pref.getUserAuthToken();
    
    Map<String, String> header = {
      "Authorization": "Bearer $token"
    };
    
    // print("Bearer$token");
    Resource resource = await _apiClient.getRequest(
        url: ApiEndPoint.patientDetails,
        header: header,);
    if (resource.status == STATUS.SUCCESS) {
      return resource;
    } else {
      return resource;
    }
  }
}