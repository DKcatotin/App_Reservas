import 'dart:convert';
import 'package:agenda_app/features/owner/appointments/data/models/appointment_service.dart';
import 'package:agenda_app/features/owner/appointments/data/repositories/appointments_repository_impl.dart';
import 'package:agenda_app/features/owner/appointments/domain/use_cases/update_appointment.dart';
import 'package:agenda_app/features/owner/catalogues/data/models/staff.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:agenda_app/features/owner/catalogues/data/models/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/appointment_entity.dart';

import '../../domain/use_cases/delete_appointment.dart';

import '../../domain/entities/service_entity.dart';
import '../../domain/entities/staff_entity.dart';
import '../../domain/entities/status_entity.dart';

//tres imports para staff
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/staff_provider.dart';

class AppointmentDetailPage extends ConsumerStatefulWidget {
  final AppointmentEntity appointment;
  final AppointmentsRepositoryImpl repository; // ← AGREGAR
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
  bool _isEditing = false;
  late DateTime _selectedDate;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  late String _selectedStatus;
  late List<dynamic> _selectedServices;
  late TextEditingController _notesController;
  late List<TextEditingController> _serviceControllers;
  // Controladores para nombre y teléfono
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  //variables de estado
  String? _selectedStaffId;
  List<Staff> _staffList = [];
  // En tu clase _AppointmentDetailPageState
  Set<String> _selectedServiceIds = {};
  List<Service> _allServices = []; // Todos los servicios disponibles
  bool _isLoadingServices = true;
  late UpdateAppointmentUseCase _updateAppointmentUseCase;
  late DeleteAppointmentUseCase _deleteAppointmentUseCase;
 

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.appointment.startAt;
    _updateAppointmentUseCase = UpdateAppointmentUseCase(widget.repository);
    _deleteAppointmentUseCase = DeleteAppointmentUseCase(widget.repository);
    _startTime = TimeOfDay.fromDateTime(widget.appointment.startAt);
    _endTime = TimeOfDay.fromDateTime(widget.appointment.endAt);
    _selectedStatus = widget.appointment.status.label;
    _selectedServices = List.from(widget.appointment.services);
    _notesController =
        TextEditingController(text: widget.appointment.notes ?? '');
    _nameController = TextEditingController(text: widget.appointment.customer.fullName);
    _phoneController = TextEditingController(text: widget.appointment.customer.phone);

    _serviceControllers = _selectedServices.map((s) {
      return TextEditingController(text: (s as dynamic).name);
    }).toList();

    // para staff
    _selectedStaffId = widget.appointment.staff?.id;

    //  Inicializar el Set de IDs seleccionados
    _selectedServiceIds =
        _selectedServices.map((s) => (s as dynamic).id as String).toSet();

    loadAllServices();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Cargar staff desde el provider
    final staffAsync = ref.watch(staffListProvider);
    staffAsync.whenData((list) {
      if (mounted && _staffList.isEmpty) {
        setState(() {
          _staffList = list;
        });
      }
    });
  }

void _recalculateEndTimeFromStart() {
  if (_selectedServices.isEmpty) {
    _endTime = _startTime;
    return;
  }

 int totalMinutes = 0;
for (var service in _selectedServices) {
  if (service is AppointmentService) {
    totalMinutes += service.durationMin;  // ✅ Ya es int
  } else if (service is Service) {
    totalMinutes += service.durationMin;  // ✅ Ya es int
  } else {
    // Para tipos dynamic
    final dynamic s = service;
    try {
      if (s.durationMin != null) {
        totalMinutes += (s.durationMin as num).toInt();
      } else if (s.durationMin != null) {
        totalMinutes += (s.durationMin as num).toInt();
      } else if (s.duration != null) {
        totalMinutes += (s.duration as Duration).inMinutes;
      }
    } catch (e) {
      print('Error al obtener duración del servicio: $e');
    }
  }
}


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

 void _recalculateEndTime() {
  if (_selectedServices.isEmpty) {
    return;
  }

  // Sumar todas las duraciones
  int totalMinutes = 0;
  for (var service in _selectedServices) {
    //  CORRECCIÓN: Manejar ambos tipos de servicios
    if (service is AppointmentService) {
      totalMinutes += service.durationMin;
    } else if (service is Service) {
      totalMinutes += service.durationMin;
    } else {
      // Si es dynamic, intentar obtener durationMin o duration
      final dynamic s = service;
      if (s.durationMin != null) {
        totalMinutes += s.durationMin as int;
      } else if (s.duration != null) {
        totalMinutes += (s.duration as Duration).inMinutes;
      }
    }
  }

  // Calcular nuevo end time
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


  @override
  void dispose() {
    _notesController.dispose();
    _nameController.dispose();
    _phoneController.dispose();

    for (var controller in _serviceControllers) {
      controller.dispose();
    }
    super.dispose();
  }
Future<void> _sendWhatsAppReminder() async {
  final dateFormatter = DateFormat('EEEE dd MMM yyyy', 'es');
  final formattedDate = dateFormatter.format(widget.appointment.startAt);
  
  final timeFormatter = DateFormat('HH:mm');
  final formattedTime = timeFormatter.format(widget.appointment.startAt);
  
  final services = widget.appointment.services.map((s) => s.name).join(', ');
  
  String phone = _phoneController.text.replaceAll(RegExp(r'[^\d+]'), '');
  
  if (!phone.startsWith('+')) {
    if (phone.startsWith('0')) {
      phone = '+593${phone.substring(1)}';
    } else {
      phone = '+593$phone';
    }
  }
  
  final message = '''Francis Nails & Beauty Spa 📢 Recordatorio de cita:
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 12),
                Text('No se pudo abrir WhatsApp'),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text('Error al abrir WhatsApp: $e')),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }
}

  Future<void> loadAllServices() async {
    try {
      final jsonString = await rootBundle
          .loadString('assets/data/owner/catalogues/services_mock.json');

      // ✅ Primero decodifica como Map
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      // ✅ Luego extrae el array "data"
      final List<dynamic> jsonList = jsonData['data'];

      setState(() {
        _allServices = jsonList.map((json) => Service.fromJson(json)).toList();
        _isLoadingServices = false;
      });
    } catch (e) {
      print('Error cargando servicios: $e');
      setState(() {
        _isLoadingServices = false;
      });
    }
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
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> confirmDelete() async {
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
        // ✅ ELIMINAR usando el use case
        await _deleteAppointmentUseCase.call(widget.appointment.id);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Cita eliminada exitosamente'),
              backgroundColor: Colors.orange,
            ),
          );

          // Llamar al callback si existe
          if (widget.onAppointmentDeleted != null) {
            await widget.onAppointmentDeleted!(widget.appointment.id);
          }

          // Volver a la pantalla anterior
          Navigator.pop(
              context, true); // Devuelve true para indicar que se eliminó
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ Error al eliminar: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
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

    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
          // ✅ RECALCULAR automáticamente la hora de fin
          _recalculateEndTimeFromStart();
        } else {
          // Ya no debería llegar aquí, pero por si acaso
          _endTime = picked;
        }
      });
    }
  }

  Future<void> saveChanges() async {
    // ✅ CREAR newStartAt
    final newStartAt = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _startTime.hour,
      _startTime.minute,
    );

    // ✅ CREAR newEndAt (¡ESTO FALTABA!)
    final newEndAt = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _endTime.hour,
      _endTime.minute,
    );

    // Staff seleccionado
    Staff? selectedStaff;
    if (_selectedStaffId != null) {
      try {
        selectedStaff = _staffList.firstWhere((s) => s.id == _selectedStaffId);
      } catch (e) {
        selectedStaff = null;
      }
    }

    // Convertir servicios a ServiceEntity
    List<ServiceEntity> serviceEntities = _selectedServices.map((service) {
      if (service is AppointmentService) {
        return ServiceEntity(
          id: service.id,
          name: service.name,
          durationMin: service.durationMin,
        );
      } else if (service is Service) {
        return ServiceEntity(
          id: service.id,
          name: service.name,
          durationMin: service.durationMin,
        );
      } else {
        final s = service as dynamic;
        return ServiceEntity(
          id: s.id,
          name: s.name,
          durationMin: s.duration.inMinutes as int,
        );
      }
    }).toList();

    final updatedAppointment = widget.appointment.copyWith(
      startAt: newStartAt,
      endAt: newEndAt, // ✅ Ahora está definido
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      status: StatusEntity(
        code: _selectedStatus.toLowerCase(),
        label: _selectedStatus,
      ),
      services: serviceEntities,
      staff: selectedStaff != null
          ? StaffEntity(
              id: selectedStaff.id,
              name: selectedStaff.displayName,
              specialty: selectedStaff.specialty,
              colorTag: selectedStaff.colorTag,
            )
          : null,
    );

    // ✅ GUARDAR EN EL REPOSITORIO usando call() NO execute()
    try {
      await _updateAppointmentUseCase
          .call(updatedAppointment); // ← call() no execute()

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Cita actualizada exitosamente'),
            backgroundColor: Colors.green,
          ),
        );

        // Devolver la cita actualizada
        Navigator.pop(context, updatedAppointment);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error al guardar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _cancelEdit() {
  setState(() {
    _isEditing = false;
    _selectedDate = widget.appointment.startAt;
    _startTime = TimeOfDay.fromDateTime(widget.appointment.startAt);
    _endTime = TimeOfDay.fromDateTime(widget.appointment.endAt);
    _selectedStatus = widget.appointment.status.label;
    _selectedServices = List.from(widget.appointment.services);
    _notesController.text = widget.appointment.notes ?? '';
    
    // ✅ CORRECCIÓN: Manejar valores nullable
    _nameController.text = widget.appointment.customer.fullName ?? '';
    _phoneController.text = widget.appointment.customer.phone ?? '';
    
    // Resetear el Set de IDs
    _selectedServiceIds = _selectedServices.map((s) => (s as dynamic).id as String).toSet();
    
    for (int i = 0; i < _serviceControllers.length; i++) {
      _serviceControllers[i].text = (_selectedServices[i] as dynamic).name;
    }
  });
}

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('EEEE dd MMM yyyy', 'es');

    //  Observa el provider aquí
    final staffAsync = ref.watch(staffListProvider);

    //  Actualiza la lista cuando los datos estén disponibles
    staffAsync.whenData((list) {
      if (mounted && _staffList.isEmpty) {
        // Usa addPostFrameCallback para evitar setState durante build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _staffList = list;
            });
          }
        });
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF7C3AED),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              if (_isEditing) ...[
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: _cancelEdit,
                    tooltip: 'Cancelar',
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.check, color: Colors.white),
                    onPressed: saveChanges,
                    tooltip: 'Guardar',
                  ),
                ),
              ] else
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.edit_outlined, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        _isEditing = true;
                      });
                    },
                    tooltip: 'Editar',
                  ),
                ),
              if (!_isEditing)
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.white),
                    onPressed: confirmDelete,
                    tooltip: 'Eliminar',
                  ),
                ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                _isEditing ? 'Editar Cita' : 'Detalle de la Cita',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              centerTitle: true,
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF7C3AED),
                      Color(0xFF9333EA),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  /// CLIENTE
                  /// CLIENTE - EDITABLE (NOMBRE Y TELÉFONO)
_ModernInfoCard(
  gradient: const LinearGradient(
    colors: [Color(0xFF7C3AED), Color(0xFF9333EA)],
  ),
  icon: Icons.person_rounded,
  title: 'Cliente',
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // NOMBRE EDITABLE
      _isEditing
          ? TextField(
              controller: _nameController,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: 'Nombre del cliente',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            )
          : Text(
              _nameController.text,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
      
      const SizedBox(height: 12),
      
      // TELÉFONO EDITABLE con WhatsApp
      _isEditing
          ? TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintText: 'Número de teléfono',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                prefixIcon: const Icon(Icons.phone_rounded, color: Colors.white, size: 18),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.white, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                filled: true,
                fillColor: Colors.white.withOpacity(0.2),
              ),
            )
          : GestureDetector(
              onTap: _sendWhatsAppReminder,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.phone_rounded, size: 18, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      _phoneController.text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.white),
                  ],
                ),
              ),
            ),
    ],
  ),
),

                  /// FECHA Y HORA
                  _WhiteInfoCard(
  icon: Icons.calendar_today_rounded,
  iconColor: const Color(0xFF7C3AED),
  title: 'Fecha y Hora',
  child: Column(
    children: [
      InkWell(
        onTap: _isEditing ? () => _selectDate(context) : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _isEditing
                ? const Color(0xFF7C3AED).withValues(alpha: 0.05)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: _isEditing
                ? Border.all(
                    color: const Color(0xFF7C3AED).withValues(alpha: 0.3),
                    width: 1,
                  )
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 📅 FECHA (ARRIBA)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Fecha',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          dateFormatter.format(_selectedDate),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_isEditing)
                    const Icon(
                      Icons.chevron_right,
                      color: Color(0xFF7C3AED),
                    ),
                ],
              ),

              const SizedBox(height: 12),

              /// ⏰ HORAS (ABAJO)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF7C3AED).withValues(alpha: 0.1),
                      const Color(0xFF9333EA).withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    /// INICIO - EDITABLE
                    InkWell(
                      onTap: _isEditing
                          ? () => _selectTime(context, true)
                          : null,
                      borderRadius: BorderRadius.circular(8),
                      child: _TimeBlock(
                        label: 'Inicio',
                        time: _startTime.format(context),
                        isEditable: _isEditing,
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 2,
                      color: const Color(0xFF7C3AED)
                          .withValues(alpha: 0.3),
                    ),
                    /// FIN - CALCULADO
                    _TimeBlock(
                      label: 'Fin',
                      time: _endTime.format(context),
                      isEditable: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 12),
    ],
  ),
),

const SizedBox(height: 16),

                  /// EMPLEADO/STAFF ASIGNADO
                  _WhiteInfoCard(
                    icon: Icons.person_outline_rounded,
                    iconColor: const Color(0xFF3B82F6),
                    title: 'Empleado Asignado',
                    child: widget.appointment.staff != null
                        ? (_isEditing
                            ? _buildStaffSelector()
                            : Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color(0xFF3B82F6)
                                          .withValues(alpha: 0.1),
                                      const Color(0xFF3B82F6)
                                          .withValues(alpha: 0.05),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFF3B82F6)
                                        .withValues(alpha: 0.2),
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
                                        widget.appointment.staff!.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF1F2937),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ))
                        : (_isEditing
                            ? _buildStaffSelector()
                            : Container(
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
                              )),
                  ),

                  /// ESTADO
                  _WhiteInfoCard(
                    icon: Icons.info_rounded,
                    iconColor: _statusColor(_selectedStatus),
                    title: 'Estado',
                    child: _isEditing
                        ? DropdownButtonFormField<String>(
                            initialValue: _selectedStatus,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Color(0xFF7C3AED),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: const Color(0xFF7C3AED)
                                      .withValues(alpha: 0.3),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Color(0xFF7C3AED),
                                  width: 2,
                                ),
                              ),
                            ),
                            items: ['Confirmada', 'Pendiente', 'Cancelada']
                                .map((status) => DropdownMenuItem(
                                      value: status,
                                      child: Row(
                                        children: [
                                          Icon(
                                            _statusIcon(status),
                                            color: _statusColor(status),
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(status),
                                        ],
                                      ),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _selectedStatus = value;
                                });
                              }
                            },
                          )
                        : Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  _statusColor(_selectedStatus),
                                  _statusColor(_selectedStatus)
                                      .withValues(alpha: 0.7),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: _statusColor(_selectedStatus)
                                      .withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _statusIcon(_selectedStatus),
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _selectedStatus,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),

                  const SizedBox(height: 16),

                  /// SERVICIOS
                  _WhiteInfoCard(
                    icon: Icons.spa_rounded,
                    iconColor: const Color(0xFF7C3AED),
                    title: 'Servicios',
                    child: _isEditing
                        ? _buildServicesEditor() //  Nuevo widget para editar
                        : _buildServicesDisplay(), //  Widget actual para visualizar
                  ),

                  const SizedBox(height: 16),

                  /// NOTAS
                  _WhiteInfoCard(
                    icon: Icons.notes_rounded,
                    iconColor: const Color(0xFFF59E0B),
                    title: 'Notas',
                    child: _isEditing
                        ? TextField(
                            controller: _notesController,
                            maxLines: 4,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFF1F2937),
                            ),
                            decoration: InputDecoration(
                              hintText:
                                  'Escribe notas adicionales sobre la cita...',
                              hintStyle: TextStyle(
                                color: Colors.grey[400],
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: const Color(0xFF7C3AED)
                                      .withValues(alpha: 0.3),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: const Color(0xFF7C3AED)
                                      .withValues(alpha: 0.3),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Color(0xFF7C3AED),
                                  width: 2,
                                ),
                              ),
                              filled: true,
                              fillColor: const Color(0xFF7C3AED)
                                  .withValues(alpha: 0.05),
                              contentPadding: const EdgeInsets.all(16),
                            ),
                          )
                        : (widget.appointment.notes == null ||
                                widget.appointment.notes!.isEmpty)
                            ? Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey[300]!,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      color: Colors.grey[600],
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'No hay notas para esta cita',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 15,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color(0xFFF59E0B)
                                          .withValues(alpha: 0.1),
                                      const Color(0xFFF59E0B)
                                          .withValues(alpha: 0.05),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFFF59E0B)
                                        .withValues(alpha: 0.2),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  widget.appointment.notes!,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFF1F2937),
                                    height: 1.5,
                                  ),
                                ),
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

  Widget _buildServicesDisplay() {
    return Column(
      children: _selectedServices.map((s) {
        final d = (s as dynamic).duration;
        final hours = d.inHours;
        final minutes = d.inMinutes.remainder(60);
        final label = hours > 0 ? '${hours}h ${minutes}m' : '${minutes}m';

        //  Buscar el precio desde allServices
        final serviceId = (s as dynamic).id;

final serviceWithPrice = _allServices.firstWhere(
  (service) => service.id == serviceId,
  orElse: () => Service(
    id: serviceId,
    name: (s as dynamic).name,
    durationMin: d.inMinutes,
    basePrice: 0.0,  // ✅ Cambiar price a basePrice
  ),
);
final price = serviceWithPrice.basePrice ?? 0.0;  // ✅ Cambiar y manejar null

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF7C3AED).withValues(alpha: 0.1),
                const Color(0xFF9333EA).withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF7C3AED).withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF7C3AED),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (s as dynamic).name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${price.toStringAsFixed(2)}', // Muestra el precio formateado
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF7C3AED),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildServicesEditor() {
    if (_isLoadingServices) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_allServices.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text('No hay servicios disponibles'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _allServices.map((service) {
        //  Verificar selección usando el Set de IDs
        final isSelected = _selectedServiceIds.contains(service.id);
        final hours = service.duration.inHours;
        final minutes = service.duration.inMinutes.remainder(60);
        final durationLabel =
            hours > 0 ? '${hours}h ${minutes}m' : '${minutes}m';

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF7C3AED).withValues(alpha: 0.1)
                : Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? const Color(0xFF7C3AED) : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: CheckboxListTile(
            value: isSelected,
            onChanged: (checked) {
              setState(() {
                if (checked == true) {
                  //  Agregar al Set de IDs
                  _selectedServiceIds.add(service.id);
                  //  Agregar AppointmentService a la lista
                  _selectedServices.add(
                    AppointmentService(
                      id: service.id,
                      name: service.name,
                      durationMin: service.durationMin,
                    ),
                  );
                } else {
                  //  Remover del Set de IDs
                  _selectedServiceIds.remove(service.id);
                  //  Remover de la lista
                  _selectedServices
                      .removeWhere((s) => (s as dynamic).id == service.id);
                }
                // Recalcular duración de la cita
                _recalculateEndTime();
              });
            },
            title: Text(
              service.name,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? const Color(0xFF7C3AED)
                    : const Color(0xFF1F2937),
              ),
            ),
            subtitle: Row(
              children: [
  const Icon(Icons.access_time, size: 14, color: Colors.grey),
  const SizedBox(width: 4),
  Text(durationLabel),
  const SizedBox(width: 12),
  const Icon(Icons.attach_money, size: 14, color: Colors.grey),
  Text('\$${(service.basePrice ?? 0.0).toStringAsFixed(2)}'),  // Manejar null
],
            ),
            activeColor: const Color(0xFF7C3AED),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStaffSelector() {
    if (_staffList.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!, width: 1),
        ),
        child: const Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 12),
            Text(
              'Cargando empleados...',
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
          ],
        ),
      );
    }

    //  CORRECCIÓN CRÍTICA: Eliminar duplicados y validar valor
    final uniqueStaffList = <String, Staff>{};
    for (var staff in _staffList) {
      uniqueStaffList[staff.id] = staff;
    }
    final cleanStaffList = uniqueStaffList.values.toList();

    // Validar que el valor seleccionado exista
    final validValue = (cleanStaffList.any((s) => s.id == _selectedStaffId))
        ? _selectedStaffId
        : null;

    return DropdownButtonFormField<String>(
      value: validValue, // ✅ Usar valor validado
      decoration: InputDecoration(
        hintText: 'Seleccionar empleado',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3B82F6)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
        ),
        filled: true,
        fillColor: const Color(0xFF3B82F6).withValues(alpha: 0.05),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        prefixIcon:
            const Icon(Icons.person_outline_rounded, color: Color(0xFF3B82F6)),
      ),
      items: [
        const DropdownMenuItem<String>(
          value: null,
          child: Text(
            'Sin asignar',
            style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
          ),
        ),
        ...cleanStaffList.map((staff) => DropdownMenuItem<String>(
              value: staff.id,
              child: Text(staff.displayName),
            )),
      ],
      onChanged: (value) {
        setState(() {
          _selectedStaffId = value;
        });
      },
    );
  }

  Color _statusColor(String status) {
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

  IconData _statusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'confirmada':
        return Icons.check_circle;
      case 'pendiente':
        return Icons.access_time;
      case 'cancelada':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }
}

class _ModernInfoCard extends StatelessWidget {
  final Gradient gradient;
  final IconData icon;
  final String title;
  final Widget child;

  const _ModernInfoCard({
    required this.gradient,
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C3AED).withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _WhiteInfoCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final Widget child;

  const _WhiteInfoCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _TimeBlock extends StatelessWidget {
  final String label;
  final String time;
  final bool isEditable;

  const _TimeBlock({
    required this.label,
    required this.time,
    this.isEditable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                time,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF7C3AED),
                ),
              ),
              if (isEditable) ...[
                const SizedBox(width: 4),
                const Icon(
                  Icons.edit,
                  size: 16,
                  color: Color(0xFF7C3AED),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
