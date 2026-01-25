import 'package:agenda_app/features/owner/appointments/data/sources/appointments/appointments_datasource.dart';
import 'package:agenda_app/features/owner/appointments/data/sources/appointments/appointments_remote_datasource.dart';
import 'package:agenda_app/features/owner/appointments/data/sources/datasources/source_datasource.dart';
import 'package:agenda_app/features/owner/appointments/data/sources/datasources/sources_remote_datasource.dart';
import 'package:agenda_app/features/owner/catalogues/data/sources/catalogues_datasource.dart';
import 'package:agenda_app/features/owner/catalogues/data/sources/catalogues_remote_datasource.dart';
import 'package:agenda_app/features/owner/catalogues/data/repositories/sources_repository.dart';
import 'package:agenda_app/features/owner/catalogues/data/repositories/sources_repository_impl.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupInjection() async {
  // Sources
  getIt.registerLazySingleton<SourcesDatasource>(
    () => SourcesRemoteDatasource(apiClient: getIt()),
  );

  getIt.registerLazySingleton<SourcesRepository>(
    () => SourcesRepositoryImpl(datasource: getIt()),
  );

  // Appointments
  getIt.registerLazySingleton<AppointmentsDatasource>(
    () => AppointmentsRemoteDatasource(dio: getIt()),
  );

  // Catalogues
  getIt.registerLazySingleton<CataloguesDatasource>(
    () => CataloguesRemoteDatasource(apiClient: getIt()),
  );
}
