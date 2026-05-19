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
    this.routePlan,
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
  final DriverTransportOrderRoutePlan? routePlan;
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
    this.arrivedAt,
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
  final DateTime? arrivedAt;
}

class DriverTransportOrderRoutePlan {
  const DriverTransportOrderRoutePlan({
    this.routingProfile = const DriverRouteRoutingProfile(),
    this.vehicleSpec,
    required this.polyline,
    required this.distanceMeters,
    required this.durationSeconds,
    this.calculationHash,
    this.calculatedAt,
  });

  final DriverRouteRoutingProfile routingProfile;
  final DriverRouteVehicleSpec? vehicleSpec;
  final String polyline;
  final int distanceMeters;
  final int durationSeconds;
  final String? calculationHash;
  final DateTime? calculatedAt;
}

class DriverRouteRoutingProfile {
  const DriverRouteRoutingProfile({
    this.mode,
    this.transportMode = 'truck',
    this.routingMode = 'fast',
    this.trafficMode = 'default',
    this.avoidTolls = false,
    this.avoidFerries = false,
    this.avoidMotorways = false,
  });

  final String? mode;
  final String transportMode;
  final String routingMode;
  final String trafficMode;
  final bool avoidTolls;
  final bool avoidFerries;
  final bool avoidMotorways;
}

class DriverRouteVehicleSpec {
  const DriverRouteVehicleSpec({
    this.heightCm,
    this.widthCm,
    this.lengthCm,
    this.currentWeightKg,
    this.grossWeightKg,
    this.weightPerAxleKg,
    this.axleCount,
    this.trailerCount,
    this.hazardousGoods = const [],
  });

  final int? heightCm;
  final int? widthCm;
  final int? lengthCm;
  final int? currentWeightKg;
  final int? grossWeightKg;
  final int? weightPerAxleKg;
  final int? axleCount;
  final int? trailerCount;
  final List<String> hazardousGoods;
}
