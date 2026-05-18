import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:here_sdk/core.dart' as here;

import 'package:mobile/src/core/here/driver_here_location_service.dart';
import 'package:mobile/src/core/location/location.dart';

final locationControllerProvider =
    AsyncNotifierProvider.autoDispose<LocationController, AppLocation?>(
      LocationController.new,
    );

class LocationController extends AsyncNotifier<AppLocation?> {
  StreamSubscription<here.Location>? _sub;

  @override
  Future<AppLocation?> build() async {
    ref.onDispose(() async {
      await _sub?.cancel();
      _sub = null;
    });

    return null;
  }

  Future<AppLocation> getCurrent() async {
    state = const AsyncLoading();
    try {
      final service = ref.read(driverHereLocationServiceProvider);
      final hereLocation = await service.getCurrentHereLocation();
      final loc = AppLocation.fromHereLocation(hereLocation);
      state = AsyncData(loc);
      return loc;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> startTracking() async {
    // 1) złap pierwszy fix (też prosi o zgodę)
    await getCurrent();

    // 2) stream
    final service = ref.read(driverHereLocationServiceProvider);
    await _sub?.cancel();
    _sub = service.locationStream.listen(
      (location) => state = AsyncData(AppLocation.fromHereLocation(location)),
      onError: (e, st) => state = AsyncError(e, st),
    );
  }

  Future<void> stopTracking() async {
    await _sub?.cancel();
    _sub = null;
  }
}
