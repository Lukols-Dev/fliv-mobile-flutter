import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:here_sdk/core.dart' as here;
import 'package:mobile/src/core/database/app_database.dart';
import 'package:mobile/src/core/database/app_database_provider.dart';
import 'package:mobile/src/core/here/driver_here_location_service.dart';
import 'package:mobile/src/core/network/dio_provider.dart';

const driverLocationForbiddenMessage =
    'You cannot send location for this transport order.';
const driverLocationInactiveOrderMessage =
    'This transport order is not active.';
const driverLocationReportFailedMessage =
    'Location was not sent to the dispatcher.';

final driverLocationReportingApiProvider = Provider<DriverLocationReportingApi>(
  (ref) => DriverLocationReportingApi(ref.read(dioProvider)),
);

final driverLocationReportingServiceProvider =
    Provider<DriverLocationReportingService>((ref) {
      final service = DriverLocationReportingService(
        hereLocationReader: ref.read(driverHereLocationServiceProvider),
        api: ref.read(driverLocationReportingApiProvider),
        db: ref.read(appDatabaseProvider),
      );
      ref.onDispose(service.stopPeriodicReporting);
      return service;
    });

class DriverLocationReportingException implements Exception {
  const DriverLocationReportingException(this.message);

  final String message;

  @override
  String toString() => message;
}

abstract class DriverLocationReportingClient {
  Future<void> sendLocation({
    required String transportOrderId,
    required Map<String, dynamic> payload,
  });
}

class DriverLocationReportingApi implements DriverLocationReportingClient {
  DriverLocationReportingApi(this._dio);

  final Dio _dio;

  Future<void> sendLocation({
    required String transportOrderId,
    required Map<String, dynamic> payload,
  }) async {
    await _dio.put(
      '/api/v1/driver/transport-orders/$transportOrderId/location',
      data: payload,
    );
  }
}

class _NavigationProgress {
  const _NavigationProgress({
    required this.remainingDistanceMeters,
    required this.remainingDurationSeconds,
  });

  final int remainingDistanceMeters;
  final int remainingDurationSeconds;
}

class DriverLocationReportingService {
  DriverLocationReportingService({
    required DriverHereLocationReader hereLocationReader,
    required DriverLocationReportingClient api,
    required AppDatabase db,
  }) : _hereLocationReader = hereLocationReader,
       _api = api,
       _db = db;

  final DriverHereLocationReader _hereLocationReader;
  final DriverLocationReportingClient _api;
  final AppDatabase _db;
  final Map<String, Future<void>> _inFlightByOrder = {};
  Timer? _periodicTimer;
  String? _periodicTransportOrderId;
  Future<void>? _periodicSendInFlight;
  _NavigationProgress? _navProgress;
  here.Location? _simulatedLocation;
  int _odometerMeters = 0;
  String? _odometerOrderId;

  void setSimulatedLocation(here.Location? location) {
    _simulatedLocation = location;
  }

  bool get isReporting => _periodicTransportOrderId != null;

  void addToOdometer(int deltaMeters) {
    _odometerMeters += deltaMeters;
  }

  Future<void> _persistOdometer() async {
    final orderId = _odometerOrderId;
    if (orderId != null && _odometerMeters > 0) {
      await _db.saveOrderOdometer(orderId, _odometerMeters);
    }
  }

  void updateNavigationProgress({
    required int? remainingDistanceMeters,
    required int? remainingDurationSeconds,
  }) {
    if (remainingDistanceMeters == null || remainingDurationSeconds == null) {
      _navProgress = null;
      return;
    }
    _navProgress = _NavigationProgress(
      remainingDistanceMeters: remainingDistanceMeters,
      remainingDurationSeconds: remainingDurationSeconds,
    );
  }

  Future<void> reportCurrentLocation({required String transportOrderId}) {
    final inFlight = _inFlightByOrder[transportOrderId];
    if (inFlight != null) return inFlight;

    final future = _reportCurrentLocation(transportOrderId: transportOrderId);
    _inFlightByOrder[transportOrderId] = future;

    void clearInFlight() {
      if (identical(_inFlightByOrder[transportOrderId], future)) {
        _inFlightByOrder.remove(transportOrderId);
      }
    }

    future.then<void>((_) => clearInFlight(), onError: (_) => clearInFlight());

    return future;
  }

  Future<void> _reportCurrentLocation({
    required String transportOrderId,
  }) async {
    final location =
        _hereLocationReader.lastKnownHereLocation ??
        await _hereLocationReader.getCurrentHereLocation(
          maxAge: const Duration(minutes: 5),
          timeout: const Duration(seconds: 30),
        );
    await _sendLocation(transportOrderId: transportOrderId, location: location);
  }

  Future<void> reportApproachRoute({
    required String transportOrderId,
    required int distanceMeters,
    required Duration duration,
  }) async {
    final location =
        _hereLocationReader.lastKnownHereLocation ??
        await _hereLocationReader.getCurrentHereLocation(
          maxAge: const Duration(minutes: 5),
          timeout: const Duration(seconds: 30),
        );
    final payload = _toPayload(location);
    payload['approachDistanceMeters'] = distanceMeters;
    payload['approachDurationSeconds'] = duration.inSeconds;
    await _api.sendLocation(
      transportOrderId: transportOrderId,
      payload: payload,
    );
  }

  Future<void> startPeriodicReporting({
    required String transportOrderId,
    Duration interval = const Duration(seconds: 10),
  }) async {
    if (_periodicTransportOrderId == transportOrderId &&
        _periodicTimer != null) {
      return _periodicSendInFlight ?? Future<void>.value();
    }

    stopPeriodicReporting();

    if (_odometerOrderId != transportOrderId) {
      _odometerOrderId = transportOrderId;
      _odometerMeters = await _db.getOrderOdometer(transportOrderId);
    }

    _periodicTransportOrderId = transportOrderId;
    _periodicTimer = Timer.periodic(interval, (_) {
      unawaited(_persistOdometer());
      unawaited(
        _sendPeriodicLocation(
          transportOrderId: transportOrderId,
          throwOnError: false,
        ),
      );
    });

    return _sendPeriodicLocation(
      transportOrderId: transportOrderId,
      throwOnError: true,
    );
  }

  void stopPeriodicReporting() {
    final orderId = _periodicTransportOrderId;
    if (orderId != null && _odometerMeters > 0) {
      unawaited(_db.saveOrderOdometer(orderId, _odometerMeters));
    }
    _periodicTimer?.cancel();
    _periodicTimer = null;
    _periodicTransportOrderId = null;
  }

  Future<void> _sendPeriodicLocation({
    required String transportOrderId,
    required bool throwOnError,
  }) {
    final inFlight = _periodicSendInFlight;
    if (inFlight != null) {
      if (throwOnError) return inFlight;
      return inFlight.catchError((_) {});
    }

    final future = _trySendPeriodicLocation(
      transportOrderId: transportOrderId,
      throwOnError: throwOnError,
    );
    _periodicSendInFlight = future;

    return future.whenComplete(() {
      if (identical(_periodicSendInFlight, future)) {
        _periodicSendInFlight = null;
      }
    });
  }

  Future<void> _trySendPeriodicLocation({
    required String transportOrderId,
    required bool throwOnError,
  }) async {
    try {
      if (_periodicTransportOrderId != transportOrderId) return;

      final location =
          _simulatedLocation ?? _hereLocationReader.lastKnownHereLocation;
      if (location == null) {
        throw const DriverHereLocationUnavailableException();
      }

      await _sendLocation(
        transportOrderId: transportOrderId,
        location: location,
      );
    } catch (_) {
      if (throwOnError) rethrow;
    }
  }

  Future<void> _sendLocation({
    required String transportOrderId,
    required here.Location location,
  }) async {
    final payload = _toPayload(location);

    try {
      await _api.sendLocation(
        transportOrderId: transportOrderId,
        payload: payload,
      );
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 403) {
        throw const DriverLocationReportingException(
          driverLocationForbiddenMessage,
        );
      }
      if (status == 409) {
        throw const DriverLocationReportingException(
          driverLocationInactiveOrderMessage,
        );
      }
      throw const DriverLocationReportingException(
        driverLocationReportFailedMessage,
      );
    } catch (_) {
      throw const DriverLocationReportingException(
        driverLocationReportFailedMessage,
      );
    }
  }

  Map<String, dynamic> _toPayload(here.Location location) {
    final recordedAt = location.time;
    if (recordedAt == null) {
      throw const DriverHereLocationUnavailableException();
    }

    final nav = _navProgress;
    return {
      'latitude': location.coordinates.latitude,
      'longitude': location.coordinates.longitude,
      if (_isFinite(location.horizontalAccuracyInMeters))
        'accuracyMeters': location.horizontalAccuracyInMeters,
      if (_isFinite(location.speedInMetersPerSecond))
        'speedMetersPerSecond': location.speedInMetersPerSecond,
      if (_isFinite(location.bearingInDegrees))
        'bearingDegrees': location.bearingInDegrees,
      if (nav != null) ...{
        'remainingDistanceMeters': nav.remainingDistanceMeters,
        'remainingDurationSeconds': nav.remainingDurationSeconds,
      },
      if (_odometerMeters > 0) 'traveledDistanceMeters': _odometerMeters,
      'recordedAt': recordedAt.toUtc().toIso8601String(),
      'source': 'HERE_SDK',
    };
  }

  bool _isFinite(double? value) => value != null && value.isFinite;
}
