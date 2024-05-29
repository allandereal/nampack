import 'package:flutter/material.dart';

import 'package:nampack/navigation/nampack_page_route.dart';
import 'package:nampack/navigation/transition_type.dart';

extension NavigatorUtils on NavigatorState {
  Future<T?> pushPage<T>(
    Widget page, {
    Transition transition = Transition.cupertino,
    int durationInMs = 300,
    Curve curve = Curves.easeOut,
    bool opaque = true,
    bool fullscreenDialog = false,
    required bool maintainState,
  }) async {
    return push(
      NamPackPageRoute(
        pageBuilder: (context) => page,
        transitionDuration: Duration(milliseconds: durationInMs),
        reverseTransitionDuration: Duration(milliseconds: (durationInMs * 0.8).round()),
        transition: transition,
        curve: curve,
        opaque: opaque,
        fullscreenDialog: fullscreenDialog,
        maintainState: maintainState,
      ),
    );
  }

  Future<T?> pushPageReplacement<T>(
    Widget page, {
    Transition transition = Transition.cupertino,
    int durationInMs = 300,
    Curve curve = Curves.easeOut,
    bool opaque = true,
    bool fullscreenDialog = false,
    required bool maintainState,
  }) async {
    return pushReplacement(
      NamPackPageRoute(
        pageBuilder: (context) => page,
        maintainState: maintainState,
        transitionDuration: Duration(milliseconds: durationInMs),
        reverseTransitionDuration: Duration(milliseconds: (durationInMs * 0.8).round()),
        transition: transition,
        curve: curve,
        opaque: opaque,
        fullscreenDialog: fullscreenDialog,
      ),
    );
  }
}
