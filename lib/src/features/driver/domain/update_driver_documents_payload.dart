class UpdateDriverDocumentsPayload {
  const UpdateDriverDocumentsPayload({
    this.companyInternalId,
    this.visaExpiresAt,
    this.drivingLicenseExpiresAt,
    this.workPermitExpiresAt,
    this.medicalCheckExpiresAt,
    this.psychCheckExpiresAt,
    this.driverCardExpiresAt,
    this.residenceCardExpiresAt,
    this.driverCertificateExpiresAt,
  });

  final String? companyInternalId;
  final String? visaExpiresAt;
  final String? drivingLicenseExpiresAt;
  final String? workPermitExpiresAt;
  final String? medicalCheckExpiresAt;
  final String? psychCheckExpiresAt;
  final String? driverCardExpiresAt;
  final String? residenceCardExpiresAt;
  final String? driverCertificateExpiresAt;

  Map<String, dynamic> toJson() => {
    if (companyInternalId != null) 'companyInternalId': companyInternalId,
    if (visaExpiresAt != null) 'visaExpiresAt': visaExpiresAt,
    if (drivingLicenseExpiresAt != null)
      'drivingLicenseExpiresAt': drivingLicenseExpiresAt,
    if (workPermitExpiresAt != null) 'workPermitExpiresAt': workPermitExpiresAt,
    if (medicalCheckExpiresAt != null)
      'medicalCheckExpiresAt': medicalCheckExpiresAt,
    if (psychCheckExpiresAt != null) 'psychCheckExpiresAt': psychCheckExpiresAt,
    if (driverCardExpiresAt != null) 'driverCardExpiresAt': driverCardExpiresAt,
    if (residenceCardExpiresAt != null)
      'residenceCardExpiresAt': residenceCardExpiresAt,
    if (driverCertificateExpiresAt != null)
      'driverCertificateExpiresAt': driverCertificateExpiresAt,
  };
}
