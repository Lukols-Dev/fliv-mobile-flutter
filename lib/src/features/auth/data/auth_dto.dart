class LoginResponseDto {
  const LoginResponseDto({required this.accessToken});

  final String accessToken;

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) {
    final token = (json['token']) as String?;
    if (token == null || token.isEmpty) {
      throw const FormatException('Missing access token in response');
    }
    return LoginResponseDto(accessToken: token);
  }
}

