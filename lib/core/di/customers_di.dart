import 'package:agenda_app/core/logger/app_logger.dart';
import 'package:dio/dio.dart';
import '../../features/owner/appointments/data/sources/customer/customers_datasource.dart';
import '../../features/owner/appointments/data/sources/customer/customers_local_datasource.dart';
import '../../features/owner/appointments/data/sources/customer/customers_remote_datasource.dart';


class CustomersDependencies {
  late final CustomersDatasource customersDatasource;
  void init({required Dio dio, bool useRemote = true}) {
    if (useRemote) {
      AppLogger.d('Usando CustomersRemoteDatasource'); // DEBUG
      customersDatasource = CustomersRemoteDatasource(client: dio);
    } else {
      AppLogger.d('Usando CustomersLocalDatasource (mock)'); // DEBUG
      customersDatasource = CustomersLocalDatasource();
    }
  }
}
