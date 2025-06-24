import 'package:dio/dio.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/resource.dart';

abstract class ApiClient {
  Future<Resource> postRequest(
      {required String url, required Map<String, dynamic> requestData, Map<String, String>? header});
  Future<Resource> postRequestMultiData(
      {required String url, required FormData requestData, Map<String, String>? header});
  Future<Resource> getRequest({required String url, Map<String, dynamic>? requestData, Map<String, String>? header});

  Future<Resource> deleteRequest({required String url, Map<String, dynamic>? requestData, Map<String, String>? header});



  String handleDioError(DioException e);
}