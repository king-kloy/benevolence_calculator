import 'package:get_it/get_it.dart';

import 'src/core/service/api.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => Api());
}