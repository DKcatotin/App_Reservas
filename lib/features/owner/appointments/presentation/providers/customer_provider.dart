import 'package:agenda_app/core/logger/app_logger.dart';
import 'package:agenda_app/features/owner/appointments/data/sources/customer/customers_datasource.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/customer.dart';
import '../../../../../core/di/app_dependencies.dart'; // ← IMPORTAR

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
    AppLogger.d('🔵 [PROVIDER] Buscando customer por cédula: $taxIdentification');
    state = CustomerState(isLoading: true);

    try {
      AppLogger.d('🔵 [PROVIDER] Llamando datasource...');
      
      final customerFound = await datasource.getByTaxIdentification(taxIdentification);
      AppLogger.d('🔵 [PROVIDER] Resultado: ${customerFound?.fullName ?? "null"}');

      if (customerFound != null) {
        state = CustomerState(customer: customerFound);
      } else {
        state = CustomerState(error: 'Cliente no encontrado');
      }
    } catch (e, stackTrace) {
      AppLogger.d('🔴 [PROVIDER] Error: $e');
      AppLogger.d('🔴 [PROVIDER] StackTrace: $stackTrace');
      state = CustomerState(error: 'Error al buscar cliente: $e');
    }
  }

  /// Clear state
  void clear() {
    state = CustomerState();
  }
}

// ✅ SOLUCIÓN: Usar el datasource de AppDependencies
final customersDatasourceProvider = Provider<CustomersDatasource>((ref) {
  return AppDependencies().customersDatasource; // ← USAR DI
});

/// Customer state provider
final customerProvider =
    StateNotifierProvider<CustomerNotifier, CustomerState>((ref) {
  final datasource = ref.watch(customersDatasourceProvider);
  return CustomerNotifier(datasource);
});