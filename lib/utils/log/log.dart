import 'dart:developer' as dev;

import 'package:fgtagro_mobile/utils/functions/navigate.dart';
import 'package:flutter/material.dart';

class DevLog {
  DevLog._();

  static void show(String? message, {String name = ""}) {
    dev.log((message ?? "NULL").toString(), name: name);
  }

  static void dismissFocus() {
    FocusScope.of(CustomNavigate.currentContext!).unfocus();
  }
}
