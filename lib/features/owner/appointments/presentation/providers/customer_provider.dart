import 'package:agenda_app/core/di/app_dependencies.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/customer.dart';
import '../../data/sources/customer/customers_datasource.dart';
import 'package:logger/logger.dart';

final logger = Logger();
/// Customer state
class CustomerState {
  final Customer? customer;
  final bool isLoading;
  final String? error;

  CustomerState({
    this.customer,
    this.isLoading = false,
    this.error,
  });

  CustomerState copyWith({
    Customer? customer,
    bool? isLoading,
    String? error,
  }) {
    return CustomerState(
      customer: customer ?? this.customer,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// Notifier to manage customer state
class CustomerNotifier extends StateNotifier<CustomerState> {
  final CustomersDatasource datasource;

  CustomerNotifier(this.datasource) : super(CustomerState());

  /// Search customer by tax identification
  Future<void> searchByTaxIdentification(String taxIdentification) async {
  logger.d('🔵 [PROVIDER] Buscando customer por cédula: $taxIdentification'); // DEBUG
  state = CustomerState(isLoading: true);

  try {
    logger.d('🔵 [PROVIDER] Llamando datasource...'); // DEBUG
    final customerFound = await datasource.getByTaxIdentification(taxIdentification);
    logger.d('🔵 [PROVIDER] Resultado: ${customerFound?.fullName ?? "null"}'); // DEBUG

    if (customerFound != null) {
      state = CustomerState(customer: customerFound);
    } else {
      state = CustomerState(error: 'Cliente no encontrado');
    }
  } catch (e, stackTrace) {
    logger.d('🔴 [PROVIDER] Error: $e'); // DEBUG
    logger.d('🔴 [PROVIDER] StackTrace: $stackTrace'); // DEBUG
    state = CustomerState(error: 'Error al buscar cliente: $e');
  }
}
  /// Clear state
  void clear() {
    state = CustomerState();
  }
}

/// Datasource provider - Usa implementación local directamente
final customersDatasourceProvider = Provider<CustomersDatasource>((ref) {
  return AppDependencies().customersDatasource; // ✅ Remote desde DI real
});
/// Customer state provider
final customerProvider =
    StateNotifierProvider<CustomerNotifier, CustomerState>((ref) {
  final datasource = ref.watch(customersDatasourceProvider);
  return CustomerNotifier(datasource);
});
