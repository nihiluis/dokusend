import 'package:flutter/foundation.dart';

class Config {
  static bool devMode =
      const bool.fromEnvironment('DEV_MODE', defaultValue: false);

  static final ValueNotifier<String> documentUnderstandingApiUrl =
      ValueNotifier(
          devMode ? 'http://localhost:3000' : 'https://production.com/analyze');

  // Prevent instantiation
  Config._();
}