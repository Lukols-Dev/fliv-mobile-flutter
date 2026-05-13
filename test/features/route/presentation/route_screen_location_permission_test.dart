import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:here_sdk/core.dart' as here;
import 'package:mobile/src/core/here/driver_here_location_service.dart';
import 'package:mobile/src/core/l10n/app_localizations.dart';
import 'package:mobile/src/core/location/location_permission_channel.dart';
import 'package:mobile/src/features/orders/application/current_driver_order_provider.dart';
import 'package:mobile/src/features/orders/application/driver_order_details_provider.dart';
import 'package:mobile/src/features/orders/domain/driver_transport_order.dart';
import 'package:mobile/src/features/orders/domain/driver_transport_order_details.dart';
import 'package:mobile/src/features/route/presentation/controllers/route_map_controller.dart';
import 'package:mobile/src/features/route/presentation/screens/route_screen.dart';

void main() {
  testWidgets('requests HERE location when map opens without an order', (
    tester,
  ) async {
    final locationService = _FakeDriverHereLocationService();

    await _pumpRouteScreen(
      tester,
      locationService: locationService,
      currentOrder: null,
    );

    expect(locationService.prepareCalls, 1);
    expect(find.byKey(_mapLayerKey), findsOneWidget);
  });

  testWidgets('requests HERE location when map opens with an order', (
    tester,
  ) async {
    final locationService = _FakeDriverHereLocationService();
    const order = DriverTransportOrder(
      id: 'order-1',
      ztNumber: 'ZT-1',
      status: 'PENDING',
      fromCountry: 'PL',
      toCountry: 'DE',
      loadingDate: null,
    );

    await _pumpRouteScreen(
      tester,
      locationService: locationService,
      currentOrder: order,
      orderDetails: const DriverTransportOrderDetails(id: 'order-1'),
    );

    expect(locationService.prepareCalls, 1);
    expect(find.byKey(_mapLayerKey), findsOneWidget);
    expect(find.text('Zlecenie #ZT-1'), findsOneWidget);
  });

  testWidgets('does not render map layer before location access is granted', (
    tester,
  ) async {
    final locationService = _FakeDriverHereLocationService(
      prepareError: const DriverHereLocationPermissionException(),
    );

    await _pumpRouteScreen(
      tester,
      locationService: locationService,
      currentOrder: null,
    );

    expect(locationService.prepareCalls, 1);
    expect(find.text(driverLocationPermissionMessage), findsWidgets);
    expect(find.byKey(_mapLayerKey), findsNothing);
  });
}

const _mapLayerKey = Key('route-map-layer-placeholder');

Future<void> _pumpRouteScreen(
  WidgetTester tester, {
  required _FakeDriverHereLocationService locationService,
  required DriverTransportOrder? currentOrder,
  DriverTransportOrderDetails? orderDetails,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        driverHereLocationServiceProvider.overrideWithValue(locationService),
        routeMapLayerBuilderProvider.overrideWithValue(_fakeRouteMapLayer),
        currentDriverOrderProvider.overrideWith((ref) async => currentOrder),
        if (currentOrder != null)
          driverOrderDetailsProvider(currentOrder.id).overrideWith(
            (ref) async =>
                orderDetails ??
                DriverTransportOrderDetails(id: currentOrder.id),
          ),
      ],
      child: const MaterialApp(
        locale: Locale('pl'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: RouteScreen(),
      ),
    ),
  );

  await tester.pump();
  await tester.pump();
  await tester.pump();
}

Widget _fakeRouteMapLayer({
  required RouteMapController controller,
  required VoidCallback onBack,
  required double bottomPaddingForFab,
  ValueNotifier<double>? sheetHeightNotifier,
}) {
  return const SizedBox(key: _mapLayerKey);
}

class _FakeDriverHereLocationService extends DriverHereLocationService {
  _FakeDriverHereLocationService({this.prepareError})
    : super(permissionChannel: const LocationPermissionChannel());

  final Object? prepareError;
  int prepareCalls = 0;

  @override
  Future<void> prepare() async {
    prepareCalls++;
    final error = prepareError;
    if (error != null) throw error;
  }

  @override
  Future<here.Location> getCurrentHereLocation({
    Duration maxAge = const Duration(seconds: 10),
    Duration timeout = const Duration(seconds: 10),
  }) async {
    return here.Location.withCoordinates(here.GeoCoordinates(52.2297, 21.0122))
      ..time = DateTime.utc(2026, 5, 12, 10);
  }

  @override
  Stream<here.Location> get locationStream =>
      const Stream<here.Location>.empty();

  @override
  void stop() {}

  @override
  void dispose() {}
}
