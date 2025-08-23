import 'package:jnm_hospital_app/core/network/apiHelper/resource.dart';


abstract class PatientOPDUsecases {

  Future<Resource> getOPDDepartments();
  Future<Resource> getOPDDoctors(int selectDeptId);
  Future<Resource> getOPDSchedule(int doctorId);
  Future<Resource> getOPDTimeslot(int doctorId, DateTime date);
}
