import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:here_sdk/core.dart' as here;
import 'package:mobile/src/core/here/driver_here_location_service.dart';
import 'package:mobile/src/features/route/data/driver_location_reporting_service.dart';

void main() {
  test('maps HERE location into backend payload', () async {
    final recordedAt = DateTime.utc(2026, 5, 12, 10);
    final reader = _FakeHereLocationReader(
      location: _location(recordedAt: recordedAt),
    );
    final client = _FakeReportingClient();
    final service = DriverLocationReportingService(
      hereLocationReader: reader,
      api: client,
    );

    await service.reportCurrentLocation(transportOrderId: 'order-1');

    expect(client.calls, hasLength(1));
    expect(client.calls.single.transportOrderId, 'order-1');
    expect(client.calls.single.payload, {
      'latitude': 52.2297,
      'longitude': 21.0122,
      'accuracyMeters': 12.0,
      'speedMetersPerSecond': 4.5,
      'bearingDegrees': 91.0,
      'recordedAt': '2026-05-12T10:00:00.000Z',
      'source': 'HERE_SDK',
    });
  });

  test('does not send when HERE service cannot provide a fresh location', () async {
    final reader = _FakeHereLocationReader(
      error: const DriverHereLocationUnavailableException(),
    );
    final client = _FakeReportingClient();
    final service = DriverLocationReportingService(
      hereLocationReader: reader,
      api: client,
    );

    await expectLater(
      service.reportCurrentLocation(transportOrderId: 'order-1'),
      throwsA(isA<DriverHereLocationUnavailableException>()),
    );

    expect(client.calls, isEmpty);
  });

  test('coalesces duplicate requests for the same order', () async {
    final reader = _FakeHereLocationReader(location: _location());
    final client = _FakeReportingClient(blockSend: true);
    final service = DriverLocationReportingService(
      hereLocationReader: reader,
      api: client,
    );

    final first = service.reportCurrentLocation(transportOrderId: 'order-1');
    final second = service.reportCurrentLocation(transportOrderId: 'order-1');

    expect(identical(first, second), isTrue);
    expect(reader.callCount, 1);

    client.completeSend();
    await first;

    expect(client.calls, hasLength(1));
  });

  test('periodic reporting sends immediately and every interval', () {
    fakeAsync((async) {
      final reader = _FakeHereLocationReader(freshLocation: _location());
      final client = _FakeReportingClient();
      final service = DriverLocationReportingService(
        hereLocationReader: reader,
        api: client,
      );

      unawaited(
        service.startPeriodicReporting(
          transportOrderId: 'order-1',
          interval: const Duration(seconds: 10),
        ),
      );
      async.flushMicrotasks();

      expect(client.calls, hasLength(1));

      async.elapse(const Duration(seconds: 10));
      async.flushMicrotasks();

      expect(client.calls, hasLength(2));
      service.stopPeriodicReporting();
    });
  });

  test('periodic reporting skips stale or missing HERE fixes', () async {
    final reader = _FakeHereLocationReader();
    final client = _FakeReportingClient();
    final service = DriverLocationReportingService(
      hereLocationReader: reader,
      api: client,
    );

    await expectLater(
      service.startPeriodicReporting(
        transportOrderId: 'order-1',
        interval: const Duration(seconds: 10),
      ),
      throwsA(isA<DriverHereLocationUnavailableException>()),
    );
    service.stopPeriodicReporting();

    expect(client.calls, isEmpty);
  });

  test('periodic reporting does not create duplicate loops', () {
    fakeAsync((async) {
      final reader = _FakeHereLocationReader(freshLocation: _location());
      final client = _FakeReportingClient();
      final service = DriverLocationReportingService(
        hereLocationReader: reader,
        api: client,
      );

      unawaited(
        service.startPeriodicReporting(
          transportOrderId: 'order-1',
          interval: const Duration(seconds: 10),
        ),
      );
      async.flushMicrotasks();

      unawaited(
        service.startPeriodicReporting(
          transportOrderId: 'order-1',
          interval: const Duration(seconds: 10),
        ),
      );
      async.flushMicrotasks();

      expect(client.calls, hasLength(1));

      async.elapse(const Duration(seconds: 10));
      async.flushMicrotasks();

      expect(client.calls, hasLength(2));
      service.stopPeriodicReporting();
    });
  });

  test('stopPeriodicReporting stops future sends', () {
    fakeAsync((async) {
      final reader = _FakeHereLocationReader(freshLocation: _location());
      final client = _FakeReportingClient();
      final service = DriverLocationReportingService(
        hereLocationReader: reader,
        api: client,
      );

      unawaited(
        service.startPeriodicReporting(
          transportOrderId: 'order-1',
          interval: const Duration(seconds: 10),
        ),
      );
      async.flushMicrotasks();
      service.stopPeriodicReporting();

      async.elapse(const Duration(seconds: 10));
      async.flushMicrotasks();

      expect(client.calls, hasLength(1));
    });
  });

  test('backend error does not stop periodic reporting loop', () {
    fakeAsync((async) {
      final reader = _FakeHereLocationReader(freshLocation: _location());
      final client = _FakeReportingClient(failuresRemaining: 1);
      final service = DriverLocationReportingService(
        hereLocationReader: reader,
        api: client,
      );

      unawaited(
        service
            .startPeriodicReporting(
              transportOrderId: 'order-1',
              interval: const Duration(seconds: 10),
            )
            .catchError((_) {}),
      );
      async.flushMicrotasks();

      expect(client.calls, hasLength(1));

      async.elapse(const Duration(seconds: 10));
      async.flushMicrotasks();

      expect(client.calls, hasLength(2));
      service.stopPeriodicReporting();
    });
  });

  test(
      'reportApproachRoute sends location with approach distance and duration',
      () async {
    final recordedAt = DateTime.utc(2026, 5, 12, 10);
    final loc = _location(recordedAt: recordedAt);
    final reader = _FakeHereLocationReader(knownLocation: loc);
    final client = _FakeReportingClient();
    final service = DriverLocationReportingService(
      hereLocationReader: reader,
      api: client,
    );

    await service.reportApproachRoute(
      transportOrderId: 'order-1',
      distanceMeters: 15200,
      duration: const Duration(seconds: 900),
    );

    expect(client.calls, hasLength(1));
    expect(client.calls.single.transportOrderId, 'order-1');
    expect(client.calls.single.payload['approachDistanceMeters'], 15200);
    expect(client.calls.single.payload['approachDurationSeconds'], 900);
    expect(client.calls.single.payload['latitude'], 52.2297);
    expect(client.calls.single.payload['source'], 'HERE_SDK');
    expect(reader.callCount, 0); // użyto lastKnownHereLocation, nie stream
  });

  test(
      'reportApproachRoute falls back to getCurrentHereLocation when no cached location',
      () async {
    final loc = _location();
    final reader = _FakeHereLocationReader(location: loc);
    final client = _FakeReportingClient();
    final service = DriverLocationReportingService(
      hereLocationReader: reader,
      api: client,
    );

    await service.reportApproachRoute(
      transportOrderId: 'order-2',
      distanceMeters: 3000,
      duration: const Duration(seconds: 300),
    );

    expect(client.calls, hasLength(1));
    expect(client.calls.single.payload['approachDistanceMeters'], 3000);
    expect(reader.callCount, 1); // musiał użyć getCurrentHereLocation
  });
}

here.Location _location({DateTime? recordedAt}) {
  return here.Location.withCoordinates(here.GeoCoordinates(52.2297, 21.0122))
    ..time = recordedAt ?? DateTime.utc(2026, 5, 12, 10)
    ..horizontalAccuracyInMeters = 12
    ..speedInMetersPerSecond = 4.5
    ..bearingInDegrees = 91;
}

class _FakeHereLocationReader implements DriverHereLocationReader {
  _FakeHereLocationReader({
    this.location,
    this.freshLocation,
    this.knownLocation,
    this.error,
  });

  final here.Location? location;
  final here.Location? freshLocation;
  final here.Location? knownLocation;
  final Object? error;
  int callCount = 0;

  @override
  here.Location? get lastKnownHereLocation => knownLocation;

  @override
  here.Location? getLastFreshHereLocation({
    Duration maxAge = const Duration(seconds: 10),
  }) {
    return freshLocation;
  }

  @override
  Future<here.Location> getCurrentHereLocation({
    Duration maxAge = const Duration(seconds: 10),
    Duration timeout = const Duration(seconds: 10),
  }) async {
    callCount++;
    final error = this.error;
    if (error != null) throw error;
    return location!;
  }
}

class _ReportCall {
  const _ReportCall({
    required this.transportOrderId,
    required this.payload,
  });

  final String transportOrderId;
  final Map<String, dynamic> payload;
}

class _FakeReportingClient implements DriverLocationReportingClient {
  _FakeReportingClient({
    this.blockSend = false,
    this.failuresRemaining = 0,
  });

  final bool blockSend;
  int failuresRemaining;
  final calls = <_ReportCall>[];
  final _sendCompleter = Completer<void>();

  @override
  Future<void> sendLocation({
    required String transportOrderId,
    required Map<String, dynamic> payload,
  }) async {
    calls.add(_ReportCall(transportOrderId: transportOrderId, payload: payload));
    if (failuresRemaining > 0) {
      failuresRemaining--;
      throw Exception('Backend failure');
    }
    if (blockSend) {
      await _sendCompleter.future;
    }
  }

  void completeSend() {
    if (!_sendCompleter.isCompleted) {
      _sendCompleter.complete();
    }
  }
}
