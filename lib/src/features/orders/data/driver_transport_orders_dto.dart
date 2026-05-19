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
  final List<DriverTransportOrderRoutePointDto> routePoints;
  final DriverTransportOrderRoutePlanDto? routePlan;

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

    final routePointsJson = json['routePoints'] as List<dynamic>? ?? [];
    final routePlanJson = json['routePlan'];

    return DriverTransportOrderDetailsDto(
      id: json['id'] as String,
      ztNumber: json['ztNumber'] as String?,
      status: json['status'] as String?,
      vehiclePlate: json['vehiclePlate'] as String?,
      trailerPlate: json['trailerPlate'] as String?,
      clientName: json['clientName'] as String?,
      payerName: json['payerName'] as String?,
      payerEmail: json['payerEmail'] as String?,
      driverFirstName: json['driverFirstName'] as String?,
      driverLastName: json['driverLastName'] as String?,
      driverPhone: json['driverPhone'] as String?,
      fromCountry: json['fromCountry'] as String?,
      fromAddress: json['fromAddress'] as String?,
      toCountry: json['toCountry'] as String?,
      toAddress: json['toAddress'] as String?,
      cargoWeightKg: parseInt(json['cargoWeightKg']),
      loadingDate: parseDate(json['loadingDate']),
      cargoDescription: json['cargoDescription'] as String?,
      temperatureSensitive: parseBool(json['temperatureSensitive']),
      notes: json['notes'] as String?,
      routePoints: routePointsJson
          .whereType<Map>()
          .map((m) => DriverTransportOrderRoutePointDto.fromJson(m.cast()))
          .toList()
        ..sort((a, b) => a.sequence.compareTo(b.sequence)),
      routePlan: routePlanJson is Map
          ? DriverTransportOrderRoutePlanDto.fromJson(routePlanJson.cast())
          : null,
    );
  }

  DriverTransportOrderDetails toDomain() => DriverTransportOrderDetails(
    id: id,
    ztNumber: ztNumber,
    status: status,
    vehiclePlate: vehiclePlate,
    trailerPlate: trailerPlate,
    clientName: clientName,
    payerName: payerName,
    payerEmail: payerEmail,
    driverFirstName: driverFirstName,
    driverLastName: driverLastName,
    driverPhone: driverPhone,
    fromCountry: fromCountry,
    fromAddress: fromAddress,
    toCountry: toCountry,
    toAddress: toAddress,
    cargoWeightKg: cargoWeightKg,
    loadingDate: loadingDate,
    cargoDescription: cargoDescription,
    temperatureSensitive: temperatureSensitive,
    notes: notes,
    routePoints: routePoints.map((p) => p.toDomain()).toList(),
    routePlan: routePlan?.toDomain(),
  );
}

class DriverTransportOrderRoutePlanDto {
  const DriverTransportOrderRoutePlanDto({
    this.routingProfile = const DriverRouteRoutingProfileDto(),
    this.vehicleSpec,
    required this.polyline,
    required this.distanceMeters,
    required this.durationSeconds,
    this.calculationHash,
    this.calculatedAt,
  });

  final DriverRouteRoutingProfileDto routingProfile;
  final DriverRouteVehicleSpecDto? vehicleSpec;
  final String polyline;
  final int distanceMeters;
  final int durationSeconds;
  final String? calculationHash;
  final DateTime? calculatedAt;

  factory DriverTransportOrderRoutePlanDto.fromJson(
    Map<String, dynamic> json,
  ) {
    int parseInt(dynamic v) {
      if (v is int) return v;
      if (v is num) return v.toInt();
      if (v is String) return int.tryParse(v) ?? 0;
      return 0;
    }

    DateTime? parseDate(dynamic v) {
      if (v == null) return null;
      if (v is String) return DateTime.tryParse(v);
      return null;
    }

    final routingProfileJson = json['routingProfile'];
    final vehicleSpecJson = json['vehicleSpec'];

    return DriverTransportOrderRoutePlanDto(
      routingProfile: routingProfileJson is Map
          ? DriverRouteRoutingProfileDto.fromJson(routingProfileJson.cast())
          : const DriverRouteRoutingProfileDto(),
      vehicleSpec: vehicleSpecJson is Map
          ? DriverRouteVehicleSpecDto.fromJson(vehicleSpecJson.cast())
          : null,
      polyline: json['polyline'] as String? ?? '',
      distanceMeters: parseInt(json['distanceMeters']),
      durationSeconds: parseInt(json['durationSeconds']),
      calculationHash: json['calculationHash'] as String?,
      calculatedAt: parseDate(json['calculatedAt']),
    );
  }

  DriverTransportOrderRoutePlan toDomain() => DriverTransportOrderRoutePlan(
    routingProfile: routingProfile.toDomain(),
    vehicleSpec: vehicleSpec?.toDomain(),
    polyline: polyline,
    distanceMeters: distanceMeters,
    durationSeconds: durationSeconds,
    calculationHash: calculationHash,
    calculatedAt: calculatedAt,
  );
}

class DriverRouteRoutingProfileDto {
  const DriverRouteRoutingProfileDto({
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

  factory DriverRouteRoutingProfileDto.fromJson(Map<String, dynamic> json) {
    bool parseBool(dynamic v) {
      if (v is bool) return v;
      if (v is String) {
        final s = v.toLowerCase().trim();
        if (s == 'true') return true;
        if (s == 'false') return false;
      }
      return false;
    }

    String parseString(dynamic v, String fallback) {
      if (v is String && v.trim().isNotEmpty) return v.trim();
      return fallback;
    }

    return DriverRouteRoutingProfileDto(
      mode: json['mode'] as String?,
      transportMode: parseString(json['transportMode'], 'truck'),
      routingMode: parseString(json['routingMode'], 'fast'),
      trafficMode: parseString(json['trafficMode'], 'default'),
      avoidTolls: parseBool(json['avoidTolls']),
      avoidFerries: parseBool(json['avoidFerries']),
      avoidMotorways: parseBool(json['avoidMotorways']),
    );
  }

  DriverRouteRoutingProfile toDomain() => DriverRouteRoutingProfile(
    mode: mode,
    transportMode: transportMode,
    routingMode: routingMode,
    trafficMode: trafficMode,
    avoidTolls: avoidTolls,
    avoidFerries: avoidFerries,
    avoidMotorways: avoidMotorways,
  );
}

class DriverRouteVehicleSpecDto {
  const DriverRouteVehicleSpecDto({
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

  factory DriverRouteVehicleSpecDto.fromJson(Map<String, dynamic> json) {
    int? parseInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      if (v is num) return v.toInt();
      if (v is String) return int.tryParse(v);
      return null;
    }

    final hazardousGoodsJson = json['hazardousGoods'];

    return DriverRouteVehicleSpecDto(
      heightCm: parseInt(json['heightCm']),
      widthCm: parseInt(json['widthCm']),
      lengthCm: parseInt(json['lengthCm']),
      currentWeightKg: parseInt(json['currentWeightKg']),
      grossWeightKg: parseInt(json['grossWeightKg']),
      weightPerAxleKg: parseInt(json['weightPerAxleKg']),
      axleCount: parseInt(json['axleCount']),
      trailerCount: parseInt(json['trailerCount']),
      hazardousGoods: hazardousGoodsJson is List
          ? hazardousGoodsJson.whereType<String>().toList(growable: false)
          : const [],
    );
  }

  DriverRouteVehicleSpec toDomain() => DriverRouteVehicleSpec(
    heightCm: heightCm,
    widthCm: widthCm,
    lengthCm: lengthCm,
    currentWeightKg: currentWeightKg,
    grossWeightKg: grossWeightKg,
    weightPerAxleKg: weightPerAxleKg,
    axleCount: axleCount,
    trailerCount: trailerCount,
    hazardousGoods: hazardousGoods,
  );
}

class DriverTransportOrderRoutePointDto {
  const DriverTransportOrderRoutePointDto({
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

  factory DriverTransportOrderRoutePointDto.fromJson(
    Map<String, dynamic> json,
  ) {
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

    DateTime? parseDate(dynamic v) {
      if (v == null) return null;
      if (v is String) return DateTime.tryParse(v);
      return null;
    }

    return DriverTransportOrderRoutePointDto(
      id: json['id'] as String? ?? '',
      sequence: parseInt(json['sequence']),
      type: json['type'] as String? ?? 'VIA',
      source: json['source'] as String? ?? 'DISPATCHER',
      isManual: parseBool(json['isManual']),
      label: json['label'] as String?,
      address: json['address'] as String?,
      latitude: parseDouble(json['latitude']),
      longitude: parseDouble(json['longitude']),
      arrivedAt: parseDate(json['arrivedAt']),
    );
  }

  DriverTransportOrderRoutePoint toDomain() =>
      DriverTransportOrderRoutePoint(
        id: id,
        sequence: sequence,
        type: type,
        source: source,
        isManual: isManual,
        label: label,
        address: address,
        latitude: latitude,
        longitude: longitude,
        arrivedAt: arrivedAt,
      );
}

class UpdateDriverTransportOrderStatusRequestDto {
  const UpdateDriverTransportOrderStatusRequestDto({
    required this.status,
    this.description,
  });

  final String status;
  final String? description;

  Map<String, dynamic> toJson() => {
    'status': status,
    if (description != null && description!.trim().isNotEmpty)
      'description': description!.trim(),
  };
}

class UpdateDriverTransportOrderStatusResponseDto {
  const UpdateDriverTransportOrderStatusResponseDto({
    required this.id,
    required this.ztNumber,
    required this.status,
    required this.events,
  });

  final String id;
  final String ztNumber;
  final String status;
  final List<TransportOrderEventDto> events;

  factory UpdateDriverTransportOrderStatusResponseDto.fromJson(
    Map<String, dynamic> json,
  ) {
    final eventsJson = json['events'] as List<dynamic>? ?? [];
    return UpdateDriverTransportOrderStatusResponseDto(
      id: json['id'] as String,
      ztNumber: json['ztNumber'] as String,
      status: json['status'] as String,
      events: eventsJson
          .map(
            (e) => TransportOrderEventDto.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  DriverTransportOrder toDomain() => DriverTransportOrder(
    id: id,
    ztNumber: ztNumber,
    status: status,
    fromCountry: '', // Not provided in response
    toCountry: '', // Not provided in response
    loadingDate: null, // Not provided in response
  );
}

class TransportOrderEventDto {
  const TransportOrderEventDto({
    required this.id,
    required this.type,
    required this.previousStatus,
    required this.newStatus,
    this.description,
    required this.createdAt,
  });

  final String id;
  final String type;
  final String previousStatus;
  final String newStatus;
  final String? description;
  final DateTime createdAt;

  factory TransportOrderEventDto.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(dynamic v) {
      if (v is String) {
        return DateTime.tryParse(v) ?? DateTime.now();
      }
      return DateTime.now();
    }

    return TransportOrderEventDto(
      id: json['id'] as String,
      type: json['type'] as String,
      previousStatus: json['previousStatus'] as String,
      newStatus: json['newStatus'] as String,
      description: json['description'] as String?,
      createdAt: parseDate(json['createdAt']),
    );
  }
}
