class DriverProfile {
  const DriverProfile({
    required this.firstName,
    required this.lastName,
    this.email,
    this.phone,
    this.avatarUrl,
    this.companyInternalId,
    this.driverCode,

    this.visaExpiresAt,
    this.drivingLicenseExpiresAt,
    this.workPermitExpiresAt,
    this.medicalCheckExpiresAt,
    this.psychCheckExpiresAt,
    this.driverCardExpiresAt,
    this.residenceCardExpiresAt,
    this.driverCertificateExpiresAt,
  });

  final String firstName;
  final String lastName;
  final String? email;
  final String? phone;
  final String? avatarUrl;
  final String? companyInternalId;
  final String? driverCode;

  final DateTime? visaExpiresAt;
  final DateTime? drivingLicenseExpiresAt;
  final DateTime? workPermitExpiresAt;
  final DateTime? medicalCheckExpiresAt;
  final DateTime? psychCheckExpiresAt;
  final DateTime? driverCardExpiresAt;
  final DateTime? residenceCardExpiresAt;
  final DateTime? driverCertificateExpiresAt;
}
