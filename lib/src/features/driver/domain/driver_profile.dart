class DriverProfile {
  const DriverProfile({
    required this.firstName,
    required this.lastName,
    this.email,
    this.phone,
    this.companyInternalId,
  });

  final String firstName;
  final String lastName;
  final String? email;
  final String? phone;
  final String? companyInternalId;
}
