import 'package:agenda_app/features/owner/appointments/data/models/customer.dart';
import 'package:agenda_app/features/owner/appointments/presentation/providers/customer_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CustomerSearchPage extends ConsumerStatefulWidget {
  const CustomerSearchPage({super.key});

  @override
  ConsumerState<CustomerSearchPage> createState() => _CustomerSearchPageState();
}

class _CustomerSearchPageState extends ConsumerState<CustomerSearchPage> {
  final _taxIdController = TextEditingController();
  bool _searched = false;

  @override
  void dispose() {
    _taxIdController.dispose();
    super.dispose();
  }

  Future<void> _searchCustomer() async {
    final taxId = _taxIdController.text.trim();

    if (taxId.isEmpty || taxId.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Ingrese una cédula válida de 10 dígitos')),
      );
      return;
    }

    await ref.read(customerProvider.notifier).searchByTaxIdentification(taxId);
    setState(() => _searched = true);
  }

  @override
  Widget build(BuildContext context) {
    final customerState = ref.watch(customerProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Buscar Cliente'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Ilustración
            Icon(
              Icons.person_search,
              size: 100,
              color: Theme.of(context).primaryColor.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 24),

            // Instrucciones
            const Text(
              'Ingrese la cédula del cliente',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Busca un cliente existente en el sistema',
              style: TextStyle(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Campo de cédula
            TextField(
              controller: _taxIdController,
              decoration: const InputDecoration(
                labelText: 'Cédula',
                hintText: '1712345678',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.badge),
              ),
              keyboardType: TextInputType.number,
              maxLength: 10,
              enabled: !customerState.isLoading,
              onSubmitted: (_) => _searchCustomer(),
            ),
            const SizedBox(height: 10),

            // Botón buscar
            ElevatedButton.icon(
              onPressed: customerState.isLoading ? null : _searchCustomer,
              icon: customerState.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.search),
              label: const Text('Buscar Cliente'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),

            const SizedBox(height: 20),

            // Resultado de la búsqueda
            if (_searched) ...[
              if (customerState.error != null)
                _buildError(customerState.error!)
              else if (customerState.customer != null)
                _buildCustomerFound(customerState.customer!)
              else if (!customerState.isLoading)
                _buildCustomerNotFound(),
            ],

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerFound(Customer customer) {
    return Card(
      color: Colors.green[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 48),
            const SizedBox(height: 12),
            const Text(
              '✅ Cliente encontrado',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
                Icons.badge, 'Cédula', customer.taxIdentification ?? 'N/A'),
            _buildInfoRow(
                Icons.person, 'Nombre', customer.fullName ?? 'Sin nombre'),
            _buildInfoRow(Icons.phone, 'Celular', customer.phone ?? 'N/A'),
            if (customer.email != null)
              _buildInfoRow(Icons.email, 'Email', customer.email!),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () async {
                final result =
                    await context.push('/owner/citas', extra: customer);

                if (result == true && mounted) {
                  ref.read(customerProvider.notifier).clear();
                  _taxIdController.clear();
                  setState(() => _searched = false);
                }
              },
              label: const Text('Seleccionar este cliente'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerNotFound() {
    return Card(
      color: Colors.orange[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(Icons.person_off, color: Colors.orange[700], size: 48),
            const SizedBox(height: 12),
            Text(
              'Cliente no encontrado',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.orange[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'No existe un cliente con esta cédula en el sistema',
              style: TextStyle(color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildError(String error) {
    return Card(
      color: Colors.red[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(Icons.error_outline, color: Colors.red[700], size: 48),
            const SizedBox(height: 12),
            Text(
              'Error al buscar',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: TextStyle(color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _searchCustomer,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
