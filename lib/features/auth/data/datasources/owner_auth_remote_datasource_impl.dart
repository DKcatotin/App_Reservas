import 'package:dio/dio.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/storage/token_storage.dart';
import '../models/owner_model.dart';
import 'owner_auth_remote_datasource.dart';

class OwnerAuthRemoteDataSourceImpl implements OwnerAuthRemoteDataSource {
  final Dio client;
  final TokenStorage storage;
  final String baseUrl;

  OwnerAuthRemoteDataSourceImpl({
    required this.client,
    required this.storage,
    required this.baseUrl,
  });

@override
Future<OwnerModel> loginOwner({
  required String email,
  required String password,
}) async {
  try {
    final response = await client.post(
      '/auth/sign-in',
      data: {
        'username': email,
        'password': password,
      },
    );

    print('🔍 Status Code: ${response.statusCode}'); // DEBUG

    // Aceptar 200 (OK) y 201 (Created)
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = response.data;
      final accessToken = data['data']['accessToken'];
      final authData = data['data']['auth'];
      
      print('🔍 Token: ${accessToken.substring(0, 20)}...'); // DEBUG
      print('🔍 Auth Data: $authData'); // DEBUG
      
      await storage.saveAccessToken(accessToken);
      await storage.saveUser(authData);
      
      final owner = OwnerModel.fromJson(authData);
      print('🔍 Owner creado: ${owner.fullName}'); // DEBUG
      
      return owner;
    } else if (response.statusCode == 401) {
      throw const AuthException('Credenciales inválidas');
    } else {
      throw ServerException(
        'Error del servidor: ${response.statusCode}',
      );
    }
  } on DioException catch (e) {
    if (e.response?.statusCode == 401) {
      throw const AuthException('Credenciales inválidas');
    } else if (e.response?.statusCode == 422) {
      final errors = e.response?.data['message'];
      if (errors is List) {
        throw AuthException('Error de validación: ${errors.join(", ")}');
      } else {
        throw AuthException('Error de validación: $errors');
      }
    } else if (e.response?.statusCode == 404) {
      throw const AuthException('Endpoint no encontrado');
    } else if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      throw const ServerException('Tiempo de espera agotado');
    } else if (e.type == DioExceptionType.connectionError) {
      throw const ServerException('Error de conexión');
    }
    throw ServerException('Error del servidor: ${e.message}');
  } on AuthException {
    rethrow;
  } on ServerException {
    rethrow;
  } catch (e) {
    throw ServerException('Error inesperado: $e');
  }
}

@override
Future<void> logoutOwner() async {
  try {
    // Opcional: llamar endpoint de logout en el backend
    // await client.post('/auth/logout');
    
    // Limpiar storage local - USAR clearSession
    await storage.clearSession();
  } catch (e) {
    // Aunque falle, limpiamos el storage local
    await storage.clearSession();
  }
}
  @override
  Future<OwnerModel> getCurrentOwner() async {
    final userData = await storage.getUser();
    if (userData == null) {
      throw const CacheException('No hay sesión activa');
    }
    return OwnerModel.fromJson(userData);
  }
}
