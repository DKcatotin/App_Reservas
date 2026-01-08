import 'package:agenda_app/features/owner/catalogues/data/datasources/catalogues_datasource.dart';
import 'package:agenda_app/features/owner/catalogues/data/models/catalogue_item.dart';
import 'package:agenda_app/features/owner/catalogues/data/models/service.dart';
import 'package:agenda_app/features/owner/catalogues/data/models/staff_full.dart';
import 'package:agenda_app/features/owner/catalogues/domain/repositories/catalogues_repository.dart';

class CataloguesRepositoryImpl implements CataloguesRepository {
  final CataloguesDatasource datasource;

  CataloguesRepositoryImpl({
    required this.datasource,
  });

  @override
  Future<List<Service>> getServices() {
    return datasource.getServices();
  }

  @override
  Future<List<StaffFull>> getStaff() {
    return datasource.getStaff();
  }

  @override
  Future<List<CatalogueItem>> getAppointmentStatuses() {
    return datasource.getAppointmentStatuses();
  }
}
