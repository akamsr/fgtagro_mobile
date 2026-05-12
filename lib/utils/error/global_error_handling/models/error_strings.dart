import 'error_mapping.dart';

const Map<String, String> _errorCodeMap = {
  "unknown": "Unknown error occurred. We'll take a look.",
  //LOGIN
  "invalid-email": "The email addresss provided is not properly formatted.",
  "wrong-password": "Your password is incorrect.",
  "user-not-found": "No user was found with this email address",
  "user-disabled": "This user has been disabled",
  "too-many-requests": "The server is busy please try again",
  "operation-not-allowed": "This login operation is not allowed.",
  //REGISTRIERUNG
  //https://firebase.google.com/docs/auth/admin/errors
  "email-already-in-use":
      "Another user already exists with this email address.",
  "invalid-password": "Please input a propper password",
  "session-expired":
      "The sms code has expired. Please re-send the verification code to try again.",
  "invalid-verification-code":
      "The verification code from SMS/TOTP is invalid. Please check and enter the correct verification code again.",
  "missing-email": "An email address must be provided",
  "account-exists-with-different-credential":
      "An account already exists with the same email address but different sign-in credentials.\nSign in using a provider associated with this email address",
};

/// Prefix can be 'firebase-auth/'. It will be removed.
String getFirebaseErrorMessage(
  String errorCodeWithPrefix, {
  String prefix = "firebase-auth",
}) {
  final String errorCode = errorCodeWithPrefix.replaceAll(prefix, '');

  if (_errorCodeMap.containsKey(errorCode)) return _errorCodeMap[errorCode]!;
  return "An unexpected error occurred.";
}

// const Map<ErrorType, String> errorStrings = {
//   ErrorType.NoConnection: "There is no internet connection.",
//   ErrorType.Unknown: "An unknown error occured. Please try again."
// };
