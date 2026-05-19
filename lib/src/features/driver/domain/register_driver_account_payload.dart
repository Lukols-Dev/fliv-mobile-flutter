class RegisterDriverAccountPayload {
  RegisterDriverAccountPayload({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.companyInternalId,
    this.phone,
    required this.isAgreedToTerms,
    required this.isAgreedToPrivacyPolicy,
  });

  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String companyInternalId;
  final String? phone;
  final bool isAgreedToTerms;
  final bool isAgreedToPrivacyPolicy;

  Map<String, dynamic> toJson() => {
    'email': email.trim(),
    'password': password,
    'firstName': firstName.trim(),
    'lastName': lastName.trim(),
    'companyInternalId': companyInternalId.trim(),
    if (phone != null && phone!.trim().isNotEmpty) 'phone': phone!.trim(),
    'isAgreedToTerms': isAgreedToTerms,
    'isAgreedToPrivacyPolicy': isAgreedToPrivacyPolicy,
  };
}
