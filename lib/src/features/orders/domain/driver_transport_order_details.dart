class DriverTransportOrderDetails {
  const DriverTransportOrderDetails({
    required this.id,
    this.ztNumber,
    this.status,
    this.vehiclePlate,
    this.trailerPlate,
    this.clientName,
    this.payerName,
    this.payerEmail,
    this.driverFirstName,
    this.driverLastName,
    this.driverPhone,
    this.fromCountry,
    this.fromAddress,
    this.toCountry,
    this.toAddress,
    this.cargoWeightKg,
    this.loadingDate,
    this.cargoDescription,
    this.temperatureSensitive,
    this.notes,
    this.routePoints = const [],
  });

  final String id;
  final String? ztNumber;
  final String? status;
  final String? vehiclePlate;
  final String? trailerPlate;
  final String? clientName;
  final String? payerName;
  final String? payerEmail;
  final String? driverFirstName;
  final String? driverLastName;
  final String? driverPhone;
  final String? fromCountry;
  final String? fromAddress;
  final String? toCountry;
  final String? toAddress;
  final int? cargoWeightKg;
  final DateTime? loadingDate;
  final String? cargoDescription;
  final bool? temperatureSensitive;
  final String? notes;
  final List<DriverTransportOrderRoutePoint> routePoints;
}

class DriverTransportOrderRoutePoint {
  const DriverTransportOrderRoutePoint({
    required this.id,
    required this.sequence,
    required this.type,
    this.source = 'DISPATCHER',
    this.isManual = true,
    this.label,
    this.address,
    required this.latitude,
    required this.longitude,
  });

  final String id;
  final int sequence;
  final String type;
  final String source;
  final bool isManual;
  final String? label;
  final String? address;
  final double latitude;
  final double longitude;
}
