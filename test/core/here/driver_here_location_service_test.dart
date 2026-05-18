import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/src/core/here/driver_here_location_service.dart';
import 'package:mobile/src/core/location/location_permission_channel.dart';

void main() {
  test(
    'throws deniedForever permission status before starting HERE engine',
    () async {
      final service = DriverHereLocationService(
        permissionChannel: _FakePermissionChannel(
          checkStatus: AppLocationPermissionStatus.deniedForever,
        ),
      );

      await expectLater(
        service.prepare(),
        throwsA(
          isA<DriverHereLocationPermissionException>()
              .having(
                (e) => e.status,
                'status',
                AppLocationPermissionStatus.deniedForever,
              )
              .having(
                (e) => e.message,
                'message',
                driverLocationPermissionDeniedForeverMessage,
              ),
        ),
      );
    },
  );

  test(
    'throws serviceDisabled permission status before starting HERE engine',
    () async {
      final service = DriverHereLocationService(
        permissionChannel: _FakePermissionChannel(
          checkStatus: AppLocationPermissionStatus.serviceDisabled,
        ),
      );

      await expectLater(
        service.prepare(),
        throwsA(
          isA<DriverHereLocationPermissionException>()
              .having(
                (e) => e.status,
                'status',
                AppLocationPermissionStatus.serviceDisabled,
              )
              .having(
                (e) => e.message,
                'message',
                driverLocationServiceDisabledMessage,
              ),
        ),
      );
    },
  );

  test('requests permission when initial status is denied', () async {
    final permissionChannel = _FakePermissionChannel(
      checkStatus: AppLocationPermissionStatus.denied,
      requestStatus: AppLocationPermissionStatus.deniedForever,
    );
    final service = DriverHereLocationService(
      permissionChannel: permissionChannel,
    );

    await expectLater(
      service.prepare(),
      throwsA(
        isA<DriverHereLocationPermissionException>().having(
          (e) => e.status,
          'status',
          AppLocationPermissionStatus.deniedForever,
        ),
      ),
    );

    expect(permissionChannel.requestCalls, 1);
  });
}

class _FakePermissionChannel extends LocationPermissionChannel {
  _FakePermissionChannel({
    required this.checkStatus,
    this.requestStatus,
  });

  final AppLocationPermissionStatus checkStatus;
  final AppLocationPermissionStatus? requestStatus;
  int requestCalls = 0;

  @override
  Future<AppLocationPermissionStatus> check() async => checkStatus;

  @override
  Future<AppLocationPermissionStatus> request() async {
    requestCalls++;
    return requestStatus ?? checkStatus;
  }
}
