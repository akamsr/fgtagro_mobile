import 'package:fgtagro_mobile/env/app_config.dart';
import 'package:fgtagro_mobile/env/prod_env.dart';
import 'package:fgtagro_mobile/firebase_options_prod.dart';
import 'package:fgtagro_mobile/main.dart';
import 'package:fgtagro_mobile/utils/storage/locator.storage.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.init(
    flavor: AppFlavor.prod,
    apiBaseUrl: ProdEnv.apiBaseUrl,
    appName: 'FGT Agro',
  );

  await setupInitialLocator();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.light.copyWith(
      statusBarColor: AppColors.primaryColor,
      statusBarBrightness: Brightness.dark,
    ),
  );

  await Firebase.initializeApp(options: ProdFirebaseOptions.currentPlatform);

  runApp(MyApp(isDev: false));
}
