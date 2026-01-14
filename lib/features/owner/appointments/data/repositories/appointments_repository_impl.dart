import 'package:agenda_app/features/owner/appointments/data/models/appointment.dart';
import 'package:agenda_app/features/owner/appointments/data/models/appointment_service.dart';
import 'package:agenda_app/features/owner/appointments/data/models/customer.dart';
import 'package:agenda_app/features/owner/appointments/data/models/source.dart';
import 'package:agenda_app/features/owner/appointments/data/models/staff.dart';
import 'package:agenda_app/features/owner/appointments/data/models/status.dart';
import 'package:agenda_app/features/owner/appointments/data/sources/appointments_datasource.dart';
import 'package:agenda_app/features/owner/appointments/domain/entities/appointment_entity.dart';
import 'package:agenda_app/features/owner/appointments/domain/entities/customer_entity.dart';
import 'package:agenda_app/features/owner/appointments/domain/entities/service_entity.dart';
import 'package:agenda_app/features/owner/appointments/domain/entities/source_entity.dart';
import 'package:agenda_app/features/owner/appointments/domain/entities/staff_entity.dart';
import 'package:agenda_app/features/owner/appointments/domain/entities/status_entity.dart';
import 'package:agenda_app/features/owner/appointments/domain/repositories/appointments_repository.dart';
import 'package:agenda_app/features/owner/appointments/domain/utils/date_utils.dart';

class AppointmentsRepositoryImpl implements AppointmentsRepository {
  final AppointmentsDatasource datasource;

  // Cache para mejorar performance
  List<Appointment>? _cache;
  List<AppointmentEntity>? _entityCache; // ✅ NUEVO: Caché de entities
  DateTime? _cacheTime;
  final Duration _cacheDuration = const Duration(minutes: 5);

  AppointmentsRepositoryImpl({required this.datasource});

  // ==================== VALIDACIÓN DE CACHE ====================
  bool get _isCacheValid =>
      _cache != null &&
      _cacheTime != null &&
      DateTime.now().difference(_cacheTime!) < _cacheDuration;

  void invalidateCache() {
    _cache = null;
    _entityCache = null; // ✅ NUEVO: Limpiar caché de entities
    _cacheTime = null;
  }

  // ==================== IMPLEMENTACIÓN DE MÉTODOS ====================

  @override
  Future<List<AppointmentEntity>> getAll() async {
    // ✅ OPTIMIZACIÓN: Retornar entities cacheadas directamente
    if (_isCacheValid && _entityCache != null) {
      return _entityCache!;
    }

    // Cargar desde datasource
    _cache = await datasource.getAll();
    _cacheTime = DateTime.now();

    // ✅ OPTIMIZACIÓN: Cachear la conversión a entities
    _entityCache = _cache!.map((m) => _mapToEntity(m)).toList();

    return _entityCache!;
  }

  @override
  Future<List<AppointmentEntity>> getByDay(DateTime day) async {
    final all = await getAll();

    // Filtrar por día
    final result = all.where((a) {
      return isSameDate(a.startAt, day);
    }).toList();

    // Ordenar por hora de inicio
    result.sort((a, b) => a.startAt.compareTo(b.startAt));

    return result;
  }

  @override
  Future<void> create(AppointmentEntity appointment) async {
    final model = _mapToModel(appointment);
    await datasource.create(model);
    invalidateCache();
  }

  @override
  Future<void> update(AppointmentEntity appointment) async {
    final model = _mapToModel(appointment);
    await datasource.update(model);
    invalidateCache();
  }

  @override
  Future<void> delete(String id) async {
    await datasource.delete(id);
    invalidateCache();
  }

  // ==================== MAPPERS ====================

  /// Convierte un Model (data) a Entity (domain)
  AppointmentEntity _mapToEntity(Appointment model) {
  return AppointmentEntity(
    id: model.id,
    ownerId: model.ownerId,
    branchId: model.branchId,
    customerId: model.customerId,
    staffId: model.staffId,
    startAt: model.startAt,
    endAt: model.endAt,
    notes: model.notes,
    status: StatusEntity(
      code: model.status.code,
      label: model.status.label,
    ),
    source: SourceEntity(
      code: model.source.type,
      name: _getSourceName(model.source.type),
    ),
    customer: CustomerEntity(
      id: model.customer.id,
      taxIdentification: model.customer.taxIdentification,  // ✅ CAMBIO
      fullName: model.customer.fullName,  // ✅ CAMBIO
      phone: model.customer.phone,  // ✅ CAMBIO
      email: model.customer.email,  // ✅ NUEVO
      allergies: model.customer.allergies,  // ✅ NUEVO
    ),
    staff: model.staff != null
        ? StaffEntity(
            id: model.staff!.id,
            name: model.staff!.name,
            specialty: model.staff!.specialty,
            colorTag: model.staff!.colorTag,
          )
        : null,
    services: model.services
        .map(
          (s) => ServiceEntity(
            id: s.id,
            name: s.name,
            durationMinutes: s.durationMinutes,
          ),
        )
        .toList(),
  );
}

  /// Convierte una Entity (domain) a Model (data)
  Appointment _mapToModel(AppointmentEntity entity) {
  return Appointment(
    id: entity.id,
    ownerId: entity.ownerId,
    branchId: entity.branchId,
    customerId: entity.customerId,
    staffId: entity.staffId,
    startAt: entity.startAt,
    endAt: entity.endAt,
    notes: entity.notes,
    status: Status(
      code: entity.status.code,
      label: entity.status.label,
    ),
    source: Source(type: entity.source.code),
    customer: Customer(
      id: entity.customer.id,
      taxIdentification: entity.customer.taxIdentification,  // ✅ CAMBIO
      fullName: entity.customer.fullName,  // ✅ CAMBIO
      phone: entity.customer.phone,  // ✅ CAMBIO
      email: entity.customer.email,  // ✅ NUEVO
      allergies: entity.customer.allergies,  // ✅ NUEVO
    ),
    staff: entity.staff != null
        ? Staff(
            id: entity.staff!.id,
            name: entity.staff!.name,
            specialty: entity.staff!.specialty,
            colorTag: entity.staff!.colorTag,
          )
        : null,
    services: entity.services
        .map(
          (s) => AppointmentService(
            id: s.id,
            name: s.name,
            durationMinutes: s.durationMinutes,
          ),
        )
        .toList(),
  );
}

  /// Helper para obtener el nombre del source
  String _getSourceName(String code) {
    switch (code) {
      case 'web':
        return 'Web';
      case 'app':
        return 'Aplicación';
      case 'whatsapp':
        return 'WhatsApp';
      case 'call':
        return 'Llamada';
      case 'in_person':
        return 'Presencial';
      default:
        return code;
    }
  }
}
