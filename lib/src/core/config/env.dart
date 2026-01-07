import 'package:flutter/foundation.dart';

class Env {
  Env._();

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  // HERE Explore (Access Key ID + Secret)
  static const String hereAccessKeyId = String.fromEnvironment(
    'HERESDK_ACCESS_KEY_ID',
    defaultValue: '',
  );

  static const String hereAccessKeySecret = String.fromEnvironment(
    'HERESDK_ACCESS_KEY_SECRET',
    defaultValue: '',
  );

  static void validate() {
    if (kReleaseMode && apiBaseUrl.isEmpty) {
      throw StateError('Missing API_BASE_URL. Use --dart-define-from-file.');
    }

    if (kReleaseMode &&
        (hereAccessKeyId.isEmpty || hereAccessKeySecret.isEmpty)) {
      throw StateError(
        'Missing HERESDK_ACCESS_KEY_ID / HERESDK_ACCESS_KEY_SECRET. Use --dart-define-from-file.',
      );
    }
  }
}
