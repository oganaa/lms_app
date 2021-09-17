import 'package:get_it/get_it.dart';
import 'package:lms_app/services/navigation_service.dart';
import 'package:lms_app/services/web_service.dart';

GetIt locator = GetIt.instance;

void setupLocator(){
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => WebService());
}