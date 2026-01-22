import 'package:dio/dio.dart';
import '../../features/owner/appointments/data/sources/customer/customers_datasource.dart';
import '../../features/owner/appointments/data/sources/customer/customers_local_datasource.dart';
import '../../features/owner/appointments/data/sources/customer/customers_remote_datasource.dart';

class CustomersDependencies {
  late final CustomersDatasource customersDatasource;

  void init({required Dio dio, bool useRemote = true}) {
    if (useRemote) {
      print('🟢 Usando CustomersRemoteDatasource'); // DEBUG
      customersDatasource = CustomersRemoteDatasource(client: dio);
    } else {
      print('🟡 Usando CustomersLocalDatasource (mock)'); // DEBUG
      customersDatasource = CustomersLocalDatasource();
    }
  }
}
