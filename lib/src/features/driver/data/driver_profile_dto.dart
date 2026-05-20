import '../domain/driver_profile.dart';

class DriverProfileDto {
  const DriverProfileDto({
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

  factory DriverProfileDto.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      if (value is String) return DateTime.tryParse(value);
      return null;
    }

    final driverProfile = json['driverProfile'];
    final dp = driverProfile is Map<String, dynamic>
        ? driverProfile
        : <String, dynamic>{};

    return DriverProfileDto(
      firstName: (json['firstName'] as String?) ?? '',
      lastName: (json['lastName'] as String?) ?? '',
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      companyInternalId: dp['companyInternalId'] as String?,
      driverCode: dp['driverCode'] as String?,

      visaExpiresAt: parseDate(dp['visaExpiresAt']),
      drivingLicenseExpiresAt: parseDate(dp['drivingLicenseExpiresAt']),
      workPermitExpiresAt: parseDate(dp['workPermitExpiresAt']),
      medicalCheckExpiresAt: parseDate(dp['medicalCheckExpiresAt']),
      psychCheckExpiresAt: parseDate(dp['psychCheckExpiresAt']),
      driverCardExpiresAt: parseDate(dp['driverCardExpiresAt']),
      residenceCardExpiresAt: parseDate(dp['residenceCardExpiresAt']),
      driverCertificateExpiresAt: parseDate(dp['driverCertificateExpiresAt']),
    );
  }

  DriverProfile toDomain() => DriverProfile(
    firstName: firstName,
    lastName: lastName,
    email: email,
    phone: phone,
    avatarUrl: avatarUrl,
    companyInternalId: companyInternalId,
    driverCode: driverCode,

    visaExpiresAt: visaExpiresAt,
    drivingLicenseExpiresAt: drivingLicenseExpiresAt,
    workPermitExpiresAt: workPermitExpiresAt,
    medicalCheckExpiresAt: medicalCheckExpiresAt,
    psychCheckExpiresAt: psychCheckExpiresAt,
    driverCardExpiresAt: driverCardExpiresAt,
    residenceCardExpiresAt: residenceCardExpiresAt,
    driverCertificateExpiresAt: driverCertificateExpiresAt,
  );
}
