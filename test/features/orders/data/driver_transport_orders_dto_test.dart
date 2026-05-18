import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/src/features/orders/data/driver_transport_orders_dto.dart';

void main() {
  group('DriverTransportOrderDetailsDto', () {
    test('parses routePlan and maps it to domain', () {
      final dto = DriverTransportOrderDetailsDto.fromJson({
        'id': 'order-1',
        'routePoints': [
          {
            'id': 'point-2',
            'sequence': 2,
            'type': 'UNLOADING',
            'latitude': '50.2',
            'longitude': '20.2',
          },
          {
            'id': 'point-1',
            'sequence': 1,
            'type': 'LOADING',
            'latitude': 50.1,
            'longitude': 20.1,
          },
        ],
        'routePlan': {
          'routingProfile': {
            'transportMode': 'truck',
            'routingMode': 'short',
            'trafficMode': 'disabled',
            'avoidTolls': true,
            'avoidFerries': false,
            'avoidMotorways': true,
          },
          'vehicleSpec': {
            'heightCm': '390',
            'widthCm': 255,
            'lengthCm': 1360.5,
            'currentWeightKg': 18000,
            'grossWeightKg': 40000,
            'weightPerAxleKg': 9000,
            'axleCount': 5,
            'trailerCount': 1,
            'hazardousGoods': ['flammable', 'harmfulToWater'],
          },
          'polyline': 'BFoz5xJ67i1B1B7PzIhaxL7Y',
          'distanceMeters': '12345',
          'durationSeconds': 1800.7,
          'calculationHash': 'hash-1',
          'calculatedAt': '2026-05-12T10:15:30.000Z',
        },
      });

      final domain = dto.toDomain();

      expect(domain.routePoints.map((p) => p.id), ['point-1', 'point-2']);
      expect(domain.routePlan?.polyline, 'BFoz5xJ67i1B1B7PzIhaxL7Y');
      expect(domain.routePlan?.distanceMeters, 12345);
      expect(domain.routePlan?.durationSeconds, 1800);
      expect(domain.routePlan?.calculationHash, 'hash-1');
      expect(domain.routePlan?.routingProfile.transportMode, 'truck');
      expect(domain.routePlan?.routingProfile.routingMode, 'short');
      expect(domain.routePlan?.routingProfile.trafficMode, 'disabled');
      expect(domain.routePlan?.routingProfile.avoidTolls, isTrue);
      expect(domain.routePlan?.routingProfile.avoidMotorways, isTrue);
      expect(domain.routePlan?.vehicleSpec?.heightCm, 390);
      expect(domain.routePlan?.vehicleSpec?.widthCm, 255);
      expect(domain.routePlan?.vehicleSpec?.lengthCm, 1360);
      expect(domain.routePlan?.vehicleSpec?.currentWeightKg, 18000);
      expect(domain.routePlan?.vehicleSpec?.grossWeightKg, 40000);
      expect(domain.routePlan?.vehicleSpec?.weightPerAxleKg, 9000);
      expect(domain.routePlan?.vehicleSpec?.axleCount, 5);
      expect(domain.routePlan?.vehicleSpec?.trailerCount, 1);
      expect(domain.routePlan?.vehicleSpec?.hazardousGoods, [
        'flammable',
        'harmfulToWater',
      ]);
      expect(
        domain.routePlan?.calculatedAt,
        DateTime.parse('2026-05-12T10:15:30.000Z'),
      );
    });

    test('maps null routePlan to null', () {
      final dto = DriverTransportOrderDetailsDto.fromJson({
        'id': 'order-1',
        'routePoints': const [],
        'routePlan': null,
      });

      expect(dto.toDomain().routePlan, isNull);
    });
  });
}
