import 'package:agenda_app/features/owner/catalogues/data/models/catalogue_item.dart';
import 'package:agenda_app/features/owner/catalogues/data/models/staff_full.dart';
import 'package:agenda_app/features/owner/catalogues/data/models/service.dart';

/// Contrato del repository de catálogos.
/// Define los casos de uso de acceso a catálogos.
abstract class CataloguesRepository {
  Future<List<Service>> getServices();
  Future<List<StaffFull>> getStaff();
  Future<List<CatalogueItem>> getAppointmentStatuses();
}
