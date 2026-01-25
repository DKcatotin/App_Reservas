import '../../models/source.dart';

abstract class SourcesDatasource {
  Future<List<Source>> getSources({String? type});
}
