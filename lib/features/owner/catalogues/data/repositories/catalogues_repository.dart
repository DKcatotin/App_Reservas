import 'package:agenda_app/features/owner/catalogues/data/models/catalogue_item.dart';
import 'package:agenda_app/features/owner/catalogues/data/sources/catalogues_api_datasource.dart';

class CataloguesRepository {
  final CataloguesApiDatasource api;

  CataloguesRepository({required this.api});

  Future<List<CatalogueItem>> getAppointmentStatuses() {
    return api.getAppointmentStatuses();
  }
}
