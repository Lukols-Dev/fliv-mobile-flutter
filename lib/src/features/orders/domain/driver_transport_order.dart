class DriverTransportOrder {
  const DriverTransportOrder({
    required this.id,
    required this.ztNumber,
    required this.status,
    required this.fromCountry,
    required this.toCountry,
    required this.loadingDate,
  });

  final String id;
  final String ztNumber;
  final String status;
  final String fromCountry;
  final String toCountry;
  final DateTime? loadingDate;
}
