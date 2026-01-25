import 'package:agenda_app/features/owner/appointments/domain/entities/source_entity.dart';

abstract class SourcesRepository {
  Future<List<SourceEntity>> getSources({String? type});
}
