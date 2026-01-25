import 'package:agenda_app/core/logger/app_logger.dart';
import 'package:agenda_app/core/networking/api_endpoints.dart';
import 'package:agenda_app/features/owner/catalogues/data/models/service.dart';
import 'package:dio/dio.dart';

class ServicesRemoteDatasource {
  final Dio _dio;

  ServicesRemoteDatasource(this._dio);

  /// Obtener todos los servicios
  Future<List<Service>> getAll() async {
    try {
      final response = await _dio.get(
ApiEndpoints.services,        
queryParameters: {
          'page': 1,
          'limit': 50,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data['data'] as List;

        AppLogger.d('📍 Servicios obtenidos: ${data.length}');

        return data.map((json) => Service.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener servicios: ${response.statusCode}');
      }
    } on DioException catch (e) {
      AppLogger.d('❌ DioException al obtener servicios: ${e.message}');
      throw Exception('Error de red al obtener servicios: ${e.message}');
    } catch (e) {
      AppLogger.d('❌ Error inesperado al obtener servicios: $e');
      throw Exception('Error al obtener servicios: $e');
    }
  }
}