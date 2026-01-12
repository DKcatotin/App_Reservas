import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/customer_model.dart';
import '../providers/customer_provider.dart';

class ClienteBusquedaPage extends ConsumerStatefulWidget {
  const ClienteBusquedaPage({super.key});

  @override
  ConsumerState<ClienteBusquedaPage> createState() =>
      _ClienteBusquedaPageState();
}

class _ClienteBusquedaPageState extends ConsumerState<ClienteBusquedaPage> {
  final _cedulaController = TextEditingController();
  bool _buscado = false;

  @override
  void dispose() {
    _cedulaController.dispose();
    super.dispose();
  }

  Future<void> _buscarCliente() async {
    final cedula = _cedulaController.text.trim();

    if (cedula.isEmpty || cedula.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingrese una cédula válida de 10 dígitos')),
      );
      return;
    }

    await ref.read(clienteProvider.notifier).buscarPorCedula(cedula);
    setState(() => _buscado = true);
  }

void _irACrearCliente() {
  final cedula = _cedulaController.text.trim();
  context.push(
    '/owner/appointments/cliente/new',
    extra: cedula,
  ).then((_) {
    context.push('/owner/citas'); // correcto
  });
}

   

 @override
Widget build(BuildContext context) {
  final clienteState = ref.watch(clienteProvider);

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
            color: Theme.of(context).primaryColor.withValues(alpha:0.5),
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
            'Si el cliente no existe, podrá crearlo',
            style: TextStyle(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Campo de cédula
          TextField(
            controller: _cedulaController,
            decoration: const InputDecoration(
              labelText: 'Cédula',
              hintText: '1712345678',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.badge),
            ),
            keyboardType: TextInputType.number,
            maxLength: 10,
            onSubmitted: (_) => _buscarCliente(),
          ),
          const SizedBox(height: 10),

          // Botón buscar
          ElevatedButton.icon(
            onPressed: clienteState.cargando ? null : _buscarCliente,
            icon: clienteState.cargando
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
          if (_buscado) ...[
            if (clienteState.cliente != null)
              _buildClienteEncontrado(clienteState.cliente!)
            else
              _buildClienteNoEncontrado(),
          ],

          const SizedBox(height: 20),
        ],
      ),
    ),
  );
}
  

  Widget _buildClienteEncontrado(ClienteModel cliente) {
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
            _buildInfoRow(Icons.badge, 'Cédula', cliente.cedula),
            _buildInfoRow(Icons.person, 'Nombre', cliente.nombre),
            _buildInfoRow(Icons.phone, 'Celular', cliente.celular),
            const SizedBox(height: 16),
            ElevatedButton.icon(
 onPressed: () {
    // El provider ya tiene el cliente (porque lo cargaste en _buscarCliente)
    context.push('/owner/citas'); 
  },
  icon: const Icon(Icons.check),
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
//cliente no encontrado 
  Widget _buildClienteNoEncontrado() {
    return Card(
      color: Colors.orange[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(Icons.person_add, color: Colors.orange[700], size: 48),
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
              'No existe un cliente con esta cédula',
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _irACrearCliente,
              icon: const Icon(Icons.add),
              label: const Text('Crear nuevo cliente'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 10),
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
