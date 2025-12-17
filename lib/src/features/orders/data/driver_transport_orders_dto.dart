import '../domain/driver_transport_order.dart';
import '../domain/driver_transport_order_details.dart';

class DriverTransportOrderListItemDto {
  const DriverTransportOrderListItemDto({
    required this.id,
    required this.ztNumber,
    required this.status,
    required this.fromCountry,
    required this.toCountry,
    this.loadingDate,
  });

  final String id;
  final String ztNumber;
  final String status;
  final String fromCountry;
  final String toCountry;
  final DateTime? loadingDate;

  factory DriverTransportOrderListItemDto.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic v) {
      if (v == null) return null;
      if (v is String) return DateTime.tryParse(v);
      return null;
    }

    return DriverTransportOrderListItemDto(
      id: json['id'] as String,
      ztNumber: json['ztNumber'] as String,
      status: json['status'] as String,
      fromCountry: json['fromCountry'] as String,
      toCountry: json['toCountry'] as String,
      loadingDate: parseDate(json['loadingDate']),
    );
  }

  DriverTransportOrder toDomain() => DriverTransportOrder(
    id: id,
    ztNumber: ztNumber,
    status: status,
    fromCountry: fromCountry,
    toCountry: toCountry,
    loadingDate: loadingDate,
  );
}

class AssignDriverTransportOrderResponseDto {
  const AssignDriverTransportOrderResponseDto({
    required this.id,
    required this.ztNumber,
    required this.status,
  });

  final String id;
  final String ztNumber;
  final String status;

  factory AssignDriverTransportOrderResponseDto.fromJson(
    Map<String, dynamic> json,
  ) {
    return AssignDriverTransportOrderResponseDto(
      id: json['id'] as String,
      ztNumber: json['ztNumber'] as String,
      status: json['status'] as String,
    );
  }
}

class DriverTransportOrderDetailsDto {
  const DriverTransportOrderDetailsDto({
    required this.id,
    this.ztNumber,
    this.status,
    this.vehiclePlate,
    this.trailerPlate,
    this.clientName,
    this.fromCountry,
    this.toCountry,
    this.cargoWeightKg,
    this.loadingDate,
    this.cargoDescription,
    this.temperatureSensitive,
    this.notes,
  });

  final String id;
  final String? ztNumber;
  final String? status;
  final String? vehiclePlate;
  final String? trailerPlate;
  final String? clientName;
  final String? fromCountry;
  final String? toCountry;
  final int? cargoWeightKg;
  final DateTime? loadingDate;
  final String? cargoDescription;
  final bool? temperatureSensitive;
  final String? notes;

  factory DriverTransportOrderDetailsDto.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic v) {
      if (v == null) return null;
      if (v is String) return DateTime.tryParse(v);
      return null;
    }

    int? parseInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      if (v is num) return v.toInt();
      if (v is String) return int.tryParse(v);
      return null;
    }

    bool? parseBool(dynamic v) {
      if (v == null) return null;
      if (v is bool) return v;
      if (v is String) {
        final s = v.toLowerCase().trim();
        if (s == 'true') return true;
        if (s == 'false') return false;
      }
      return null;
    }

    return DriverTransportOrderDetailsDto(
      id: json['id'] as String,
      ztNumber: json['ztNumber'] as String?,
      status: json['status'] as String?,
      vehiclePlate: json['vehiclePlate'] as String?,
      trailerPlate: json['trailerPlate'] as String?,
      clientName: json['clientName'] as String?,
      fromCountry: json['fromCountry'] as String?,
      toCountry: json['toCountry'] as String?,
      cargoWeightKg: parseInt(json['cargoWeightKg']),
      loadingDate: parseDate(json['loadingDate']),
      cargoDescription: json['cargoDescription'] as String?,
      temperatureSensitive: parseBool(json['temperatureSensitive']),
      notes: json['notes'] as String?,
    );
  }

  DriverTransportOrderDetails toDomain() => DriverTransportOrderDetails(
    id: id,
    ztNumber: ztNumber,
    status: status,
    vehiclePlate: vehiclePlate,
    trailerPlate: trailerPlate,
    clientName: clientName,
    fromCountry: fromCountry,
    toCountry: toCountry,
    cargoWeightKg: cargoWeightKg,
    loadingDate: loadingDate,
    cargoDescription: cargoDescription,
    temperatureSensitive: temperatureSensitive,
    notes: notes,
  );
}
