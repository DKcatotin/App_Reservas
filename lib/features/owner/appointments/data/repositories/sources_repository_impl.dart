import 'package:agenda_app/core/errors/exceptions.dart';
import 'package:agenda_app/core/errors/failures.dart';
import 'package:agenda_app/features/owner/appointments/data/sources/datasources/source_datasource.dart';
import 'package:agenda_app/features/owner/catalogues/data/repositories/sources_repository.dart';
import '../../domain/entities/source_entity.dart';

class SourcesRepositoryImpl implements SourcesRepository {
  final SourcesDatasource remoteDatasource;

  // localDatasource es OPCIONAL ahora
  SourcesRepositoryImpl({
    required this.remoteDatasource,
  });

  @override
  Future<List<SourceEntity>> getSources({String? type}) async {
    try {
      final sources = await remoteDatasource.getSources(type: type);
      return sources.map((source) => source.toEntity()).toList();
    } on ServerException catch (e) {
      throw AppointmentsFailure(e.message);
    } catch (e) {
      // Capturar otros errores también
      throw AppointmentsFailure('Error al obtener sources: $e');
    }
  }
}
