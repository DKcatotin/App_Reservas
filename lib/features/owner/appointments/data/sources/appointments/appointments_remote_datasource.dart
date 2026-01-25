import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:agenda_app/core/errors/exceptions.dart';
import 'package:agenda_app/core/networking/api_endpoints.dart';
import 'package:flutter/foundation.dart';
import '../../models/appointment.dart';
import 'appointments_datasource.dart';

class AppointmentsRemoteDatasource implements AppointmentsDatasource {
  final Dio dio;

  AppointmentsRemoteDatasource({required this.dio});

  @override
  Future<List<Appointment>> getAll() async {
    try {
      final response = await dio.get(
        ApiEndpoints.appointments,
        queryParameters: {
          'page': 1,
          'limit': 100,
        },
      );
      
      final data = response.data['data'] as List<dynamic>?;
      
      if (data == null) {
        return [];
      }
      
      return data
          .map((json) => Appointment.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Error al obtener citas del backend');
    }
  }

  @override
  Future<void> create(Appointment appointment) async {
    try {
      // ✅ CORRECCIÓN: NO enviar services al crear
      final body = {
        'branch': {
          'id': appointment.branch.id,
          'name': appointment.branch.name,
          'phone': appointment.branch.phone,
          'email': appointment.branch.email,
          'address': appointment.branch.address,
          'city': appointment.branch.city,
          'enabled': appointment.branch.enabled,
        },
        'customerId': appointment.customerId,
        'staffProfileId': appointment.staffProfileId,
        'sourceId': appointment.source.id,
        if (appointment.status.id.isNotEmpty) 
          'statusId': appointment.status.id,
        'startAt': appointment.startAt.toIso8601String(),
        'endAt': appointment.endAt.toIso8601String(),
        'notes': appointment.notes,
        // ✅ NO incluir services aquí - se asignan después al editar
      };

      debugPrint('📍 Creando appointment SIN servicios: $body');

      final response = await dio.post(
        '/core/owner/appointments',
        data: body,
      );

      debugPrint('✅ Appointment creado: ${response.data}');
    } on DioException catch (e) {
      debugPrint('❌ Error creando appointment: ${e.response?.data}');
      throw ServerException('Error al crear cita: ${e.response?.data ?? e.message}');
    }
  }

@override
Future<void> update(Appointment appointment) async {
  try {
    // ✅ Incluir el objeto branch completo
    final body = {
      'branch': {
        'id': appointment.branch.id,
        'name': appointment.branch.name,
        'phone': appointment.branch.phone,
        'email': appointment.branch.email,
        'address': appointment.branch.address,
        'city': appointment.branch.city,
        'enabled': appointment.branch.enabled,
      },
      'customerId': appointment.customerId,
      'staffProfileId': appointment.staffProfileId,
      'sourceId': appointment.source.id,
      'statusId': appointment.status.id,
      'startAt': appointment.startAt.toIso8601String(),
      'endAt': appointment.endAt.toIso8601String(),
      'notes': appointment.notes,
    };

    debugPrint('📍 Actualizando appointment: $body');

    final response = await dio.patch(
      '/core/owner/appointments/${appointment.id}',
      data: body,
    );

    debugPrint('✅ Appointment actualizado: ${response.data}');
  } on DioException catch (e) {
    debugPrint('❌ Error actualizando appointment: ${e.response?.data}');
    throw ServerException('Error al actualizar cita: ${e.response?.data ?? e.message}');
  }
}


  @override
  Future<void> delete(String id) async {
    try {
      await dio.delete('${ApiEndpoints.appointments}/$id');
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Error al eliminar cita');
    }
  }
}