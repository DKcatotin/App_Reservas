import 'package:agenda_app/core/errors/exceptions.dart';
import 'package:agenda_app/core/errors/failures.dart';
import 'package:agenda_app/features/owner/appointments/data/mappers/appointment_mapper.dart';
import 'package:agenda_app/features/owner/appointments/data/models/appointment.dart';
import 'package:agenda_app/features/owner/appointments/data/sources/appointments/appointments_datasource.dart';
import 'package:agenda_app/features/owner/appointments/domain/entities/appointment_entity.dart';
import 'package:agenda_app/features/owner/appointments/domain/repositories/appointments_repository.dart';
import 'package:agenda_app/features/owner/appointments/domain/utils/date_utils.dart';

class AppointmentsRepositoryImpl implements AppointmentsRepository {
  final AppointmentsDatasource datasource;

  // Cache
  List<Appointment>? _cache;
  List<AppointmentEntity>? _entityCache;
  DateTime? _cacheTime;

  final Duration _cacheDuration = const Duration(minutes: 5);

  AppointmentsRepositoryImpl({required this.datasource});

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

      _cache = await datasource.getAll();
      _cacheTime = DateTime.now();

      _entityCache =
          _cache!.map(AppointmentMapper.toEntity).toList();

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
    await datasource.create(
      AppointmentMapper.toModel(appointment),
    );
    invalidateCache();
  }

  @override
  Future<void> update(AppointmentEntity appointment) async {
    await datasource.update(
      AppointmentMapper.toModel(appointment),
    );
    invalidateCache();
  }

  @override
  Future<void> delete(String id) async {
    await datasource.delete(id);
    invalidateCache();
  }
}
