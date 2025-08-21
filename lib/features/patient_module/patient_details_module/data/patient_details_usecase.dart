import 'package:jnm_hospital_app/core/network/apiHelper/resource.dart';

abstract class PatientDetailsUsecase {
  Future<Resource> getPatientDetails();


}