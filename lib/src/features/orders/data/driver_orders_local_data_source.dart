import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/app_database_provider.dart';
import '../domain/driver_transport_order.dart';
import '../domain/driver_transport_order_details.dart';

final driverOrdersLocalDataSourceProvider =
    Provider<DriverOrdersLocalDataSource>((ref) {
      return DriverOrdersLocalDataSource(ref.read(appDatabaseProvider));
    });

class DriverOrdersLocalDataSource {
  DriverOrdersLocalDataSource(this._db);
  final AppDatabase _db;

  static const _currentKey = 'current';

  // ---- Current (latest) ----

  Stream<DriverTransportOrder?> watchCurrent() {
    return _db.watchCurrentOrder().map(_currentRowToDomain);
  }

  Future<DriverTransportOrder?> getCurrent() async {
    final row = await _db.getCurrentOrder();
    return _currentRowToDomain(row);
  }

  Future<void> upsertCurrent(DriverTransportOrder order) {
    return _db.upsertCurrentOrder(_currentDomainToCompanion(order));
  }

  Future<void> clearCurrent() => _db.clearCurrentOrder();

  // ---- Details ----

  Stream<DriverTransportOrderDetails?> watchDetails(String id) {
    return _db.watchOrderDetails(id).map(_detailsRowToDomain);
  }

  Future<DriverTransportOrderDetails?> getDetails(String id) async {
    final row = await _db.getOrderDetails(id);
    return _detailsRowToDomain(row);
  }

  Future<void> upsertDetails(DriverTransportOrderDetails d) {
    return _db.upsertOrderDetails(_detailsDomainToCompanion(d));
  }

  Future<void> clearAll() => _db.clearAllOrders();

  // ---- Mappers ----

  DriverTransportOrder? _currentRowToDomain(DriverCurrentOrderTableData? row) {
    if (row == null) return null;
    return DriverTransportOrder(
      id: row.id,
      ztNumber: row.ztNumber,
      status: row.status,
      fromCountry: row.fromCountry ?? '',
      toCountry: row.toCountry ?? '',
      loadingDate: row.loadingDate,
    );
  }

  DriverCurrentOrderTableCompanion _currentDomainToCompanion(
    DriverTransportOrder o,
  ) {
    return DriverCurrentOrderTableCompanion.insert(
      key: _currentKey,
      id: o.id,
      ztNumber: o.ztNumber,
      status: o.status,
      fromCountry: o.fromCountry.trim().isEmpty
          ? const Value.absent()
          : Value(o.fromCountry),
      toCountry: o.toCountry.trim().isEmpty
          ? const Value.absent()
          : Value(o.toCountry),
      loadingDate: o.loadingDate == null
          ? const Value.absent()
          : Value(o.loadingDate!),
    );
  }

  DriverTransportOrderDetails? _detailsRowToDomain(
    DriverOrderDetailsTableData? row,
  ) {
    if (row == null) return null;
    return DriverTransportOrderDetails(
      id: row.id,
      ztNumber: row.ztNumber,
      status: row.status,
      vehiclePlate: row.vehiclePlate,
      trailerPlate: row.trailerPlate,
      clientName: row.clientName,
      payerName: row.payerName,
      payerEmail: row.payerEmail,
      fromCountry: row.fromCountry,
      fromAddress: row.fromAddress,
      toCountry: row.toCountry,
      toAddress: row.toAddress,
      cargoWeightKg: row.cargoWeightKg,
      loadingDate: row.loadingDate,
      cargoDescription: row.cargoDescription,
      temperatureSensitive: row.temperatureSensitive,
      notes: row.notes,
      routePoints: _decodeRoutePoints(row.routePointsJson),
    );
  }

  DriverOrderDetailsTableCompanion _detailsDomainToCompanion(
    DriverTransportOrderDetails d,
  ) {
    Value<T> v<T>(T? x) => x == null ? const Value.absent() : Value(x);

    return DriverOrderDetailsTableCompanion.insert(
      id: d.id,
      ztNumber: v(d.ztNumber),
      status: v(d.status),
      vehiclePlate: v(d.vehiclePlate),
      trailerPlate: v(d.trailerPlate),
      clientName: v(d.clientName),
      payerName: v(d.payerName),
      payerEmail: v(d.payerEmail),
      fromCountry: v(d.fromCountry),
      fromAddress: v(d.fromAddress),
      toCountry: v(d.toCountry),
      toAddress: v(d.toAddress),
      cargoWeightKg: v(d.cargoWeightKg),
      loadingDate: v(d.loadingDate),
      cargoDescription: v(d.cargoDescription),
      temperatureSensitive: v(d.temperatureSensitive),
      notes: v(d.notes),
      routePointsJson: d.routePoints.isEmpty
          ? const Value(null)
          : Value(_encodeRoutePoints(d.routePoints)),
    );
  }

  List<DriverTransportOrderRoutePoint> _decodeRoutePoints(String? jsonText) {
    if (jsonText == null || jsonText.trim().isEmpty) return const [];

    final Object? decoded;
    try {
      decoded = jsonDecode(jsonText);
    } catch (_) {
      return const [];
    }

    if (decoded is! List) return const [];

    int parseInt(dynamic v) {
      if (v is int) return v;
      if (v is num) return v.toInt();
      if (v is String) return int.tryParse(v) ?? 0;
      return 0;
    }

    double parseDouble(dynamic v) {
      if (v is double) return v;
      if (v is num) return v.toDouble();
      if (v is String) return double.tryParse(v) ?? 0;
      return 0;
    }

    bool parseBool(dynamic v) {
      if (v is bool) return v;
      if (v is String) {
        final normalized = v.toLowerCase().trim();
        if (normalized == 'true') return true;
        if (normalized == 'false') return false;
      }
      return true;
    }

    return decoded
        .whereType<Map>()
        .map(
          (item) => DriverTransportOrderRoutePoint(
            id: item['id'] as String? ?? '',
            sequence: parseInt(item['sequence']),
            type: item['type'] as String? ?? 'VIA',
            source: item['source'] as String? ?? 'DISPATCHER',
            isManual: parseBool(item['isManual']),
            label: item['label'] as String?,
            address: item['address'] as String?,
            latitude: parseDouble(item['latitude']),
            longitude: parseDouble(item['longitude']),
          ),
        )
        .toList()
      ..sort((a, b) => a.sequence.compareTo(b.sequence));
  }

  String _encodeRoutePoints(List<DriverTransportOrderRoutePoint> points) {
    return jsonEncode(
      points
          .map(
            (point) => {
              'id': point.id,
              'sequence': point.sequence,
              'type': point.type,
              'source': point.source,
              'isManual': point.isManual,
              'label': point.label,
              'address': point.address,
              'latitude': point.latitude,
              'longitude': point.longitude,
            },
          )
          .toList(),
    );
  }
}
