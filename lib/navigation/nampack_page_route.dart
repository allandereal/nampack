import 'package:flutter/material.dart';
import 'package:nampack/navigation/page_transition_mixin.dart';
import 'package:nampack/navigation/transition_type.dart';
import 'package:nampack/navigation/transitions.dart';

class NamPackPageRoute<T> extends PageRoute<T> with NamPageRouteTransitionMixin<T> {
  NamPackPageRoute({
    required Function(BuildContext context) pageBuilder,
    required this.transitionDuration,
    Duration? reverseTransitionDuration,
    this.title,
    required this.maintainState,
    this.gestureWidth,
    this.barrierColor,
    super.settings,
    this.opaque = true,
    this.curve,
    this.alignment,
    this.transition,
    this.popGesture = true,
    this.barrierDismissible = false,
    this.showCupertinoParallax = true,
    this.barrierLabel,
    this.customTransition,
    super.fullscreenDialog,
  })  : _pageBuilder = pageBuilder,
        reverseTransitionDuration = reverseTransitionDuration ?? transitionDuration;

  @override
  final String? title;

  @override
  final bool maintainState;

  @override
  final Color? barrierColor;

  @override
  final String? barrierLabel;

  @override
  final Duration transitionDuration;

  @override
  final Duration reverseTransitionDuration;

  @override
  final bool showCupertinoParallax;

  @override
  final bool opaque;

  @override
  final double Function(BuildContext context)? gestureWidth;

  @override
  final bool barrierDismissible;

  @override
  Widget buildContent(BuildContext context) => _pageBuilder(context);

  final Function(BuildContext context) _pageBuilder;
  final CustomTransition? customTransition;
  final Transition? transition;
  final Curve? curve;
  final Alignment? alignment;
  final bool popGesture;
}
