import 'package:dio/dio.dart';
import '../domain/register_driver_payload.dart';
import 'driver_profile_dto.dart';

class DriverApi {
  DriverApi(this._dio);
  final Dio _dio;

  Future<void> registerDriver({required RegisterDriverPayload payload}) async {
    await _dio.post('/api/v1/driver/register', data: payload.toJson());
  }

  Future<DriverProfileDto> getProfile({String? accessToken}) async {
    final res = await _dio.get('/api/v1/driver/profile');
    return DriverProfileDto.fromJson(res.data as Map<String, dynamic>);
  }
}
