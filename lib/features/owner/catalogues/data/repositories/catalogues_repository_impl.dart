import 'package:agenda_app/features/owner/catalogues/data/datasources/catalogues_datasource.dart';
import 'package:agenda_app/features/owner/catalogues/data/models/catalogue_item.dart';
import 'package:agenda_app/features/owner/catalogues/domain/entities/service_entity.dart';  // ✅ AGREGAR
import 'package:agenda_app/features/owner/catalogues/domain/entities/staff_entity.dart';     // ✅ AGREGAR
import 'package:agenda_app/features/owner/catalogues/domain/repositories/catalogues_repository.dart';

class CataloguesRepositoryImpl implements CataloguesRepository {
  final CataloguesDatasource datasource;

  CataloguesRepositoryImpl({
    required this.datasource,
  });

  @override
  Future<List<ServiceEntity>> getServices() async {  // ✅ CORREGIDO: Service → ServiceEntity
    final services = await datasource.getServices();  // Devuelve List<Service>
    return services.map((service) => service.toEntity()).toList();  // ✅ Convertir a ServiceEntity
  }

  @override
  Future<List<StaffEntity>> getStaff() async {  // ✅ CORREGIDO: Staff → StaffEntity
    final staff = await datasource.getStaff();  // Devuelve List<Staff>
    return staff.map((s) => s.toEntity()).toList();  // ✅ Convertir a StaffEntity
  }

  @override
  Future<List<CatalogueItem>> getAppointmentStatuses() {
    return datasource.getAppointmentStatuses();
  }
}
