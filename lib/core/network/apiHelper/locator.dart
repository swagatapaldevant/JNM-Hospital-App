
import 'package:get_it/get_it.dart';
import 'package:jnm_hospital_app/core/network/apiClientRepository/api_client.dart';
import 'package:jnm_hospital_app/core/network/apiClientRepository/api_client_impl.dart';
import 'package:jnm_hospital_app/core/network/networkRepository/network_client.dart';
import 'package:jnm_hospital_app/core/network/networkRepository/network_client_impl.dart';
import 'package:jnm_hospital_app/core/services/localStorage/shared_pref.dart';
import 'package:jnm_hospital_app/core/services/localStorage/shared_pref_impl.dart';

final getIt = GetIt.instance;

void initializeDependency(){

  getIt.registerFactory<NetworkClient>(()=> NetworkClientImpl());
  getIt.registerFactory<SharedPref>(()=>SharedPrefImpl());
  getIt.registerFactory<ApiClient>(()=> ApiClientImpl());

}