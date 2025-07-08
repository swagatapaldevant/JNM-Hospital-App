
class ApiEndPoint{

  static final ApiEndPoint _instance = ApiEndPoint._internal();

  factory ApiEndPoint(){
    return _instance;
  }

  ApiEndPoint._internal();

  //static const baseurl = "http://192.168.29.243:8001/api";
  static const baseurl = "https://devanthims.in/rainbow/api";

  // admin report

  static const opdPatientReport =  "$baseurl/opd-billing-reports";







}