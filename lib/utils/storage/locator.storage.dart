import 'package:fgtagro_mobile/routes/router.dart';
import 'package:fgtagro_mobile/utils/language/language.dart';
import 'package:fgtagro_mobile/utils/storage/hive.storage.dart';
import 'package:fgtagro_mobile/utils/storage/local.storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/network/api_client.dart';

GetIt locator = GetIt.instance;

/// Should only be called at initial app start.
Future<void> setupInitialLocator() async {
  setupApi();
  await _setupAppLocator();
  setupUserDependentLocator();
}

Future<void> _setupAppLocator() async {
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  await HiveDbService().init();

  assert(
    !locator.isRegistered<AppRouter>(),
    "setupAppLocator should only be called once at the start of the app.",
  );

  locator.registerLazySingleton<AppRouter>(() => AppRouter());

  locator.registerLazySingleton<StorageServices>(
    () => StorageServices(preferences),
  );

  locator.registerLazySingleton<HiveDbService>(() => HiveDbService());
  locator.registerLazySingleton<LanguageService>(() => LanguageService());

  // if (!locator.isRegistered<CachingService>()) {
  //   locator.registerSingletonAsync<CachingService>(
  //     () async =>
  //         await CachingService.init(stalePeriod: const Duration(days: 2)),
  //   );
  // }
}

/// Also gets called when a new user logs in
void setupUserDependentLocator() {
  // locator.registerLazySingleton<ProfileService>(() => ProfileService());
}

void restartUserServices() {
  setupUserDependentLocator();
}

void setupApi() {
  locator.registerLazySingleton(() => ApiClient());

  // Data sources
  // locator.registerLazySingleton<IChatApi>(
  //   () => ChatApi(apiClient: locator<ApiClient>()),
  // );
}
