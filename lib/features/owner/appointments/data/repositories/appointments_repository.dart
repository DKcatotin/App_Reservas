import 'package:agenda_app/features/owner/appointments/data/models/appointment_service.dart';
import 'package:agenda_app/features/owner/appointments/data/models/customer.dart';
import 'package:agenda_app/features/owner/appointments/data/models/source.dart';
import 'package:agenda_app/features/owner/appointments/data/models/status.dart';
import 'package:agenda_app/features/owner/appointments/domain/create_appointement_input.dart';
import 'package:agenda_app/features/owner/appointments/domain/utils/id_generator.dart';
import 'package:agenda_app/features/owner/catalogues/data/models/service.dart';

import '../models/appointment.dart';
import '../sources/appointments_datasource.dart';
import '../../domain/date_utils.dart';

class AppointmentsRepository {
  final AppointmentsDatasource datasource;

  AppointmentsRepository({required this.datasource});

  // ==================== CACHE ====================
  List<Appointment>? _cache;
  DateTime? _cacheTime;
  final Duration _cacheDuration = const Duration(minutes: 5);

  bool get _isCacheValid =>
      _cache != null &&
      _cacheTime != null &&
      DateTime.now().difference(_cacheTime!) < _cacheDuration;

  void _invalidateCache() {
    _cache = null;
    _cacheTime = null;
  }

  // ==================== CREATE FROM INPUT ====================
  Future<void> createFromInput(CreateAppointmentInput input) async {
    final notes = input.notes?.trim();
    final cleanNotes = (notes == null || notes.isEmpty) ? null : notes;

    final customer = Customer(
      id: IdGenerator.generate('customer'),
      name: input.customerName.trim(),
      phone: input.customerPhone.trim(),
    );

    final int totalMinutes =
        input.services.fold(0, (sum, s) => sum + s.durationMinutes);

    final appointment = Appointment(
      id: IdGenerator.generate('appointment'),
      ownerId: 'owner1',
      branchId: 'branch1',
      customerId: customer.id,
      staffId: null, // staff se asigna luego en edición
      startAt: input.startAt,
      endAt: input.startAt.add(Duration(minutes: totalMinutes)),
      notes: cleanNotes,
      status: Status(code: 'pending', label: 'Pendiente'),
      source: Source(type: input.source),
      customer: customer,
      staff: null,
      services: input.services.map((Service s) {
        return AppointmentService(
          id: s.id,
          name: s.name,
          durationMinutes: s.durationMinutes,
        );
      }).toList(),
    );

    await create(appointment);
  }

  // ==================== READ ====================
  Future<List<Appointment>> getAll({bool forceRefresh = false}) async {
    if (!forceRefresh && _isCacheValid) {
      return _cache!;
    }

    _cache = await datasource.getAll();
    _cacheTime = DateTime.now();
    return _cache!;
  }

  Future<List<Appointment>> getByDay(DateTime day) async {
    final all = await getAll();

    final result = all.where((a) {
      return isSameDate(a.startAt, day);
    }).toList();

    result.sort((a, b) => a.startAt.compareTo(b.startAt));
    return result;
  }

  Future<List<Appointment>> getToday() {
    return getByDay(DateTime.now());
  }

  // Citas futuras (>= mañana)
  Future<List<Appointment>> getUpcoming() async {
    final all = await getAll();
    final today = DateTime.now();

    final result = all.where((a) {
      final d = a.startAt;
      return !isSameDate(d, today) && d.isAfter(today);
    }).toList();

    result.sort((a, b) => a.startAt.compareTo(b.startAt));
    return result;
  }

  // ==================== WRITE ====================
  Future<void> create(Appointment appointment) async {
    await datasource.create(appointment);
    _invalidateCache();
  }

  Future<void> update(Appointment appointment) async {
    await datasource.update(appointment);
    _invalidateCache();
  }

  Future<void> delete(String id) async {
    await datasource.delete(id);
    _invalidateCache();
  }
}
