
class ApiEndPoint{

  static final ApiEndPoint _instance = ApiEndPoint._internal();

  factory ApiEndPoint(){
    return _instance;
  }

  ApiEndPoint._internal();

  //static const baseurl = "http://192.168.29.243:8001/api";
  //static const baseurl = "https://devanthims.in/rainbow/api";
  // static const baseurl = "https://devanttest.in/kgh-demo/api";
   static const baseurl = "https://devanttest.in/kgh-demo/api";
 // static const baseurl = "https://jmnmedicalcollege.com/api";

  // auth api
  static const login =  "$baseurl/login";

  // admin report

  static const opdPatientReport =  "$baseurl/opd-billing-reports";
  static const getFilterData =  "$baseurl/get-filteration-report";
  static const emgPatientReport =  "$baseurl/emg-report";
  static const billingReport =  "$baseurl/billing-reports";
  static const birthReport =  "$baseurl/birth-report";
  static const deathReport =  "$baseurl/death-report";
  static const dischargeReport =  "$baseurl/discharge-report";
  static const ipdReport =  "$baseurl/ipd-report";
  static const dialysisReport =  "$baseurl/dialysis-report";
  static const filteredReportIpd =  "$baseurl/get-filteration-ipd-report";
  static const billingFilterData =  "$baseurl/get-filteration-data";
  static const dashboard =  "$baseurl/dashboard";







}