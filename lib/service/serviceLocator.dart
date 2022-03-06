import 'package:get_it/get_it.dart';
import 'package:soccer/service/StorageService.dart';
import 'package:soccer/service/StorageServiceImpl.dart';

GetIt locator = GetIt.instance;

setupServiceLocator() {
  locator.registerLazySingleton<StorageService>(() => StorageServiceImpl());
}