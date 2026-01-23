import 'package:dio/dio.dart';
import '../../features/owner/appointments/data/sources/customer/customers_datasource.dart';
import '../../features/owner/appointments/data/sources/customer/customers_local_datasource.dart';
import '../../features/owner/appointments/data/sources/customer/customers_remote_datasource.dart';
import 'package:logger/logger.dart';


class CustomersDependencies {
  late final CustomersDatasource customersDatasource;
  final logger = Logger();
  void init({required Dio dio, bool useRemote = true}) {
    if (useRemote) {
      logger.d('🟢 Usando CustomersRemoteDatasource'); // DEBUG
      customersDatasource = CustomersRemoteDatasource(client: dio);
    } else {
      logger.d('🟡 Usando CustomersLocalDatasource (mock)'); // DEBUG
      customersDatasource = CustomersLocalDatasource();
    }
  }
}
