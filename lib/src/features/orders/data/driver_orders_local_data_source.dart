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
      fromCountry: row.fromCountry,
      toCountry: row.toCountry,
      cargoWeightKg: row.cargoWeightKg,
      loadingDate: row.loadingDate,
      cargoDescription: row.cargoDescription,
      temperatureSensitive: row.temperatureSensitive,
      notes: row.notes,
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
      fromCountry: v(d.fromCountry),
      toCountry: v(d.toCountry),
      cargoWeightKg: v(d.cargoWeightKg),
      loadingDate: v(d.loadingDate),
      cargoDescription: v(d.cargoDescription),
      temperatureSensitive: v(d.temperatureSensitive),
      notes: v(d.notes),
    );
  }
}
