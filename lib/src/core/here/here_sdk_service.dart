import 'package:here_sdk/core.dart';
import 'package:here_sdk/core.engine.dart';
import 'package:here_sdk/core.errors.dart';

class HereSdkService {
  HereSdkService({required this.accessKeyId, required this.accessKeySecret});

  final String accessKeyId;
  final String accessKeySecret;

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    SdkContext.init(IsolateOrigin.main);

    final authenticationMode = AuthenticationMode.withKeySecret(
      accessKeyId,
      accessKeySecret,
    );
    final sdkOptions = SDKOptions.withAuthenticationMode(authenticationMode);

    try {
      await SDKNativeEngine.makeSharedInstance(sdkOptions);
    } on InstantiationException {
      throw Exception('Failed to initialize the HERE SDK.');
    }

    _initialized = true;
  }

  Future<void> dispose() async {
    if (!_initialized) return;

    await SDKNativeEngine.sharedInstance?.dispose();
    SdkContext.release();

    _initialized = false;
  }
}
