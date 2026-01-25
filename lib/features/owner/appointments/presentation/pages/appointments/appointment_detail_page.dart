// lib/features/owner/appointments/presentation/pages/appointment_detail_page.dart
import 'dart:convert';
import 'package:agenda_app/features/owner/catalogues/presentation/provider/services_provider.dart';
import 'package:agenda_app/features/owner/catalogues/presentation/widgets/custom_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
// Domain
import '../../../domain/entities/appointment_entity.dart';
import '../../../domain/use_cases/update_appointment.dart';
import '../../../domain/use_cases/delete_appointment.dart';
// Data
import '../../../data/repositories/appointments_repository_impl.dart';
import '../../../../catalogues/data/models/staff.dart';
import '../../../../catalogues/data/models/service.dart';
// Entities from catalogues
import '../../../../catalogues/domain/entities/service_entity.dart';
import '../../../../catalogues/domain/entities/staff_entity.dart';
// Providers
import '../../providers/staff_provider.dart';
// Widgets - Reutilizables de catalogues
import '../../../../catalogues/presentation/widgets/service_selector.dart';
import '../../../../catalogues/presentation/widgets/staff_selector.dart';
// Widgets - Específicos de appointments
import '../../widgets/appointments/appointment_header.dart';
import '../../widgets/appointments/appointment_date_time_section.dart';
import '../../widgets/appointments/appointment_status_selector.dart';
import '../../widgets/appointments/appointment_notes_section.dart';
import '../../widgets/customer/customer_info_card.dart';
// Widgets - Shared
class AppointmentDetailPage extends ConsumerStatefulWidget {
  final AppointmentEntity appointment;
  final AppointmentsRepositoryImpl repository;
  final Future<void> Function(AppointmentEntity)? onAppointmentUpdated;
  final Future<void> Function(String)? onAppointmentDeleted;

  const AppointmentDetailPage({
    super.key,
    required this.appointment,
    this.onAppointmentUpdated,
    this.onAppointmentDeleted,
    required this.repository,
  });
  @override
  ConsumerState<AppointmentDetailPage> createState() =>
      _AppointmentDetailPageState();
}
class _AppointmentDetailPageState extends ConsumerState<AppointmentDetailPage> {
  // Estado de edición
  bool _isEditing = false;

  // Datos de la cita
  late DateTime _selectedDate;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  late String _selectedStatus;
  List<ServiceEntity> _selectedServices = [];
  String? _selectedStaffId;
  // Controladores de texto
  late TextEditingController _notesController;
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  // Listas de datos
  List<Staff> _staffList = [];
  Set<String> _selectedServiceIds = {};
  List<ServiceEntity> _allServices = [];
  bool _isLoadingServices = true;
  // Use cases
  late UpdateAppointmentUseCase _updateAppointmentUseCase;
  late DeleteAppointmentUseCase _deleteAppointmentUseCase;

  @override
  void initState() {
    super.initState();
    _initializeData();
    _initializeUseCases();
  }

  void _initializeData() {
    _selectedDate = widget.appointment.startAt;
    _startTime = TimeOfDay.fromDateTime(widget.appointment.startAt);
    _endTime = TimeOfDay.fromDateTime(widget.appointment.endAt);
    _selectedStatus = widget.appointment.status.name;
    _selectedServices = widget.appointment.services;
    _selectedStaffId = widget.appointment.staff?.id;
    _selectedServiceIds = _selectedServices.map((s) => s.id).toSet();

    _notesController = TextEditingController(text: widget.appointment.notes ?? '');
    _nameController = TextEditingController(text: widget.appointment.customer.fullName);
    _phoneController = TextEditingController(text: widget.appointment.customer.phone);
  }

  void _initializeUseCases() {
    _updateAppointmentUseCase = UpdateAppointmentUseCase(widget.repository);
    _deleteAppointmentUseCase = DeleteAppointmentUseCase(widget.repository);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadStaffFromProvider();
     _loadServicesFromProvider();
  }

  void _loadStaffFromProvider() {
    final staffAsync = ref.watch(staffListProvider);
    staffAsync.whenData((list) {
      if (mounted && _staffList.isEmpty) {
        setState(() => _staffList = list);
      }
    });
  }
void _loadServicesFromProvider() {
  final servicesAsync = ref.watch(servicesListProvider);
  
  servicesAsync.when(
    data: (list) {
      if (mounted && _allServices.isEmpty) {
        setState(() {
          _allServices = list.map((s) => s.toEntity()).toList();
          _isLoadingServices = false;
        });
      }
    },
    loading: () {
      if (mounted) {
        setState(() => _isLoadingServices = true);
      }
    },
    error: (error, stack) {
      if (mounted) {
        setState(() => _isLoadingServices = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar servicios: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    },
  );
}
  void _recalculateEndTime() {
    if (_selectedServices.isEmpty) return;

    int totalMinutes = _selectedServices.fold(0, (sum, service) => sum + service.durationMin);

    final startDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _startTime.hour,
      _startTime.minute,
    );

    final newEndDateTime = startDateTime.add(Duration(minutes: totalMinutes));

    setState(() {
      _endTime = TimeOfDay.fromDateTime(newEndDateTime);
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF7C3AED),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1F2937),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _startTime : _endTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF7C3AED),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1F2937),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && isStartTime) {
      setState(() {
        _startTime = picked;
        _recalculateEndTime();
      });
    }
  }

 Future<void> _sendWhatsAppReminder() async {
  final dateFormatter = DateFormat('EEEE dd MMM yyyy', 'es');
  final formattedDate = dateFormatter.format(widget.appointment.startAt);
  final timeFormatter = DateFormat('HH:mm');
  final formattedTime = timeFormatter.format(widget.appointment.startAt);
  final services = widget.appointment.services.map((s) => s.name).join(', ');

  String phone = _phoneController.text.replaceAll(RegExp(r'[^\d+]'), '');
  if (!phone.startsWith('+')) {
    phone = phone.startsWith('0') 
      ? '+593${phone.substring(1)}' 
      : '+593$phone';
  }

  final message = '''Francis Nails & Beauty Spa 📢

Recordatorio de cita:
📅 *$formattedDate*
🕓 *$formattedTime*
👤 *${_nameController.text}*
🪪 *${_phoneController.text}*

Servicio: $services

📍 Por favor llegar 10 min antes

¡Gracias por su confianza!''';

  final encodedMessage = Uri.encodeComponent(message);
  final whatsappUrl = Uri.parse('https://wa.me/$phone?text=$encodedMessage');

  try {
    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } else {
      // CORREGIDO: verificar mounted antes de usar context
      if (mounted) {
        _showError('No se pudo abrir WhatsApp');
      }
    }
  } catch (e) {
    //  CORREGIDO: verificar mounted antes de usar context
    if (mounted) {
      _showError('Error al abrir WhatsApp: $e');
    }
  }
}


  Future<void> _confirmDelete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar cita'),
        content: const Text('¿Seguro que deseas eliminar esta cita?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (ok == true && mounted) {
      try {
        await _deleteAppointmentUseCase.call(widget.appointment.id);

        if (mounted) {
          _showSuccess('Cita eliminada exitosamente');

          if (widget.onAppointmentDeleted != null) {
            await widget.onAppointmentDeleted!(widget.appointment.id);
          }

          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) _showError('Error al eliminar: $e');
      }
    }
  }

Future<void> _saveChanges() async {
  final newStartAt = DateTime(
    _selectedDate.year,
    _selectedDate.month,
    _selectedDate.day,
    _startTime.hour,
    _startTime.minute,
  );

  final newEndAt = DateTime(
    _selectedDate.year,
    _selectedDate.month,
    _selectedDate.day,
    _endTime.hour,
    _endTime.minute,
  );

  Staff? selectedStaff;
  if (_selectedStaffId != null) {
    try {
      selectedStaff = _staffList.firstWhere((s) => s.id == _selectedStaffId);
    } catch (e) {
      selectedStaff = null;
    }
  }

  final updatedAppointment = widget.appointment.copyWith(
    startAt: newStartAt,
    endAt: newEndAt,
    notes: _notesController.text.trim().isEmpty
        ? null
        : _notesController.text.trim(),
    status: widget.appointment.status.copyWith(  // ✅ Mantener el ID original
      code: _selectedStatus.toLowerCase(),
      name: _selectedStatus,
    ),
    services: _selectedServices,
    staff: selectedStaff != null
        ? (selectedStaff.id == widget.appointment.staff?.id
            ? widget.appointment.staff
            : StaffEntity(
                id: selectedStaff.id,
                userId: selectedStaff.userId,
                displayName: selectedStaff.displayName,
                specialty: selectedStaff.specialty,
                colorTag: selectedStaff.colorTag,
                positionId: selectedStaff.positionId,
                photoUrl: selectedStaff.photoUrl,
                commissionType: selectedStaff.commissionType,
                commissionValue: selectedStaff.commissionValue,
              ))
        : null,
  );

  try {
    await _updateAppointmentUseCase.call(updatedAppointment);

    if (!mounted) return;
    _showSuccess('Cita actualizada exitosamente');
    
    if (!mounted) return;
    Navigator.pop(context, updatedAppointment);
    
  } catch (e) {
    if (!mounted) return;
    _showError('Error al guardar: $e');
  }
}

  void _cancelEdit() {
  setState(() {
    _isEditing = false;
    _selectedDate = widget.appointment.startAt;
    _startTime = TimeOfDay.fromDateTime(widget.appointment.startAt);
    _endTime = TimeOfDay.fromDateTime(widget.appointment.endAt);
    _selectedStatus = widget.appointment.status.name;
    _notesController.text = widget.appointment.notes ?? '';
    _selectedServices = widget.appointment.services;
    // CORREGIDO: manejar nullables
    _nameController.text = widget.appointment.customer.fullName ?? ''; 
    _phoneController.text = widget.appointment.customer.phone ?? '';
    _selectedServiceIds = _selectedServices.map((s) => s.id).toSet();
  });
}


  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(' $message'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(' $message'),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  void dispose() {
    _notesController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      body: CustomScrollView(
        slivers: [
          // HEADER (refactorizado)
          AppointmentHeader(
            isEditing: _isEditing,
            onEdit: () => setState(() => _isEditing = true),
            onSave: _saveChanges,
            onCancel: _cancelEdit,
            onDelete: _confirmDelete,
          ),

          // CONTENIDO
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  //  CLIENTE (refactorizado)
                  CustomerInfoCard(
                    customer: widget.appointment.customer,
                    isEditing: _isEditing,
                    nameController: _nameController,
                    phoneController: _phoneController,
                    onWhatsAppTap: _isEditing ? null : _sendWhatsAppReminder,
                  ),

                  const SizedBox(height: 16),

                  // FECHA Y HORA (refactorizado)
                  CustomInfoCard.white(
                    icon: Icons.calendar_today_rounded,
                    iconColor: const Color(0xFF7C3AED),
                    title: 'Fecha y Hora',
                    child: AppointmentDateTimeSection(
                      date: _selectedDate,
                      startTime: _startTime,
                      endTime: _endTime,
                      isEditing: _isEditing,
                      onDateTap: () => _selectDate(context),
                      onStartTimeTap: () => _selectTime(context, true),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // EMPLEADO/STAFF (refactorizado)
                  CustomInfoCard.white(
                    icon: Icons.person_outline_rounded,
                    iconColor: const Color(0xFF3B82F6),
                    title: 'Empleado Asignado',
                    child: _buildStaffSection(),
                  ),

                  const SizedBox(height: 16),

                  // ESTADO (refactorizado)
                  CustomInfoCard.white(
                    icon: Icons.info_rounded,
                    iconColor: _getStatusColor(_selectedStatus),
                    title: 'Estado',
                    child: AppointmentStatusSelector(
                      status: _selectedStatus,
                      isEditing: _isEditing,
                      onChanged: (newStatus) {
                        setState(() => _selectedStatus = newStatus);
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // SERVICIOS (refactorizado)
                  CustomInfoCard.white(
                    icon: Icons.spa_rounded,
                    iconColor: const Color(0xFF7C3AED),
                    title: 'Servicios',
                    child: _buildServicesSection(),
                  ),

                  const SizedBox(height: 16),

                  //  NOTAS (refactorizado)
                  CustomInfoCard.white(
                    icon: Icons.notes_rounded,
                    iconColor: const Color(0xFFF59E0B),
                    title: 'Notas',
                    child: AppointmentNotesSection(
                      isEditing: _isEditing,
                      notesController: _notesController,
                      currentNotes: widget.appointment.notes,
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ========================================
  // WIDGETS AUXILIARES
  // ========================================

  /// Widget para la sección de staff
  Widget _buildStaffSection() {
    if (_isEditing) {
      return StaffSelector(
        staffList: _staffList,
        selectedStaffId: _selectedStaffId,
        onChanged: (id) => setState(() => _selectedStaffId = id),
      );
    }

    // Modo visualización
    if (widget.appointment.staff != null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF3B82F6).withValues(alpha: 0.1),
              const Color(0xFF3B82F6).withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF3B82F6).withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.appointment.staff!.displayName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Sin empleado asignado
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.amber[200]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: Colors.amber[700],
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Sin empleado asignado',
              style: TextStyle(
                color: Colors.amber[900],
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Widget para la sección de servicios
  // Continuación de _buildServicesSection() - MODO VISUALIZACIÓN MEJORADO

  /// Widget para la sección de servicios
  Widget _buildServicesSection() {
    if (_isEditing) {
      if (_isLoadingServices) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: CircularProgressIndicator(),
          ),
        );
      }

      return ServiceSelector(
        services: _allServices,
        selectedIds: _selectedServiceIds,
        onToggle: (serviceId) {
          setState(() {
            if (_selectedServiceIds.contains(serviceId)) {
              _selectedServiceIds.remove(serviceId);
              _selectedServices.removeWhere((s) => s.id == serviceId);
            } else {
              _selectedServiceIds.add(serviceId);
              final service = _allServices.firstWhere((s) => s.id == serviceId);
              _selectedServices.add(service);
            }
            _recalculateEndTime();
          });
        },
        showPrices: true,
      );
    }

    // ✅ MODO VISUALIZACIÓN - Mejorado
    if (_selectedServices.isEmpty) {
      // Si no hay servicios asignados
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orange[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.orange[200]!,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.orange[700],
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Sin servicios asignados',
                    style: TextStyle(
                      color: Colors.orange[900],
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() => _isEditing = true);
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Asignar servicios'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Si hay servicios asignados
    return Column(
      children: _selectedServices.map((service) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          service.durationLabel,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                '\$${service.basePrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xFF7C3AED),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  /// Obtener color según el estado
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmada':
        return const Color(0xFF10B981);
      case 'pendiente':
        return const Color(0xFFF59E0B);
      case 'cancelada':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF6B7280);
    }
  }
}