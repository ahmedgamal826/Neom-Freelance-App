// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class LoadingHelperStyle {
  // mask color
  Color maskColor;
  // animation duration
  Duration animationDuration;
  // indicator widget
  Widget indicatorWidget;
  // can the user still interact?
  bool userInteractions;
  // can the user dismiss on Tap?
  bool dismissOnTap;
  LoadingHelperStyle({
    this.maskColor = Colors.black26,
    this.animationDuration = const Duration(milliseconds: 250),
    this.indicatorWidget = const CircularProgressIndicator(),
    this.userInteractions = false,
    this.dismissOnTap = false,
  });
}
