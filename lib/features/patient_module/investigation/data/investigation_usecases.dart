import 'package:jnm_hospital_app/core/network/apiHelper/resource.dart';
import 'package:jnm_hospital_app/features/patient_module/model/investigation_report/investigation_report_model.dart';

abstract class InvestigationUsecases {
  Future<Resource> getInvestigationReport(
      InvestigationReportModel reportFilter);
}
