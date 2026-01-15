import 'package:agenda_app/features/owner/appointments/data/models/appointment.dart';
import 'package:agenda_app/features/owner/appointments/data/models/appointment_service.dart';
import 'package:agenda_app/features/owner/appointments/data/models/customer.dart';
import 'package:agenda_app/features/owner/appointments/data/models/source.dart';
import 'package:agenda_app/features/owner/appointments/data/sources/appointments_datasource.dart';
import 'package:agenda_app/features/owner/appointments/domain/entities/appointment_entity.dart';
import 'package:agenda_app/features/owner/appointments/domain/entities/customer_entity.dart';
import 'package:agenda_app/features/owner/appointments/domain/entities/service_entity.dart';
import 'package:agenda_app/features/owner/appointments/domain/entities/source_entity.dart';
import 'package:agenda_app/features/owner/appointments/domain/entities/staff_entity.dart';
import 'package:agenda_app/features/owner/appointments/domain/entities/status_entity.dart';
import 'package:agenda_app/features/owner/appointments/domain/repositories/appointments_repository.dart';
import 'package:agenda_app/features/owner/appointments/domain/utils/date_utils.dart';
import 'package:agenda_app/features/owner/catalogues/data/models/staff.dart';
import 'package:agenda_app/features/owner/catalogues/data/models/status.dart';

class AppointmentsRepositoryImpl implements AppointmentsRepository {
  final AppointmentsDatasource datasource;

  // Cache para mejorar performance
  List<Appointment>? _cache;
  List<AppointmentEntity>? _entityCache;
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
    _entityCache = null;
    _cacheTime = null;
  }

  // ==================== IMPLEMENTACIÓN DE MÉTODOS ====================

  @override
  Future<List<AppointmentEntity>> getAll() async {
    if (_isCacheValid && _entityCache != null) {
      return _entityCache!;
    }

    _cache = await datasource.getAll();
    _cacheTime = DateTime.now();
    _entityCache = _cache!.map((m) => _mapToEntity(m)).toList();

    return _entityCache!;
  }

  @override
  Future<List<AppointmentEntity>> getByDay(DateTime day) async {
    final all = await getAll();

    final result = all.where((a) {
      return isSameDate(a.startAt, day);
    }).toList();

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
        label: model.status.name,  // ✅ Cambio: label -> name
      ),
      source: SourceEntity(
        code: model.source.code,    // ✅ Cambio: type -> code
        name: model.source.name,    // ✅ Cambio: usar directamente name
      ),
      customer: CustomerEntity(
        id: model.customer.id,
        userId: model.customer.userId,
        referredBy: model.customer.referredBy,
        taxIdentification: model.customer.taxIdentification,
        taxName: model.customer.taxName,
        fullName: model.customer.fullName,
        phone: model.customer.phone,
        email: model.customer.email,
        allergies: model.customer.allergies,
      ),
      staff: model.staff != null
          ? StaffEntity(
              id: model.staff!.id,
              name: model.staff!.displayName,  // ✅ Cambio: name -> displayName
              specialty: model.staff!.specialty,
              colorTag: model.staff!.colorTag,
            )
          : null,
      services: model.services
          .map(
            (s) => ServiceEntity(
              id: s.id,
              name: s.name,
              durationMin: s.durationMin,  // ✅ Cambio: durationMinutes -> durationMin
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
        id: 0,                      // ✅ Agregado: id requerido
        code: entity.status.code,
        name: entity.status.label,  // ✅ Cambio: label -> name
      ),
      source: Source(
        id: 0,                      // ✅ Agregado: id requerido
        code: entity.source.code,   // ✅ Agregado: code requerido
        name: entity.source.name,   // ✅ Cambio: type -> name
      ),
      customer: Customer(
        id: entity.customer.id,
        userId: entity.customer.userId,
        referredBy: entity.customer.referredBy,
        taxIdentification: entity.customer.taxIdentification,
        taxName: entity.customer.taxName,
        fullName: entity.customer.fullName,
        phone: entity.customer.phone,
        email: entity.customer.email,
        allergies: entity.customer.allergies,
      ),
      staff: entity.staff != null
          ? Staff(
              id: entity.staff!.id,
              displayName: entity.staff!.name,  // ✅ Cambio: name -> displayName
              specialty: entity.staff!.specialty,
              colorTag: entity.staff!.colorTag,
            )
          : null,
      services: entity.services
          .map(
            (s) => AppointmentService(
              id: s.id,
              name: s.name,
              durationMin: s.durationMin,  // ✅ Cambio: durationMinutes -> durationMin
            ),
          )
          .toList(),
    );
  }

  /// Helper para obtener el nombre del source (ya no es necesario si usas directamente source.name)
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
