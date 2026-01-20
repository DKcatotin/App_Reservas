import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart'; // Para kDebugMode
import '../config/env.dart';
import '../storage/token_storage.dart';
import 'auth_interceptor.dart';

/// Centraliza la configuración HTTP
class DioClient {
  DioClient._();

  static Dio create(TokenStorage tokenStorage) {
    final dio = Dio(
      BaseOptions(
        baseUrl: Env.baseUrl,
        headers: {'Content-Type': 'application/json'},
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
      ),
    );

    // Agregar interceptor de autenticación con parámetros nombrados
    dio.interceptors.add(
      AuthInterceptor(
        tokenStorage: tokenStorage, // Parámetro nombrado
        dio: dio,                    // Parámetro nombrado
      ),
    );

    // Solo agregar logs en modo debug
    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          requestHeader: true,
          responseHeader: false,
          error: true,
        ),
      );
    }

    return dio;
  }
}
