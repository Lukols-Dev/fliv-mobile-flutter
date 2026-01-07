import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import 'package:mobile/src/core/location/location.dart';
import 'package:mobile/src/core/location/location_service.dart';

final locationServiceProvider = Provider<LocationService>((ref) {
  return const LocationService();
});

final locationControllerProvider =
    AsyncNotifierProvider.autoDispose<LocationController, AppLocation?>(
      LocationController.new,
    );

class LocationController extends AsyncNotifier<AppLocation?> {
  StreamSubscription<Position>? _sub;

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
      final service = ref.read(locationServiceProvider);
      final pos = await service.getCurrentPosition();
      final loc = AppLocation.fromPosition(pos);
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
    final service = ref.read(locationServiceProvider);
    await _sub?.cancel();
    _sub = service.getPositionStream().listen(
      (pos) => state = AsyncData(AppLocation.fromPosition(pos)),
      onError: (e, st) => state = AsyncError(e, st),
    );
  }

  Future<void> stopTracking() async {
    await _sub?.cancel();
    _sub = null;
  }

  Future<void> openAppSettings() async {
    await ref.read(locationServiceProvider).openAppSettings();
  }

  Future<void> openLocationSettings() async {
    await ref.read(locationServiceProvider).openLocationSettings();
  }
}
