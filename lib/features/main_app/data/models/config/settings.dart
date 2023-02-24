// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Settings extends _SettingsBase {
  static const String appName = 'LifeStep';

  static const backendUrlBase = 'https://app.lifestep.az';
  static const backendUrl = '$backendUrlBase/api';

  static const deepLinkHost = 'https://lifestep.page.link';


  // Количество объектов на странице запроса.
  static const int newsPerPage = 5;
  static const int videosPerPage = 5;

  static const List<DeviceOrientation> supportedOrientations = [
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ];
}

abstract class _SettingsBase{
  /// Зашифрованное хранилище локальных данных.
  late FlutterSecureStorage _storage;
  late Map<String, String> _secureValues;


  static const savedLocaleKey = 'savedLocale';

  static const accessTokenKey = 'accessToken';
  static const accessHalfTokenKey = 'accessHalfToken';
  static const refreshTokenKey = 'refreshToken';

  static const needOnboardingKey = 'needOnboarding';

  // static const notificationTypeStateKey = 'notificationTypeState';

  static const fcmTokenKey = 'fcmToken';

  String? deviceId;

  /// Подгрузка локального хранилища.
  Future<void> initializeStorage() async {
    try {
      _storage = FlutterSecureStorage(aOptions: _getAndroidOptions(), iOptions: _getIOSOptions());
      _secureValues = await _storage.readAll();
    } catch (_) {
      _secureValues = {};
    }
  }

  /// Инициализация Firebase.
  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();

    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

    // Определение ID устройства.
    if (Platform.isAndroid) {
      deviceId = (await deviceInfoPlugin.androidInfo).androidId;
    } else if (Platform.isIOS) {
      deviceId = (await deviceInfoPlugin.iosInfo).identifierForVendor;
    }
  }

  /// Настройки хранилища для iOS.
  IOSOptions _getIOSOptions() => const IOSOptions();

  /// Настройки хранилища для Android.
  AndroidOptions _getAndroidOptions() => const AndroidOptions(encryptedSharedPreferences: false);

  bool get needOnboarding => (_secureValues[needOnboardingKey] ?? 'true') == 'true';
  // bool get needOnboarding => true;
  set needOnboarding(bool value) {
    _secureValues[needOnboardingKey] = value.toString();
    _storage.write(key: needOnboardingKey, value: value.toString());
  }

  /// FCM token.
  String get fcmToken => (_secureValues[fcmTokenKey] ?? '');
  set fcmToken(String token) {
    _secureValues[fcmTokenKey] = token;
    _storage.write(key: fcmTokenKey, value: token);
  }

  /// Текущая локализация.
  String get savedLocale => (_secureValues[savedLocaleKey] ?? '');
  set savedLocale(String locale) {
    _secureValues[savedLocaleKey] = locale;
    _storage.write(key: savedLocaleKey, value: locale);
  }

  /// Access token.
  String get accessToken => _secureValues[accessTokenKey] ?? '';
  set accessToken(String token) {
    _secureValues[accessTokenKey] = token;
    _storage.write(key: accessTokenKey, value: token);
  }

  /// Access half token.
  String get accessHalfToken => _secureValues[accessHalfTokenKey] ?? '';
  set accessHalfToken(String token) {
    _secureValues[accessHalfTokenKey] = token;
    _storage.write(key: accessHalfTokenKey, value: token);
  }

  /// Refresh token.
  String get refreshToken => _secureValues[refreshTokenKey] ?? '';
  set refreshToken(String token) {
    _secureValues[refreshTokenKey] = token;
    _storage.write(key: refreshTokenKey, value: token);
  }
}
