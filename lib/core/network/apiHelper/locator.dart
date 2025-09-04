
import 'package:get_it/get_it.dart';
import 'package:jnm_hospital_app/core/network/apiClientRepository/api_client.dart';
import 'package:jnm_hospital_app/core/network/apiClientRepository/api_client_impl.dart';
import 'package:jnm_hospital_app/core/network/networkRepository/network_client.dart';
import 'package:jnm_hospital_app/core/network/networkRepository/network_client_impl.dart';
import 'package:jnm_hospital_app/core/services/localStorage/shared_pref.dart';
import 'package:jnm_hospital_app/core/services/localStorage/shared_pref_impl.dart';
import 'package:jnm_hospital_app/features/admin_report_module/data/admin_report_usecase.dart';
import 'package:jnm_hospital_app/features/admin_report_module/data/admin_report_usecase_impl.dart';
import 'package:jnm_hospital_app/features/approval_system_module/approval_screen/data/approval_usecases.dart';
import 'package:jnm_hospital_app/features/approval_system_module/approval_screen/data/approval_usecases_impl.dart';
import 'package:jnm_hospital_app/features/auth_module/data/auth_usecase.dart';
import 'package:jnm_hospital_app/features/auth_module/data/auth_usecase_impl.dart';
import 'package:jnm_hospital_app/features/patient_module/patient_details/data/patient_details_usecase.dart';
import 'package:jnm_hospital_app/features/patient_module/patient_details/data/patient_details_usecase_impl.dart';
import 'package:jnm_hospital_app/features/patient_module/patient_login/data/patient_login_usecase.dart';
import 'package:jnm_hospital_app/features/patient_module/patient_login/data/patient_login_usecase_impl.dart';
import 'package:jnm_hospital_app/features/patient_module/patient_opd_module/data/patient_opd_usecases.dart';
import 'package:jnm_hospital_app/features/patient_module/patient_opd_module/data/patient_opd_usecases_impl.dart';
import 'package:jnm_hospital_app/features/patient_module/patient_rate_enquiry/data/rate_enquiry_usecases.dart';
import 'package:jnm_hospital_app/features/patient_module/patient_rate_enquiry/data/rate_enquiry_usecases_impl.dart';

final getIt = GetIt.instance;

void initializeDependency(){

  getIt.registerFactory<NetworkClient>(()=> NetworkClientImpl());
  getIt.registerFactory<SharedPref>(()=>SharedPrefImpl());
  getIt.registerFactory<ApiClient>(()=> ApiClientImpl());
  getIt.registerFactory<AdminReportUsecase>(()=> AdminReportUsecaseImplementation());
  getIt.registerFactory<AuthUsecase>(()=> AuthUsecaseImplementation());
  getIt.registerFactory<PatientLoginUsecase>(()=> PatientLoginUsecaseImpl());
  getIt.registerFactory<PatientDetailsUsecase>(()=> PatientDetailsUsecaseImpl());
  getIt.registerFactory<PatientOPDUsecases>(()=> PatientOPDUsecasesImpl());
  getIt.registerFactory<RateEnquiryUsecases>(()=> RateEnquiryUsecasesImpl());
  getIt.registerFactory<ApprovalUsecases>(()=> ApprovalUsecasesImpl());
}