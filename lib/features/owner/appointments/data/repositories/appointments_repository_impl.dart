import 'package:agenda_app/core/errors/exceptions.dart';
import 'package:agenda_app/core/errors/failures.dart';
import 'package:agenda_app/features/owner/appointments/data/mappers/appointment_mapper.dart';
import 'package:agenda_app/features/owner/appointments/data/models/appointment.dart';
import 'package:agenda_app/features/owner/appointments/data/sources/appointments/appointments_datasource.dart';
import 'package:agenda_app/features/owner/appointments/domain/entities/appointment_entity.dart';
import 'package:agenda_app/features/owner/appointments/domain/repositories/appointments_repository.dart';
import 'package:agenda_app/features/owner/appointments/domain/utils/date_utils.dart';

class AppointmentsRepositoryImpl implements AppointmentsRepository {
  final AppointmentsDatasource remoteDatasource;

  // Cache
  List<Appointment>? _cache;
  List<AppointmentEntity>? _entityCache;
  DateTime? _cacheTime;
  final Duration _cacheDuration = const Duration(minutes: 5);

  AppointmentsRepositoryImpl({
    required this.remoteDatasource,
  });

  bool get _isCacheValid =>
      _cache != null &&
      _cacheTime != null &&
      DateTime.now().difference(_cacheTime!) < _cacheDuration;

  void invalidateCache() {
    _cache = null;
    _entityCache = null;
    _cacheTime = null;
  }

  @override
  Future<List<AppointmentEntity>> getAll() async {
    try {
      if (_isCacheValid && _entityCache != null) {
        return _entityCache!;
      }

      final appointments = await remoteDatasource.getAll();
      _cache = appointments;
      _cacheTime = DateTime.now();
      
      // Usar el mapper que ya tienes
      _entityCache = appointments
          .map((a) => AppointmentMapper.toEntity(a))
          .toList();
      
      return _entityCache!;
    } on ServerException catch (e) {
      throw AppointmentsFailure(e.message);
    } catch (e) {
      throw AppointmentsFailure('Error al obtener citas: $e');
    }
  }

  @override
  Future<List<AppointmentEntity>> getByDay(DateTime day) async {
    final all = await getAll();

    final result = all
        .where((a) => isSameDate(a.startAt, day))
        .toList()
      ..sort((a, b) => a.startAt.compareTo(b.startAt));

    return result;
  }

  @override
  Future<void> create(AppointmentEntity appointment) async {
    try {
      // Usar el mapper para convertir entity a model
      final appointmentModel = AppointmentMapper.toModel(appointment);
      await remoteDatasource.create(appointmentModel);
      invalidateCache();
    } on ServerException catch (e) {
      throw AppointmentsFailure(e.message);
    } catch (e) {
      throw AppointmentsFailure('Error al crear cita: $e');
    }
  }

  @override
  Future<void> update(AppointmentEntity appointment) async {
    try {
      // Usar el mapper para convertir entity a model
      final appointmentModel = AppointmentMapper.toModel(appointment);
      await remoteDatasource.update(appointmentModel);
      invalidateCache();
    } on ServerException catch (e) {
      throw AppointmentsFailure(e.message);
    } catch (e) {
      throw AppointmentsFailure('Error al actualizar cita: $e');
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      await remoteDatasource.delete(id);
      invalidateCache();
    } on ServerException catch (e) {
      throw AppointmentsFailure(e.message);
    } catch (e) {
      throw AppointmentsFailure('Error al eliminar cita: $e');
    }
  }
}
