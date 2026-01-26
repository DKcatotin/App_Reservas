import 'package:dio/dio.dart';
import 'package:agenda_app/core/errors/exceptions.dart';
import 'package:flutter/foundation.dart';

class AppointmentServicesRemoteDatasource {
  final Dio dio;

  AppointmentServicesRemoteDatasource({required this.dio});

  String _readServiceId(Map<String, dynamic> json) {
    final direct = json['serviceId'] ?? json['service_id'];
    if (direct != null) {
      return direct.toString();
    }
    final nested = json['service'];
    if (nested is Map<String, dynamic> && nested['id'] != null) {
      return nested['id'].toString();
    }
    return '';
  }

  String _readId(Map<String, dynamic> json) {
    final value = json['id'];
    return value == null ? '' : value.toString();
  }

  int _readDurationMin(Map<String, dynamic> json) {
    final value = json['durationMin'] ?? json['duration_min'];
    if (value is num) return value.toInt();
    return 0;
  }

  double _readPrice(Map<String, dynamic> json) {
    final value = json['price'];
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  /// Obtener servicios de una cita
  Future<List<Map<String, dynamic>>> getByAppointment(String appointmentId) async {
    try {
      final response = await dio.get(
        '/appointment-services/appointment/$appointmentId',
      );

      final data = response.data['data'] as List<dynamic>?;
      return data?.cast<Map<String, dynamic>>() ?? [];
    } on DioException catch (e) {
      debugPrint('Error obteniendo servicios de cita: ${e.response?.data}');
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
        'price': price,
      };

      debugPrint('Creando appointment-service: $body');

      final response = await dio.post(
        '/appointment-services',
        data: body,
      );

      debugPrint('Appointment-service creado: ${response.data}');
    } on DioException catch (e) {
      debugPrint('Error creando appointment-service: ${e.response?.data}');
      throw ServerException('Error al crear servicio: ${e.response?.data ?? e.message}');
    }
  }

  /// Eliminar un servicio de una cita
  Future<void> delete(String appointmentServiceId) async {
    try {
      await dio.delete('/appointment-services/$appointmentServiceId');
      debugPrint('Appointment-service eliminado: $appointmentServiceId');
    } on DioException catch (e) {
      debugPrint('Error eliminando appointment-service: ${e.response?.data}');
      throw ServerException('Error al eliminar servicio: ${e.message}');
    }
  }

  /// Actualizar un servicio de una cita
  Future<void> update({
    required String appointmentServiceId,
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
        'price': price,
      };

      final response = await dio.patch(
        '/appointment-services/$appointmentServiceId',
        data: body,
      );

      debugPrint('Appointment-service actualizado: ${response.data}');
    } on DioException catch (e) {
      debugPrint('Error actualizando appointment-service: ${e.response?.data}');
      throw ServerException(
        'Error al actualizar servicio: ${e.response?.data ?? e.message}',
      );
    }
  }

  /// Eliminar todos los servicios de una cita
  Future<void> deleteByAppointment(String appointmentId) async {
    final currentServices = await getByAppointment(appointmentId);
    for (final current in currentServices) {
      final id = _readId(current);
      if (id.isEmpty) continue;
      await delete(id);
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

      // 2. Eliminar servicios que ya no estan
      final newServiceIds = services
          .map((s) => s['serviceId'])
          .whereType<String>()
          .toSet();
      for (final current in currentServices) {
        final currentServiceId = _readServiceId(current);
        if (currentServiceId.isEmpty) continue;
        if (!newServiceIds.contains(currentServiceId)) {
          final id = _readId(current);
          if (id.isNotEmpty) {
            await delete(id);
          }
        }
      }

      // 3. Agregar o actualizar servicios
      final currentByServiceId = <String, Map<String, dynamic>>{};
      for (final current in currentServices) {
        final currentServiceId = _readServiceId(current);
        if (currentServiceId.isNotEmpty) {
          currentByServiceId[currentServiceId] = current;
        }
      }

      for (final service in services) {
        final serviceId = service['serviceId'] as String?;
        if (serviceId == null || serviceId.isEmpty) continue;

        final current = currentByServiceId[serviceId];
        if (current == null) {
          await create(
            appointmentId: appointmentId,
            serviceId: serviceId,
            durationMin: service['durationMin'] as int,
            price: (service['price'] as num).toDouble(),
          );
          continue;
        }

        final currentDuration = _readDurationMin(current);
        final currentPrice = _readPrice(current);
        final newDuration = service['durationMin'] as int;
        final newPrice = (service['price'] as num).toDouble();

        if (currentDuration != newDuration || currentPrice != newPrice) {
          final id = _readId(current);
          if (id.isNotEmpty) {
            await update(
              appointmentServiceId: id,
              appointmentId: appointmentId,
              serviceId: serviceId,
              durationMin: newDuration,
              price: newPrice,
            );
          }
        }
      }

      debugPrint('Servicios de cita actualizados correctamente');
    } catch (e) {
      debugPrint('Error actualizando servicios: $e');
      rethrow;
    }
  }
}
