import 'package:jnm_hospital_app/core/network/apiHelper/resource.dart';
import 'package:jnm_hospital_app/features/approval_system_module/model/approval_system_model.dart';

abstract class ApprovedListUseCases {
  Future<Resource> fetchApprovedList(String url);
}