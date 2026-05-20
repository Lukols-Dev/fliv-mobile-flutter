class UpdateUserProfilePayload {
  const UpdateUserProfilePayload({
    required this.firstName,
    required this.lastName,
    required this.phone,
  });

  final String firstName;
  final String lastName;
  final String phone;

  Map<String, dynamic> toJson() => {
    'firstName': firstName.trim(),
    'lastName': lastName.trim(),
    'phone': phone.trim(),
  };
}
