import 'package:dio/dio.dart';
import 'package:agenda_app/core/errors/exceptions.dart';
import 'package:agenda_app/core/networking/api_endpoints.dart';
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
      await dio.post(
        ApiEndpoints.appointments,
        data: appointment.toJson(),
      );
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Error al crear cita');
    }
  }

  @override
  Future<void> update(Appointment appointment) async {
    try {
      await dio.put(
        '${ApiEndpoints.appointments}/${appointment.id}',
        data: appointment.toJson(),
      );
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Error al actualizar cita');
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
