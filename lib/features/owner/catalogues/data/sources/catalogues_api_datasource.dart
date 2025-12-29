import 'package:dio/dio.dart';
import '../../../catalogues/data/models/catalogue_item.dart';

class CataloguesApiDatasource {
  final Dio dio;

  CataloguesApiDatasource(this.dio);

  Future<List<CatalogueItem >> getAppointmentStatuses() async {
    final res = await dio.get('/test1');

    final data = res.data['data'] as List<dynamic>;

    return data
        .map((e) => CatalogueItem .fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
