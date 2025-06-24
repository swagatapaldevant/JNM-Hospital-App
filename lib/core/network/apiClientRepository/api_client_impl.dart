import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/locator.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/resource.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/status.dart';
import 'package:jnm_hospital_app/core/network/networkRepository/network_client.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_string.dart';
import 'package:jnm_hospital_app/core/utils/helper/common_utils.dart';

import 'api_client.dart';


class ApiClientImpl extends ApiClient {
  final NetworkClient _networkClient = getIt<NetworkClient>();
  @override
  String handleDioError(DioException e) {
    var msg = "";
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        break;
      case DioExceptionType.receiveTimeout:
        break;
      case DioExceptionType.unknown:
        if (e.message!.contains('SocketException')) {
          msg = AppStrings.checkInternet;
        } else {
          msg = AppStrings.somethingWentWrong;
        }
        break;
      default:
        msg = AppStrings.somethingWentWrong;
        break;
    }
    return msg;
  }

  @override
  Future<Resource> getRequest(
      {required String url,
        bool showLoadingState = false,
        Map<String, dynamic>? requestData,
        Map<String, String>? header}) async {
    try {
      CommonUtils().loadingState(isLoading: showLoadingState);

      var response = await Dio().get(url,
          queryParameters: requestData, options: Options(headers: header));
      CommonUtils().loadingState(isLoading: false);

      return Resource(
          status: response.data['status'] == "success" ? STATUS.SUCCESS : STATUS.ERROR,
          data: response.data['data'],
          message: response.data['msg']);
    } on DioException catch (e) {
      CommonUtils().loadingState(isLoading: false);

      if (e.response != null && e.response!.data != null) {
        Map<String,dynamic> responses = e.response?.data ?? {};
        return Resource(status: STATUS.ERROR, message: responses['msg'] ?? _networkClient.getHttpErrorMessage(statusCode: e.response!.statusCode!));
      } else {
        return Resource(
            status: STATUS.ERROR, message: AppStrings.somethingWentWrong);
      }
    }
  }

  @override
  Future<Resource> postRequest(
      {required String url,
        required Map<String, dynamic> requestData,
        Map<String, String>? header}) async {
    try {
      CommonUtils().loadingState(isLoading: false);

      var response = await Dio()
          .post(url, data: jsonEncode(requestData), options: Options(headers: header));
      CommonUtils().loadingState(isLoading: false);

      return Resource(
          status: response.data['status']== "success" ? STATUS.SUCCESS : STATUS.ERROR,
          data: response.data['data'],
          message: response.data['msg']);
    } on DioException catch (e) {
      CommonUtils().loadingState(isLoading: false);
      if (e.response != null) {
        Map<String,dynamic> responses = e.response?.data ?? {};
        return Resource(status: STATUS.ERROR, message: responses['msg'] ?? _networkClient.getHttpErrorMessage(statusCode: e.response!.statusCode!));
      } else {
        return Resource(
            status: STATUS.ERROR, message: AppStrings.somethingWentWrong);
      }
    }
  }

  @override
  Future<Resource> postRequestMultiData({required String url, required FormData requestData, Map<String, String>? header}) async {
    try {
      CommonUtils().loadingState(isLoading: false);

      var response = await Dio()
          .post(url, data: requestData, options: Options(headers: header));
      CommonUtils().loadingState(isLoading: false);
      ///////////////////////////////////////
      print("*********** Request ********") ;
      print(requestData.toString());
      print("*********** Response ********") ;
      print( Resource(
          status: response.data['success'] ? STATUS.SUCCESS : STATUS.ERROR,
          data: response.data['data'],
          message: response.data['message']).toString());
      print("*********** End ********") ;
      ///////////////////////////////////
      return Resource(
          status: response.data['success'] ? STATUS.SUCCESS : STATUS.ERROR,
          data: response.data['data'],
          message: response.data['message']);
    } on DioException catch (e) {
      CommonUtils().loadingState(isLoading: false);
      if (e.response != null) {
        print("*********** Request ********") ;
        print(requestData.toString());
        print("*********** Response ********") ;

        print("*********** End ********") ;
        Map<String,dynamic> responses = e.response?.data ?? {};
        return Resource(status: STATUS.ERROR, message: responses['message'] ?? _networkClient.getHttpErrorMessage(statusCode: e.response!.statusCode!));
      } else {
        return Resource(
            status: STATUS.ERROR, message: AppStrings.somethingWentWrong);
      }
    }
  }

  @override
  Future<Resource> deleteRequest({required String url, Map<String, dynamic>? requestData, Map<String, String>? header}) async {
    try {
      CommonUtils().loadingState(isLoading: false);
      var response = await Dio().delete(
        url,
        data: requestData,
        options: Options(headers: header),
      );

      CommonUtils().loadingState(isLoading: false);

      return Resource(
        status: response.data['success'] ? STATUS.SUCCESS : STATUS.ERROR,
        data: response.data['data'],
        message: response.data['message'],
      );
    } on DioException catch (e) {
      CommonUtils().loadingState(isLoading: false);

      if (e.response != null) {
        Map<String, dynamic> responseData = e.response?.data ?? {};
        return Resource(
          status: STATUS.ERROR,
          message: responseData['message'] ??
              _networkClient.getHttpErrorMessage(
                  statusCode: e.response!.statusCode!),
        );
      } else {
        return Resource(
          status: STATUS.ERROR,
          message: AppStrings.somethingWentWrong,
        );
      }
    }
  }

}