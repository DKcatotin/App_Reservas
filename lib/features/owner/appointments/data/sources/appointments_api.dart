import 'package:dio/dio.dart';
import '../models/test_item.dart';

class AppointmentsApi {
  final Dio dio;

  AppointmentsApi(this.dio);

  Future<List<TestItem>> getTest1() async {
    final res = await dio.get('/test1');

    final data = res.data['data'] as List<dynamic>;

    return data
        .map((e) => TestItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
