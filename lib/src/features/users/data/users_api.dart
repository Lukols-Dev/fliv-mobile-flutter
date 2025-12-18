import 'package:dio/dio.dart';

class UsersApi {
  UsersApi(this._dio);

  final Dio _dio;

  Future<String> uploadAvatar({required String filePath}) async {
    final form = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
    });

    final res = await _dio.post('/api/v1/users/avatar', data: form);

    final data = res.data;
    if (data is Map<String, dynamic>) {
      final url = data['avatarUrl'] as String?;
      if (url != null && url.trim().isNotEmpty) return url;
    }

    throw const FormatException('Missing avatarUrl in response');
  }
}
