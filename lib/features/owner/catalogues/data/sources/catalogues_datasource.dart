import 'package:agenda_app/features/owner/catalogues/data/models/catalogue_item.dart';
import 'package:agenda_app/features/owner/catalogues/data/models/status.dart';

import '../models/service.dart';
import '../models/staff.dart';

/// Contrato para fuentes de datos de catálogos.
/// Implementaciones: CataloguesLocalDatasource (JSON), CataloguesRemoteDatasource (HTTP).
abstract class CataloguesDatasource {
  /// Obtiene la lista de servicios disponibles.
  Future<List<Service>> getServices();

  /// Obtiene la lista de personal (staff).
  Future<List<Staff>> getStaff();
  
 Future<List<CatalogueItem>> getAppointmentStatuses();
  // Agregar getStatuses() si lo necesitas para appointment_statuses
   Future<List<Status>> getStatuses();
}
