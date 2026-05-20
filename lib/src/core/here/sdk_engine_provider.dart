import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile/src/core/config/env.dart';
import 'package:mobile/src/core/here/here_sdk_service.dart';

final hereSdkServiceProvider = Provider<HereSdkService>((ref) {
  final accessKeyId = Env.hereAccessKeyId;
  final accessKeySecret = Env.hereAccessKeySecret;
  //TODO:Change error if empty credentials
  if (accessKeyId.isEmpty || accessKeySecret.isEmpty) {
    throw StateError('Empty HERE credentials.');
  }

  final service = HereSdkService(
    accessKeyId: accessKeyId,
    accessKeySecret: accessKeySecret,
  );

  ref.onDispose(() {
    service.dispose();
  });

  return service;
});

final hereSdkInitProvider = FutureProvider<void>((ref) async {
  final service = ref.read(hereSdkServiceProvider);
  await service.init();

  ref.read(hereSdkLifecycleProvider);
});

final hereSdkLifecycleProvider = Provider<AppLifecycleListener>((ref) {
  final service = ref.read(hereSdkServiceProvider);

  final listener = AppLifecycleListener(
    onDetach: () {
      service.dispose();
    },
  );

  ref.onDispose(listener.dispose);
  return listener;
});
