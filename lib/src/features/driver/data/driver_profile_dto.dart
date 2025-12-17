import '../domain/driver_profile.dart';

class DriverProfileDto {
  const DriverProfileDto({
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

  factory DriverProfileDto.fromJson(Map<String, dynamic> json) {
    final user = json['user'];
    final email =
        (json['email'] as String?) ??
        (user is Map<String, dynamic> ? user['email'] as String? : null);

    return DriverProfileDto(
      firstName: (json['firstName'] as String?) ?? '',
      lastName: (json['lastName'] as String?) ?? '',
      phone: json['phone'] as String?,
      companyInternalId: json['companyInternalId'] as String?,
      email: email,
    );
  }

  DriverProfile toDomain() => DriverProfile(
    firstName: firstName,
    lastName: lastName,
    email: email,
    phone: phone,
    companyInternalId: companyInternalId,
  );
}
