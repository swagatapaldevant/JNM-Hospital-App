import 'package:jnm_hospital_app/core/network/apiHelper/resource.dart';


abstract class PatientOPDUsecases {

  Future<Resource> getOPDDepartments();
  Future<Resource> getOPDDoctors(int selectDeptId);
}
