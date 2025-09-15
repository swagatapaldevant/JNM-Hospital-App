import 'package:jnm_hospital_app/core/network/apiHelper/resource.dart';

abstract class PatientBillsUsecases {
  Future<Resource> getPatientBills(Map<String, String> requestData);
  
}
