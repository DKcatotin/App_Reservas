import 'package:agenda_app/features/owner/catalogues/data/sources/catalogues_datasource.dart';
import 'package:agenda_app/features/owner/catalogues/data/models/catalogue_item.dart';
import 'package:agenda_app/features/owner/catalogues/domain/entities/service_entity.dart';
import 'package:agenda_app/features/owner/catalogues/domain/entities/staff_entity.dart';
import 'package:agenda_app/features/owner/catalogues/domain/entities/status_entity.dart';  // ✅ IMPORTAR
import 'package:agenda_app/features/owner/catalogues/domain/repositories/catalogues_repository.dart';

class CataloguesRepositoryImpl implements CataloguesRepository {
  final CataloguesDatasource datasource;

  CataloguesRepositoryImpl({
    required this.datasource,
  });

  @override
  Future<List<ServiceEntity>> getServices() async {
    final services = await datasource.getServices();
    return services.map((service) => service.toEntity()).toList();
  }

  @override
  Future<List<StaffEntity>> getStaff() async {
    final staff = await datasource.getStaff();
    return staff.map((s) => s.toEntity()).toList();
  }

  @override
  Future<List<CatalogueItem>> getAppointmentStatuses() {
    return datasource.getAppointmentStatuses();
  }

  // ✅ NUEVO MÉTODO
  @override
  Future<List<StatusEntity>> getStatuses() async {
    final statuses = await datasource.getStatuses();
    return statuses.map((s) => s.toEntity()).toList();
  }
}