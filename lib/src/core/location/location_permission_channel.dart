import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppLocationPermissionStatus {
  granted,
  denied,
  deniedForever,
  serviceDisabled,
}

final locationPermissionChannelProvider = Provider<LocationPermissionChannel>((
  ref,
) {
  return const LocationPermissionChannel();
});

class LocationPermissionChannel {
  const LocationPermissionChannel();

  static const _channel = MethodChannel('fliv/location_permission');

  Future<AppLocationPermissionStatus> check() async {
    final value = await _channel.invokeMethod<String>('check');
    return _parseStatus(value);
  }

  Future<AppLocationPermissionStatus> request() async {
    final value = await _channel.invokeMethod<String>('request');
    return _parseStatus(value);
  }

  AppLocationPermissionStatus _parseStatus(String? value) {
    return switch (value) {
      'granted' => AppLocationPermissionStatus.granted,
      'deniedForever' => AppLocationPermissionStatus.deniedForever,
      'serviceDisabled' => AppLocationPermissionStatus.serviceDisabled,
      _ => AppLocationPermissionStatus.denied,
    };
  }
}
