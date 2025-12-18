import 'package:flutter/foundation.dart';

class Env {
  Env._();

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  static void validate() {
    if (kReleaseMode && apiBaseUrl.isEmpty) {
      throw StateError('Missing API_BASE_URL. Use --dart-define-from-file.');
    }
  }
}
