class RegisterDriverPayload {
  RegisterDriverPayload({
    this.companyInternalId,
    this.phone,
    required this.firstName,
    required this.lastName,
    required this.isAgreedToTerms,
    required this.isAgreedToPrivacyPolicy,
  });

  final String? companyInternalId;
  final String? phone;
  final String firstName;
  final String lastName;
  final bool isAgreedToTerms;
  final bool isAgreedToPrivacyPolicy;

  Map<String, dynamic> toJson() => {
    if (companyInternalId != null && companyInternalId!.trim().isNotEmpty)
      'companyInternalId': companyInternalId!.trim(),
    if (phone != null && phone!.trim().isNotEmpty) 'phone': phone!.trim(),
    'firstName': firstName.trim(),
    'lastName': lastName.trim(),
    'isAgreedToTerms': isAgreedToTerms,
    'isAgreedToPrivacyPolicy': isAgreedToPrivacyPolicy,
  };
}
