class RegisterDriverPayload {
  RegisterDriverPayload({this.companyInternalId, this.phone});

  final String? companyInternalId;
  final String? phone;

  Map<String, dynamic> toJson() => {
    if (companyInternalId != null && companyInternalId!.trim().isNotEmpty)
      'companyInternalId': companyInternalId!.trim(),
    if (phone != null && phone!.trim().isNotEmpty) 'phone': phone!.trim(),
  };
}
