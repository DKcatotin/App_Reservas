import 'package:agenda_app/features/owner/appointments/data/models/appointment.dart';
import 'package:agenda_app/features/owner/appointments/data/models/appointment_service.dart';
import 'package:agenda_app/features/owner/appointments/data/models/customer.dart';
import 'package:agenda_app/features/owner/appointments/data/models/source.dart';
import 'package:agenda_app/features/owner/appointments/data/sources/appointments/appointments_datasource.dart';
import 'package:agenda_app/features/owner/appointments/domain/entities/appointment_entity.dart';
import 'package:agenda_app/features/owner/appointments/domain/entities/customer_entity.dart';
import 'package:agenda_app/features/owner/appointments/domain/entities/source_entity.dart';
import 'package:agenda_app/features/owner/appointments/domain/repositories/appointments_repository.dart';
import 'package:agenda_app/features/owner/appointments/domain/utils/date_utils.dart';
import 'package:agenda_app/features/owner/catalogues/data/models/staff.dart';
import 'package:agenda_app/features/owner/catalogues/data/models/status.dart';
import 'package:agenda_app/features/owner/catalogues/domain/entities/service_entity.dart';
import 'package:agenda_app/features/owner/catalogues/domain/entities/staff_entity.dart';
import 'package:agenda_app/features/owner/appointments/domain/entities/status_entity.dart';

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
      branchId: model.branchId,
      customerId: model.customerId,
      staffProfileId: model.staffId, // → staffId
      startAt: model.startAt,
      endAt: model.endAt,
      notes: model.notes,
      status: StatusEntity(
        id: model.status.id,
        code: model.status.code,
        name: model.status.name,
      ),
      source: SourceEntity(
        id: model.source.id,
        code: model.source.code,
        name: model.source.name,
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
              userId: model.staff!.userId, // ✅ AGREGADO: userId es requerido
              displayName: model.staff!.displayName,
              specialty: model.staff!.specialty,
              colorTag: model.staff!.colorTag,
              positionId: model.staff!.positionId, // ✅ AGREGADO
              photoUrl: model.staff!.photoUrl, // ✅ AGREGADO
              commissionType: model.staff!.commissionType, // ✅ AGREGADO
              commissionValue: model.staff!.commissionValue, // ✅ AGREGADO
            )
          : null,
      services: model.services
          .map(
            (s) => ServiceEntity(
              id: s.serviceId,
              branchId: s.branchId ?? '', // ✅ CORREGIDO: manejar nullable
              categoryId: s.categoryId,
              name: s.serviceName ?? '',
              description: s.description,
              durationMin: s.durationMin,
              basePrice: s.basePrice ?? 0.0, // ✅ CORREGIDO: manejar nullable
              enabled: s.enabled ?? true, // ✅ CORREGIDO: manejar nullable
            ),
          )
          .toList(),
    );
  }

  /// Convierte una Entity (domain) a Model (data)
  Appointment _mapToModel(AppointmentEntity entity) {
    return Appointment(
      id: entity.id,
      branchId: entity.branchId,
      customerId: entity.customerId,
      staffId: entity.staffProfileId, // → staffId
      startAt: entity.startAt,
      endAt: entity.endAt,
      notes: entity.notes,
      status: Status(
        id: entity.status.id, // id de la entity
        code: entity.status.code,
        name: entity.status.name, //  label → name
      ),
      source: Source(
        id: entity.source.id, // ✅ CORREGIDO: usar el id de la entity
        code: entity.source.code,
        name: entity.source.name,
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
              userId: entity.staff!.userId, // ✅ AGREGADO: userId es requerido
              displayName: entity.staff!.displayName, // ✅ CORREGIDO: name → displayName
              specialty: entity.staff!.specialty,
              colorTag: entity.staff!.colorTag,
              positionId: entity.staff!.positionId, // ✅ AGREGADO
              photoUrl: entity.staff!.photoUrl, // ✅ AGREGADO
              commissionType: entity.staff!.commissionType, // ✅ AGREGADO
              commissionValue: entity.staff!.commissionValue, // ✅ AGREGADO
            )
          : null,
      services: entity.services
          .map(
            (s) => AppointmentService(
              id: '', // Se genera en el backend
              appointmentId: entity.id,
              serviceId: s.id,
              durationMin: s.durationMin,
              price: s.basePrice, // ✅ CORREGIDO: quitar ?? 0.0 porque basePrice ya no es nullable
              // Campos del JOIN (se llenan al recibir del backend)
              serviceName: s.name,
              branchId: s.branchId,
              categoryId: s.categoryId,
              description: s.description,
              basePrice: s.basePrice,
              enabled: s.enabled,
            ),
          )
          .toList(),
    );
  }
}
