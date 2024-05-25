import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:math';
import 'platform_model.dart'; // Импортируем PlatformModel
import 'di_container.dart'; // Импортируем getIt и PlatformService

void main() {
  String platform;
  if (Platform.isAndroid) {
    platform = 'Android';
  } else if (Platform.isIOS) {
    platform = 'iOS';
  } else if (Platform.isLinux) {
    platform = 'Linux';
  } else if (Platform.isMacOS) {
    platform = 'macOS';
  } else if (Platform.isWindows) {
    platform = 'Windows';
  } else {
    platform = 'неизвестная платформа';
  }

  // Генерируем случайное число для выбора способа передачи параметров
  bool useInheritedWidget = Random().nextBool();

  if (useInheritedWidget) {
    runApp(MyInheritedWidgetApp(platform: platform));
  } else {
    // Регистрация в DI контейнере
    getIt.registerSingleton<PlatformService>(PlatformService(platform));
    runApp(MyGetItApp());
  }
}

class MyInheritedWidgetApp extends StatelessWidget {
  final String platform;

  MyInheritedWidgetApp({required this.platform});

  @override
  Widget build(BuildContext context) {
    return PlatformModel(
      platform: platform,
      child: MaterialApp(
        title: 'InheritedWidget Example',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: PlatformScreen(),
      ),
    );
  }
}

class MyGetItApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GetIt Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PlatformScreen(),
    );
  }
}

class PlatformScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Проверяем, используется ли InheritedWidget или GetIt для получения платформы
    final platformModel = PlatformModel.of(context);
    final platformService = getIt.isRegistered<PlatformService>() ? getIt<PlatformService>() : null;

    String platform;
    if (platformModel != null) {
      platform = platformModel.platform;
    } else if (platformService != null) {
      platform = platformService.platform;
    } else {
      platform = 'неизвестная платформа';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Экран платформы'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Приложение запущено на: ${platform}'),
            if (platformModel != null)
              Text('через InheritedWidget'),
            if (platformService != null)
              Text('через GetIt'),
          ],
        ),
      ),
    );
  }
}
