
class ApiEndPoint{

  static final ApiEndPoint _instance = ApiEndPoint._internal();

  factory ApiEndPoint(){
    return _instance;
  }

  ApiEndPoint._internal();

  //static const baseurl = "http://192.168.29.243:8001/api";
  static const baseurl = "https://devanthims.in/rainbow/api";
  // static const baseurl = "https://devanttest.in/kgh-demo/api";
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
  static const collectionReport =  "$baseurl/collection-report";
  static const userWiseCollectionReport =  "$baseurl/users-collection";
  static const doctorPayoutReport =  "$baseurl/doctor-payout";
  static const doctorPayoutDetails =  "$baseurl/doctor-payout-details";



  // patient api 
    static const patientLogin =  "$baseurl/patientLogin";
    static const patientDetails =  "$baseurl/patient_details";
    static const getDoctor =  "$baseurl/get_doctor";
    static const getOPDDoctors =  "$baseurl/get_doctors_by_dept";
    static const getOPDDepartments =  "$baseurl/department_list";
    static const getOPDSchedule =  "$baseurl/get_schedule";
    static const getOPDTimeslot =  "$baseurl/get_timeslot";
    static const getInvestigationReport =  "$baseurl/complete_investigation_report";
    static const rateEnquiry =  "$baseurl/rate_query";

  //approval system api
  static const approvalSystemOPD =  "$baseurl/approvalsystem/opd";
  static const approvalSystemIPD =  "$baseurl/approvalsystem/ipd";
  static const approvalSystemInvestigation =  "$baseurl/approvalsystem/investigation";
  static const approvalSystemEMG =  "$baseurl/approvalsystem/emg";
  static const approvalSystemDialysis =  "$baseurl/approvalsystem/dialysis";
  static const approvalSystemOP = "$baseurl/approvalList/op";
  static const approvalSystemOT = "$baseurl/approvalList/ot";

  static const approveData =  "$baseurl/approvalsystem/approve";
  static const approvalDeptWiseCount =  "$baseurl/approval-list-count";
  static const approvalList =  "$baseurl/approvalList";
  

  
  static const billingDetails =  "$baseurl/billing-details";
  

}