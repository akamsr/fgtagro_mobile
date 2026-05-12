import 'dart:async';

import 'package:fgtagro_mobile/widgets/notification/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../utils/theme/colors.dart';

class FirebaseProvider extends ChangeNotifier {
  bool _authenticated = false;

  bool get authenticated => _authenticated;

  set authenticated(bool value) {
    _authenticated = value;
    notifyListeners();
  }

  Future<User> createUserWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw Exception("User not Found");
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  User? get currentUser => FirebaseAuth.instance.currentUser;

  Future<void> logOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<User> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw Exception("User not Found");
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw throw Exception("User not Found");
    }
  }

  Future<bool> updateUserEmail(String newEmail, String currentPassword) async {
    try {
      if (currentUser != null) {
        await reAuthenticateUser(currentUser!.email!, currentPassword);
        await currentUser!.verifyBeforeUpdateEmail(newEmail);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      showToast(
        'Error updating email: ${e.toString()}',
        bgColor: AppColors.dangerFg,
      );

      return false;
    }
  }

  Future<bool> updateUserPassword(String newPassword) async {
    try {
      if (currentUser != null) {
        await currentUser!.updatePassword(newPassword);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> reAuthenticateUser(String email, String currentPassword) async {
    try {
      if (currentUser != null) {
        final credential = EmailAuthProvider.credential(
          email: email,
          password: currentPassword,
        );
        await currentUser!.reauthenticateWithCredential(credential);
      } else {}
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
    }
  }

  Future<void> updatePhoneNumber(String newPhoneNumber) async {
    final auth = FirebaseAuth.instance;
    if (currentUser != null) {
      try {
        // Step 1: Verify the new phone number
        await auth.verifyPhoneNumber(
          phoneNumber: newPhoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            // This callback will be triggered automatically on some devices
            await currentUser!.updatePhoneNumber(credential);
          },
          verificationFailed: (FirebaseAuthException e) {},
          codeSent: (String verificationId, int? resendToken) async {
            // Step 2: Prompt the user to enter the SMS code
            final smsCode =
                await promptUserForSMSCode(); // Implement this method

            // Step 3: Create a PhoneAuthCredential with the code
            final credential = PhoneAuthProvider.credential(
              verificationId: verificationId,
              smsCode: smsCode,
            );

            // Step 4: Update the user's phone number
            await currentUser!.updatePhoneNumber(credential);
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            // Called when the auto-retrieval timer runs out
          },
        );
      } catch (e, s) {
        debugPrintStack(stackTrace: s);
      }
    } else {}
  }

  Future<void> updatePasswordForPhoneUser(String newPassword) async {
    if (currentUser != null) {
      try {
        await currentUser!.updatePassword(newPassword);
      } catch (e) {
        // If updating fails, you might need to re-authenticate
        if (e is FirebaseAuthException && e.code == 'requires-recent-login') {
          // Re-authenticate and then try updating again
          await reAuthenticatePhoneUser();
          await currentUser!.updatePassword(newPassword);
        }
      }
    } else {}
  }

  Future<void> reAuthenticatePhoneUser() async {
    if (currentUser != null) {
      try {
        // You'll need to verify the phone number again
        final verificationId = await getVerificationId(
          currentUser!.phoneNumber!,
        );
        final smsCode = await promptUserForSMSCode();

        final credential = PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: smsCode,
        );

        await currentUser!.reauthenticateWithCredential(credential);
      } catch (e, s) {
        debugPrintStack(stackTrace: s);
      }
    }
  }

  Future<String> getVerificationId(String phoneNumber) async {
    final completer = Completer<String>();

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        completer.completeError(e);
      },
      codeSent: (String verificationId, int? resendToken) {
        completer.complete(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );

    return completer.future;
  }

  // You need to implement this method to get the SMS code from the user
  Future<String> promptUserForSMSCode() async {
    // This could be a dialog or a text field in your UI
    // Return the SMS code entered by the user
    return '123456'; // Replace with actual implementation
  }
}
