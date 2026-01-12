import 'package:agenda_app/core/di/auth_di.dart';
import 'package:agenda_app/features/owner/appointments/data/repositories/appointments_repository.dart';
import 'package:agenda_app/features/owner/appointments/domain/entities/service_entity.dart';
import 'package:agenda_app/features/owner/appointments/presentation/providers/customer_provider.dart';
import 'package:agenda_app/features/owner/appointments/domain/inputs/create_appointement_input.dart';
import 'package:agenda_app/features/owner/catalogues/domain/repositories/catalogues_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../catalogues/data/models/service.dart';


class AppointmentFormPage extends ConsumerStatefulWidget {
  final AppointmentsRepository repo;

  const AppointmentFormPage({
    super.key,
    required this.repo,
  });

  @override
  ConsumerState<AppointmentFormPage> createState() =>
      _AppointmentFormPageState();
}

class _AppointmentFormPageState
    extends ConsumerState<AppointmentFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();

  late final CataloguesRepository _cataloguesRepo;

  List<Service> _services = [];
  final List<ServiceEntity> _selectedServices = [];

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _selectedSource = 'whatsapp';

  bool _isLoading = true;
  bool _isSaving = false;

  final List<Map<String, dynamic>> _sources = [
    {'id': 'whatsapp', 'label': 'WhatsApp', 'icon': Icons.chat},
    {'id': 'llamada', 'label': 'Llamada', 'icon': Icons.phone},
    {'id': 'web', 'label': 'Web', 'icon': Icons.language},
    {'id': 'presencial', 'label': 'Presencial', 'icon': Icons.store},
  ];

  @override
  void initState() {
    super.initState();
    _cataloguesRepo = AppDependencies().cataloguesRepository;
    _loadData();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final services = await _cataloguesRepo.getServices();
      setState(() {
        _services = services;
        _isLoading = false;
      });
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveAppointment() async {
  final clienteState = ref.read(clienteProvider);

  if (clienteState.cliente == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Debe seleccionar o crear un cliente')),
    );
    return;
  }

  if (_selectedServices.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Selecciona al menos un servicio')),
    );
    return;
  }

  setState(() => _isSaving = true);

  try {
    final startAt = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final input = CreateAppointmentInput(
      customerName: clienteState.cliente!.nombre,
      customerPhone: clienteState.cliente!.celular,
      startAt: startAt,
      services: List<ServiceEntity>.from(_selectedServices),
      source: _selectedSource,
      notes: _notesController.text,
    );

    await widget.repo.createFromInput(input);

    if (!mounted) return;

    // Cerrar devolviendo true al padre
    context.pop(true);
  } finally {
    if (mounted) setState(() => _isSaving = false);
  }
}


Widget _buildClienteSelector() {
  final clienteState = ref.watch(clienteProvider);

  if (clienteState.cliente == null) {
    return OutlinedButton.icon(
      onPressed: _irABuscarCliente,
      icon: const Icon(Icons.person_search),
      label: const Text('Buscar o crear cliente'),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.all(16),
      ),
    );
  }

  return Card(
    color: Colors.green[50],
    child: ListTile(
      leading: const CircleAvatar(
        child: Icon(Icons.person),
      ),
      title: Text(clienteState.cliente!.nombre),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('CI: ${clienteState.cliente!.cedula}'),
          Text('Tel: ${clienteState.cliente!.celular}'),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.swap_horiz), // más claro que la X
        onPressed: _irABuscarCliente,       // en vez de limpiar solo
      ),
    ),
  );
}

Future<void> _irABuscarCliente() async {
  final clienteSeleccionado = await context.push(
    '/owner/appointments/cliente/buscar',
  );
  
  // El cliente ya está en el provider
  if (clienteSeleccionado != null && mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cliente seleccionado')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Nueva Cita'),
       leading: IconButton(
      icon: const Icon(Icons.close),
      onPressed: () => context.pop(),)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            /// 👤 CLIENTE
           _buildSection(
  title: 'Cliente',
  icon: Icons.person,
  child: _buildClienteSelector(), // 👈 Cambiar esto
),

            const SizedBox(height: 16),

            /// 📅 FECHA Y HORA
            _buildSection(
              title: 'Fecha y hora',
              icon: Icons.event,
              child: Row(
                children: [
                  Expanded(child: _buildDateButton()),
                  const SizedBox(width: 12),
                  Expanded(child: _buildTimeButton()),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// 🧖 SERVICIOS
            _buildSection(
              title: 'Servicios',
              icon: Icons.spa,
              child: _buildServicesSelector(),
            ),

            const SizedBox(height: 16),

            /// 🔗 FUENTE
            _buildSection(
              title: 'Fuente de la cita',
              icon: Icons.source,
              child: _buildSourceSelector(),
            ),

            const SizedBox(height: 16),

            /// 📝 NOTAS
            _buildSection(
              title: 'Notas (opcional)',
              icon: Icons.note,
              child: TextField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Preferencias, alergias, etc.',
                  border: OutlineInputBorder(),
                ),
              ),
            ),

         const SizedBox(height: 24),

SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    onPressed: _isSaving ? null : _saveAppointment,
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 16),
      backgroundColor: const Color(0xFF8B5CF6),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    child: Text(_isSaving ? 'Guardando...' : 'Crear Cita'),
  ),
),


          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildDateButton() {
    return OutlinedButton(
      onPressed: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
          locale: const Locale('es'),
        );
        if (picked != null) setState(() => _selectedDate = picked);
      },
      child: Text(DateFormat('dd/MM/yyyy').format(_selectedDate)),
    );
  }

  Widget _buildTimeButton() {
    return OutlinedButton(
      onPressed: () async {
        final picked =
            await showTimePicker(context: context, initialTime: _selectedTime);
        if (picked != null) setState(() => _selectedTime = picked);
      },
      child: Text(_selectedTime.format(context)),
    );
  }

  Widget _buildServicesSelector() {
  return Column(
    children: _services.map((s) {
      //  Convertir Service a ServiceEntity para comparar
      final serviceEntity = ServiceEntity(
        id: s.id,
        name: s.name,
        durationMinutes: s.durationMinutes,
      );
      
      // Verificar si ya está seleccionado (comparando por id)
      final isSelected = _selectedServices.any((selected) => selected.id == s.id);
      
      return CheckboxListTile(
        title: Text(s.name),
        subtitle: Text('${s.durationLabel} • \$${s.price}'),
        value: isSelected,
        onChanged: (checked) {
          setState(() {
            if (checked == true) {
              // Agregar como entity
              _selectedServices.add(serviceEntity);
            } else {
              // Remover por id
              _selectedServices.removeWhere((item) => item.id == s.id);
            }
          });
        },
      );
    }).toList(),
  );
}


  Widget _buildSourceSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _sources.map((source) {
        final isSelected = _selectedSource == source['id'];
        return ChoiceChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                source['icon'],
                size: 18,
                color: isSelected ? Colors.white : Colors.black54,
              ),
              const SizedBox(width: 6),
              Text(source['label']),
            ],
          ),
          selected: isSelected,
          onSelected: (_) =>
              setState(() => _selectedSource = source['id']),
          selectedColor: const Color(0xFF8B5CF6),
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        );
      }).toList(),
    );
  }
}
