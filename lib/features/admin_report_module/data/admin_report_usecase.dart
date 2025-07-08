
import 'package:jnm_hospital_app/core/network/apiHelper/resource.dart';

abstract class AdminReportUsecase{

  Future<Resource> opdPatientReportData({required Map<String, dynamic> requestData});


}