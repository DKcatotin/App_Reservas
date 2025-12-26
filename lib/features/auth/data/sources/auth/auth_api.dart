import 'package:dio/dio.dart';
import '../../../../../core/networking/api_endpoints.dart';
import '../../models/auth_response.dart';

class AuthApi {
  final Dio dio;
  AuthApi(this.dio);

  Future<AuthResponse> signIn({
    required String username,
    required String password,
  }) async {
    final res = await dio.post(
      ApiEndpoints.signIn,
      data: {'username': username, 'password': password},
    );
    return AuthResponse.fromJson(res.data as Map<String, dynamic>);
  }
  Future<AuthResponse> greetPrivate() async {
    final res = await dio.get(
      'greet-private',
    );
    return AuthResponse.fromJson(res.data as Map<String, dynamic>);
  }
}
