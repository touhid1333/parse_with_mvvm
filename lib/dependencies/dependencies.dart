import 'package:get_it/get_it.dart';
import 'package:parse_with_mvvm/services/dashboardServices/cloud_dashboard_service.dart';
import 'package:parse_with_mvvm/services/dashboardServices/cloud_dashboard_service_impl.dart';
import 'package:parse_with_mvvm/services/dashboardServices/dashboard_service.dart';
import 'package:parse_with_mvvm/services/dashboardServices/parse_dashboard_services.dart';
import 'package:parse_with_mvvm/services/filterServices/filter_service.dart';
import 'package:parse_with_mvvm/services/filterServices/parse_filter_service.dart';
import 'package:parse_with_mvvm/services/login_services/login_service.dart';
import 'package:parse_with_mvvm/services/login_services/parse_login_service.dart';
import 'package:parse_with_mvvm/services/signup_services/parse_signup_service.dart';
import 'package:parse_with_mvvm/services/signup_services/signup_service.dart';

GetIt dependency = GetIt.instance;

void initDev() {
  // dependency injection
  //login
  dependency.registerLazySingleton<LoginService>(() => ParseLoginService());
  //sign up
  dependency.registerLazySingleton<SignupService>(() => ParseSignupService());
  //dashboard
  dependency
      .registerLazySingleton<DashboardService>(() => ParseDashboardServices());
  dependency.registerLazySingleton<CloudDashboardService>(
      () => CloudDashboardServiceIMPL());
  dependency.registerLazySingleton<FilterService>(() => ParseFilterService());
}

void initProd() {
  // dependency injection
  //dependency.registerLazySingleton<HomeService>(() => HomeServiceMock());
}
