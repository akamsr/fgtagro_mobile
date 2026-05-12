import 'package:envied/envied.dart';

part 'dev_env.g.dart';

@Envied(path: '.env.dev', obfuscate: true)
abstract class DevEnv {
  @EnviedField(varName: 'GOOGLE_MAPS_API_KEY')
  static final String googleMapsApiKey = _DevEnv.googleMapsApiKey;

  @EnviedField(varName: 'FIREBASE_API_KEY')
  static final String firebaseApiKey = _DevEnv.firebaseApiKey;

  @EnviedField(varName: 'FIREBASE_APP_ID')
  static final String firebaseAppId = _DevEnv.firebaseAppId;

  @EnviedField(varName: 'FIREBASE_MESSAGING_SENDER_ID')
  static final String firebaseMessagingSenderId = _DevEnv.firebaseMessagingSenderId;

  @EnviedField(varName: 'FIREBASE_PROJECT_ID')
  static final String firebaseProjectId = _DevEnv.firebaseProjectId;

  @EnviedField(varName: 'FIREBASE_STORAGE_BUCKET')
  static final String firebaseStorageBucket = _DevEnv.firebaseStorageBucket;

  @EnviedField(varName: 'API_BASE_URL')
  static final String apiBaseUrl = _DevEnv.apiBaseUrl;
}
