import 'package:dio/dio.dart';
import '../domain/register_driver_payload.dart';

class DriverApi {
  DriverApi(this._dio);
  final Dio _dio;

  Future<void> registerDriver({required RegisterDriverPayload payload}) async {
    await _dio.post('/api/v1/driver/register', data: payload.toJson());
  }
}
