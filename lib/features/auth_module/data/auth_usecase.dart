import 'package:jnm_hospital_app/core/network/apiHelper/resource.dart';

abstract class AuthUsecase {
  Future<Resource> login(
      {required Map<String, dynamic> requestData});


}
