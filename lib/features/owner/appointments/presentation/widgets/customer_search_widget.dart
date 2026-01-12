import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/customer_provider.dart';

class BuscarClienteWidget extends ConsumerStatefulWidget {
  const BuscarClienteWidget({super.key});

  @override
  ConsumerState<BuscarClienteWidget> createState() =>
      _BuscarClienteWidgetState();
}

class _BuscarClienteWidgetState extends ConsumerState<BuscarClienteWidget> {
  final _cedulaController = TextEditingController();
  final _nombreController = TextEditingController();
  final _celularController = TextEditingController();

  bool _clienteExiste = false;
  bool _mostrarFormulario = false;

  @override
  void dispose() {
    _cedulaController.dispose();
    _nombreController.dispose();
    _celularController.dispose();
    super.dispose();
  }

  Future<void> _buscarCliente() async {
    final cedula = _cedulaController.text.trim();

    if (cedula.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingrese una cédula')),
      );
      return;
    }

    // Buscar cliente
    await ref.read(clienteProvider.notifier).buscarPorCedula(cedula);

    final state = ref.read(clienteProvider);

    if (state.cliente != null) {
      // Cliente encontrado, llenar campos
      setState(() {
        _nombreController.text = state.cliente!.nombre;
        _celularController.text = state.cliente!.celular;
        _clienteExiste = true;
        _mostrarFormulario = true;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Cliente encontrado'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      // Cliente no existe, limpiar para crear nuevo
      setState(() {
        _nombreController.clear();
        _celularController.clear();
        _clienteExiste = false;
        _mostrarFormulario = true;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cliente no encontrado. Complete los datos para crearlo'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  Future<void> _guardarNuevoCliente() async {
    final cedula = _cedulaController.text.trim();
    final nombre = _nombreController.text.trim();
    final celular = _celularController.text.trim();

    if (nombre.isEmpty || celular.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Complete todos los campos')),
      );
      return;
    }

    await ref.read(clienteProvider.notifier).crearCliente(
          cedula: cedula,
          nombre: nombre,
          celular: celular,
        );

    setState(() {
      _clienteExiste = true;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Cliente creado exitosamente'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final clienteState = ref.watch(clienteProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Campo de búsqueda por cédula
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _cedulaController,
                decoration: const InputDecoration(
                  labelText: 'Cédula del cliente',
                  hintText: '1712345678',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.badge),
                ),
                keyboardType: TextInputType.number,
                maxLength: 10,
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: clienteState.cargando ? null : _buscarCliente,
              icon: clienteState.cargando
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.search),
              tooltip: 'Buscar cliente',
            ),
          ],
        ),

        // Mostrar formulario si se buscó
        if (_mostrarFormulario) ...[
          const SizedBox(height: 16),
          TextField(
            controller: _nombreController,
            decoration: InputDecoration(
              labelText: 'Nombre completo',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.person),
              enabled: !_clienteExiste,
              suffixIcon: _clienteExiste
                  ? const Icon(Icons.lock, color: Colors.grey)
                  : null,
            ),
            readOnly: _clienteExiste,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _celularController,
            decoration: InputDecoration(
              labelText: 'Celular',
              hintText: '0998765432',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.phone),
              enabled: !_clienteExiste,
              suffixIcon: _clienteExiste
                  ? const Icon(Icons.lock, color: Colors.grey)
                  : null,
            ),
            keyboardType: TextInputType.phone,
            maxLength: 10,
            readOnly: _clienteExiste,
          ),
          
          // Botón para crear cliente nuevo
          if (!_clienteExiste) ...[
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _guardarNuevoCliente,
              icon: const Icon(Icons.person_add),
              label: const Text('Crear cliente'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ],
      ],
    );
  }
}
