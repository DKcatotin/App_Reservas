import 'package:dio/dio.dart';
import 'package:agenda_app/core/errors/exceptions.dart';
import 'package:flutter/foundation.dart';

class AppointmentServicesRemoteDatasource {
  final Dio dio;

  AppointmentServicesRemoteDatasource({required this.dio});

  /// Obtener servicios de una cita
  Future<List<Map<String, dynamic>>> getByAppointment(String appointmentId) async {
    try {
      final response = await dio.get(
        '/appointment-services/appointment/$appointmentId',
      );
      
      final data = response.data['data'] as List<dynamic>?;
      return data?.cast<Map<String, dynamic>>() ?? [];
    } on DioException catch (e) {
      debugPrint('❌ Error obteniendo servicios de cita: ${e.response?.data}');
      throw ServerException('Error al obtener servicios: ${e.message}');
    }
  }

  /// Crear un servicio para una cita
  Future<void> create({
  required String appointmentId,
  required String serviceId,
  required int durationMin,
  required double price,
}) async {
  try {
    final body = {
      'appointment': {
        'id': appointmentId,
      },
      'serviceId': serviceId,
      'durationMin': durationMin,
      'price': price,  // ✅ Número decimal (no string)
    };

    debugPrint('📍 Creando appointment-service: $body');

    final response = await dio.post(
      '/appointment-services',
      data: body,
    );

    debugPrint('✅ Appointment-service creado: ${response.data}');
  } on DioException catch (e) {
    debugPrint('❌ Error creando appointment-service: ${e.response?.data}');
    throw ServerException('Error al crear servicio: ${e.response?.data ?? e.message}');
  }
}


  /// Eliminar un servicio de una cita
  Future<void> delete(String appointmentServiceId) async {
    try {
      await dio.delete('/appointment-services/$appointmentServiceId');
      debugPrint('✅ Appointment-service eliminado: $appointmentServiceId');
    } on DioException catch (e) {
      debugPrint('❌ Error eliminando appointment-service: ${e.response?.data}');
      throw ServerException('Error al eliminar servicio: ${e.message}');
    }
  }

  /// Actualizar los servicios de una cita (eliminar los viejos y crear los nuevos)
  Future<void> updateAppointmentServices({
    required String appointmentId,
    required List<Map<String, dynamic>> services,
  }) async {
    try {
      // 1. Obtener servicios actuales
      final currentServices = await getByAppointment(appointmentId);

      // 2. Eliminar servicios que ya no están
      final newServiceIds = services.map((s) => s['serviceId'] as String).toSet();
      for (final current in currentServices) {
        final currentServiceId = current['serviceId'] as String;
        if (!newServiceIds.contains(currentServiceId)) {
          await delete(current['id'] as String);
        }
      }

      // 3. Agregar servicios nuevos
      final currentServiceIds = currentServices
          .map((s) => s['serviceId'] as String)
          .toSet();
      
      for (final service in services) {
        final serviceId = service['serviceId'] as String;
        if (!currentServiceIds.contains(serviceId)) {
          await create(
            appointmentId: appointmentId,
            serviceId: serviceId,
            durationMin: service['durationMin'] as int,
            price: (service['price'] as num).toDouble(),
          );
        }
      }

      debugPrint('✅ Servicios de cita actualizados correctamente');
    } catch (e) {
      debugPrint('❌ Error actualizando servicios: $e');
      rethrow;
    }
  }
}
