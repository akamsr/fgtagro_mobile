// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `No Connection`
  String get noConnection {
    return Intl.message(
      'No Connection',
      name: 'noConnection',
      desc: '',
      args: [],
    );
  }

  /// `We are unable to connect to our servers.`
  String get weAreUnableToConnectToOurServers {
    return Intl.message(
      'We are unable to connect to our servers.',
      name: 'weAreUnableToConnectToOurServers',
      desc: '',
      args: [],
    );
  }

  /// `Unexpected Error`
  String get unExpectedErrorHome {
    return Intl.message(
      'Unexpected Error',
      name: 'unExpectedErrorHome',
      desc: '',
      args: [],
    );
  }

  /// `An unexpected error occurred. Please refresh.`
  String get anUnExpectedErrorOcurredRefresh {
    return Intl.message(
      'An unexpected error occurred. Please refresh.',
      name: 'anUnExpectedErrorOcurredRefresh',
      desc: '',
      args: [],
    );
  }

  /// `Permission Error`
  String get permissionError {
    return Intl.message(
      'Permission Error',
      name: 'permissionError',
      desc: '',
      args: [],
    );
  }

  /// `Location permission is needed.`
  String get locationPermissionNeeded {
    return Intl.message(
      'Location permission is needed.',
      name: 'locationPermissionNeeded',
      desc: '',
      args: [],
    );
  }

  /// `Feature in Development`
  String get featInDev {
    return Intl.message(
      'Feature in Development',
      name: 'featInDev',
      desc: '',
      args: [],
    );
  }

  /// `Coming in October 2024`
  String get comingInOctober2024 {
    return Intl.message(
      'Coming in October 2024',
      name: 'comingInOctober2024',
      desc: '',
      args: [],
    );
  }

  /// `Permission Granted`
  String get permissionGranted {
    return Intl.message(
      'Permission Granted',
      name: 'permissionGranted',
      desc: '',
      args: [],
    );
  }

  /// `Click The Refresh Button`
  String get clickTheRefreshButton {
    return Intl.message(
      'Click The Refresh Button',
      name: 'clickTheRefreshButton',
      desc: '',
      args: [],
    );
  }

  /// `Refresh Page`
  String get refreshPage {
    return Intl.message(
      'Refresh Page',
      name: 'refreshPage',
      desc: '',
      args: [],
    );
  }

  /// `Grant Permission`
  String get grantPermission {
    return Intl.message(
      'Grant Permission',
      name: 'grantPermission',
      desc: '',
      args: [],
    );
  }

  /// `Try Again`
  String get tryAgain {
    return Intl.message('Try Again', name: 'tryAgain', desc: '', args: []);
  }

  /// `Added to cart!`
  String get addedToCart {
    return Intl.message(
      'Added to cart!',
      name: 'addedToCart',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Biometric Login`
  String get biometricLogin {
    return Intl.message(
      'Biometric Login',
      name: 'biometricLogin',
      desc: '',
      args: [],
    );
  }

  /// `Details`
  String get details {
    return Intl.message('Details', name: 'details', desc: '', args: []);
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Ex: Entrance facing Total station...`
  String get locationHint {
    return Intl.message(
      'Ex: Entrance facing Total station...',
      name: 'locationHint',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `New Password`
  String get newPassword {
    return Intl.message(
      'New Password',
      name: 'newPassword',
      desc: '',
      args: [],
    );
  }

  /// `Last Name`
  String get lastName {
    return Intl.message('Last Name', name: 'lastName', desc: '', args: []);
  }

  /// `Phone Number`
  String get phoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `OTP Code`
  String get otpCode {
    return Intl.message('OTP Code', name: 'otpCode', desc: '', args: []);
  }

  /// `Don't have an account yet?`
  String get noAccountYet {
    return Intl.message(
      'Don\'t have an account yet?',
      name: 'noAccountYet',
      desc: '',
      args: [],
    );
  }

  /// `Password Reset Successful`
  String get passwordResetSuccessful {
    return Intl.message(
      'Password Reset Successful',
      name: 'passwordResetSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `Product not found`
  String get productNotFound {
    return Intl.message(
      'Product not found',
      name: 'productNotFound',
      desc: '',
      args: [],
    );
  }

  /// `First Name`
  String get firstName {
    return Intl.message('First Name', name: 'firstName', desc: '', args: []);
  }

  /// `Search for a product...`
  String get searchProductHint {
    return Intl.message(
      'Search for a product...',
      name: 'searchProductHint',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get resetPassword {
    return Intl.message(
      'Reset Password',
      name: 'resetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message('Register', name: 'register', desc: '', args: []);
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Send Reset Link`
  String get sendResetLink {
    return Intl.message(
      'Send Reset Link',
      name: 'sendResetLink',
      desc: '',
      args: [],
    );
  }

  /// `Type your message...`
  String get typeYourMessage {
    return Intl.message(
      'Type your message...',
      name: 'typeYourMessage',
      desc: '',
      args: [],
    );
  }

  /// `Phone`
  String get phone {
    return Intl.message('Phone', name: 'phone', desc: '', args: []);
  }

  /// `Verification Code`
  String get verificationCode {
    return Intl.message(
      'Verification Code',
      name: 'verificationCode',
      desc: '',
      args: [],
    );
  }

  /// `Verify`
  String get verify {
    return Intl.message('Verify', name: 'verify', desc: '', args: []);
  }

  /// `Please accept the terms of use`
  String get acceptTerms {
    return Intl.message(
      'Please accept the terms of use',
      name: 'acceptTerms',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account?`
  String get alreadyHaveAccount {
    return Intl.message(
      'Already have an account?',
      name: 'alreadyHaveAccount',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'fr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
