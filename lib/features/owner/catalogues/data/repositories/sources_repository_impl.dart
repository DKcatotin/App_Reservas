import 'package:agenda_app/core/errors/exceptions.dart';
import 'package:agenda_app/core/errors/failures.dart';
import 'package:agenda_app/features/owner/appointments/data/sources/datasources/source_datasource.dart';
import 'package:agenda_app/features/owner/appointments/domain/entities/source_entity.dart';
import 'package:agenda_app/features/owner/catalogues/data/repositories/sources_repository.dart';

class SourcesRepositoryImpl implements SourcesRepository {
  final SourcesDatasource datasource;

  SourcesRepositoryImpl({required this.datasource});

  @override
  Future<List<SourceEntity>> getSources({String? type}) async {
    try {
      final sources = await datasource.getSources(type: type);
      return sources.map((source) => source.toEntity()).toList();
    } on ServerException catch (e) {
      throw AppointmentsFailure(e.message);
    } catch (e) {
      throw AppointmentsFailure('Error al obtener sources: $e');
    }
  }
}
