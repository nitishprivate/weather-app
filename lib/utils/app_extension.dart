import 'package:flutter/material.dart' show BuildContext, MediaQuery;
import 'package:flutter_application_1_bloc/utils/app_enums.dart';

extension AppScreenSize on BuildContext {
  // This will return current device width
  double get width => MediaQuery.of(this).size.width;
  // This will return current device height
  double get height => MediaQuery.of(this).size.height;

  /// this will give [AppScreenState]
  /// depending on that we can show our UI
  AppScreenState get getDeviceState {
    if (width <= 450) {
      return AppScreenState.mobile;
    } else if (width <= 700) {
      return AppScreenState.tablet;
    } else {
      return AppScreenState.pc;
    }
  }
}
