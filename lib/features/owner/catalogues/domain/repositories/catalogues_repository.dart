import 'package:agenda_app/features/owner/catalogues/data/models/catalogue_item.dart';
import 'package:agenda_app/features/owner/catalogues/domain/entities/service_entity.dart';
import 'package:agenda_app/features/owner/catalogues/domain/entities/staff_entity.dart';
import 'package:agenda_app/features/owner/catalogues/domain/entities/status_entity.dart';

/// Contrato del repository de catálogos.
/// Define los casos de uso de acceso a catálogos.
abstract class CataloguesRepository {
  Future<List<ServiceEntity>> getServices();
  Future<List<StaffEntity>> getStaff();
  Future<List<CatalogueItem>> getAppointmentStatuses();
  Future<List<StatusEntity>> getStatuses(); 
}
