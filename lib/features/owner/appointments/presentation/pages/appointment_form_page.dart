import 'package:agenda_app/core/di/auth_di.dart';
import 'package:agenda_app/features/owner/appointments/data/repositories/appointments_repository_impl.dart';
import 'package:agenda_app/features/owner/appointments/domain/entities/customer_entity.dart';
import 'package:agenda_app/features/owner/appointments/domain/inputs/create_appointement_input.dart';
import 'package:agenda_app/features/owner/appointments/domain/use_cases/create_appointment.dart';
import 'package:agenda_app/features/owner/appointments/presentation/providers/customer_provider.dart';
import 'package:agenda_app/features/owner/catalogues/domain/entities/service_entity.dart';
import 'package:agenda_app/features/owner/catalogues/domain/repositories/catalogues_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AppointmentFormPage extends ConsumerStatefulWidget {
  final AppointmentsRepositoryImpl repo;

  const AppointmentFormPage({
    super.key,
    required this.repo,
  });

  @override
  ConsumerState<AppointmentFormPage> createState() =>
      _AppointmentFormPageState();
}

class _AppointmentFormPageState extends ConsumerState<AppointmentFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();

  late final CataloguesRepository _cataloguesRepo;

  List<ServiceEntity> _services = []; // ✅ CORREGIDO
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
    } catch (e) {
      debugPrint('Error cargando servicios: $e'); // ✅ Cambiar print por debugPrint
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveAppointment() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    try {
      final customerState = ref.read(customerProvider);

      if (customerState.customer == null) {
        _showError('Debe seleccionar o crear un cliente');
        return;
      }

      if (_selectedServices.isEmpty) {
        _showError('Debe seleccionar al menos un servicio');
        return;
      }

      final startAt = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      final input = CreateAppointmentInput(
        customerId: customerState.customer!.id,
        customer: CustomerEntity(
          id: customerState.customer!.id,
          userId: customerState.customer!.userId,
          referredBy: customerState.customer!.referredBy,
          taxIdentification: customerState.customer!.taxIdentification,
          taxName: customerState.customer!.taxName,
          fullName: customerState.customer!.fullName,
          phone: customerState.customer!.phone,
          email: customerState.customer!.email,
          allergies: customerState.customer!.allergies,
        ),
        startAt: startAt,
        services: List<ServiceEntity>.from(_selectedServices),
        source: _selectedSource,
        notes: _notesController.text,
      );

      final createUseCase = CreateAppointmentUseCase(widget.repo);
      await createUseCase.call(input);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Cita creada exitosamente'),
          backgroundColor: Colors.green,
        ),
      );

      context.pop(true);
    } catch (e) {
      if (!mounted) return;
      _showError('Error al crear la cita: $e');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget _buildClienteSelector() {
    final clienteState = ref.watch(customerProvider);

    if (clienteState.customer == null) {
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
        title: Text(clienteState.customer!.fullName ?? 'Sin nombre'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('CI: ${clienteState.customer!.taxIdentification ?? 'N/A'}'),
            Text('Tel: ${clienteState.customer!.phone ?? 'N/A'}'),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.swap_horiz),
          onPressed: _irABuscarCliente,
        ),
      ),
    );
  }

  Future<void> _irABuscarCliente() async {
    final clienteSeleccionado = await context.push(
      '/owner/appointments/cliente/buscar',
    );

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
      appBar: AppBar(
        title: const Text('Nueva Cita'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSection(
              title: 'Cliente',
              icon: Icons.person,
              child: _buildClienteSelector(),
            ),
            const SizedBox(height: 16),
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
            _buildSection(
              title: 'Servicios',
              icon: Icons.spa,
              child: _buildServicesSelector(),
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: 'Fuente de la cita',
              icon: Icons.source,
              child: _buildSourceSelector(),
            ),
            const SizedBox(height: 16),
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
    if (_services.isEmpty) {
      return const Text('No hay servicios disponibles');
    }

    return Column(
      children: _services.map((service) {
        final isSelected = _selectedServices.any((selected) => selected.id == service.id);

        return CheckboxListTile(
          title: Text(service.name),
          subtitle: Text(
            '${service.durationLabel} • \$${service.basePrice.toStringAsFixed(2)}',
          ),
          value: isSelected,
          onChanged: (checked) {
            setState(() {
              if (checked == true) {
                _selectedServices.add(service);
              } else {
                _selectedServices.removeWhere((item) => item.id == service.id);
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
          onSelected: (_) => setState(() => _selectedSource = source['id']),
          selectedColor: const Color(0xFF8B5CF6),
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        );
      }).toList(),
    );
  }
} // ✅ Llave de cierre de la clase _AppointmentFormPageState
