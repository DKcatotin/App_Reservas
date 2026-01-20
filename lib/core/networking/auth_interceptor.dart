import 'package:dio/dio.dart';
import '../storage/token_storage.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorage tokenStorage;
  final Dio dio;

  AuthInterceptor({
    required this.tokenStorage, // ← Parámetro nombrado
    required this.dio,           // ← Parámetro nombrado
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await tokenStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Si el error es 401 (token expirado), intentar refrescar
    if (err.response?.statusCode == 401) {
      try {
        final refreshToken = await tokenStorage.getRefreshToken();
        
        if (refreshToken != null && refreshToken.isNotEmpty) {
          // Crear un nuevo Dio sin interceptores para evitar loop infinito
          final refreshDio = Dio(dio.options);
          
          // Llamar al endpoint de refresh
          final response = await refreshDio.post(
            '/auth/refresh',
            data: {'refresh_token': refreshToken},
          );

          if (response.statusCode == 200) {
            final newAccessToken = response.data['access_token'];
            final newRefreshToken = response.data['refresh_token'];

            // Guardar nuevos tokens
            await tokenStorage.saveAccessToken(newAccessToken);
            if (newRefreshToken != null) {
              await tokenStorage.saveRefreshToken(newRefreshToken);
            }

            // Reintentar la petición original con el nuevo token
            final opts = err.requestOptions;
            opts.headers['Authorization'] = 'Bearer $newAccessToken';
            
            final cloneReq = await dio.fetch(opts);
            return handler.resolve(cloneReq);
          }
        }
      } catch (e) {
        // Si falla el refresh, limpiar sesión
        await tokenStorage.clearSession();
        return handler.reject(err);
      }
    }
    
    handler.next(err);
  }
}
