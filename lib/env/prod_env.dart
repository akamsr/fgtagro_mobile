import 'package:envied/envied.dart';

part 'prod_env.g.dart';

@Envied(path: '.env.prod', obfuscate: true)
abstract class ProdEnv {
  @EnviedField(varName: 'GOOGLE_MAPS_API_KEY')
  static final String googleMapsApiKey = _ProdEnv.googleMapsApiKey;

  @EnviedField(varName: 'FIREBASE_API_KEY')
  static final String firebaseApiKey = _ProdEnv.firebaseApiKey;

  @EnviedField(varName: 'FIREBASE_APP_ID')
  static final String firebaseAppId = _ProdEnv.firebaseAppId;

  @EnviedField(varName: 'FIREBASE_MESSAGING_SENDER_ID')
  static final String firebaseMessagingSenderId = _ProdEnv.firebaseMessagingSenderId;

  @EnviedField(varName: 'FIREBASE_PROJECT_ID')
  static final String firebaseProjectId = _ProdEnv.firebaseProjectId;

  @EnviedField(varName: 'FIREBASE_STORAGE_BUCKET')
  static final String firebaseStorageBucket = _ProdEnv.firebaseStorageBucket;

  @EnviedField(varName: 'API_BASE_URL')
  static final String apiBaseUrl = _ProdEnv.apiBaseUrl;
}
