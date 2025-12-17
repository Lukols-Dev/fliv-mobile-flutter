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

class SignUpResponseDto {
  const SignUpResponseDto({required this.accessToken, required this.userId});

  final String accessToken;
  final String userId;

  factory SignUpResponseDto.fromJson(Map<String, dynamic> json) {
    final token = json['token'] as String?;
    final user = json['user'] as Map<String, dynamic>?;
    final id = user?['id'] as String?;

    if (token == null || token.isEmpty) {
      throw const FormatException('Missing access token in signup response');
    }
    if (id == null || id.isEmpty) {
      throw const FormatException('Missing user.id in signup response');
    }
    return SignUpResponseDto(accessToken: token, userId: id);
  }
}
