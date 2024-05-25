import 'package:flutter/material.dart';

class PlatformModel extends InheritedWidget {
  final String platform;

  PlatformModel({required this.platform, required Widget child}) : super(child: child);

  static PlatformModel? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<PlatformModel>();
  }

  @override
  bool updateShouldNotify(PlatformModel oldWidget) {
    return platform != oldWidget.platform;
  }
}