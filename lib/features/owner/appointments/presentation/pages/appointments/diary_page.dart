import 'package:agenda_app/features/owner/appointments/data/repositories/appointments_repository_impl.dart';
import 'package:agenda_app/features/owner/appointments/domain/entities/appointment_entity.dart';
import 'package:agenda_app/features/owner/appointments/domain/use_cases/get_appointments_by_day.dart';
import 'package:agenda_app/features/owner/appointments/domain/utils/date_utils.dart';
import 'package:agenda_app/core/routing/route_observer.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:go_router/go_router.dart'; 

import '../../widgets/appointments/appointment_card.dart';

class DiaryPage extends StatefulWidget {
  final AppointmentsRepositoryImpl repo;

  const DiaryPage({
    super.key,
    required this.repo,
  });

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> with RouteAware {
  late final GetAppointmentsByDayUseCase _getAppointmentsByDayUseCase;

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<AppointmentEntity> _allAppointments = [];
  List<AppointmentEntity> _filteredAppointments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    
    _getAppointmentsByDayUseCase = GetAppointmentsByDayUseCase(widget.repo);

    _selectedDay = _focusedDay;
    _loadAllAppointments();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void didPopNext() {
    _loadAllAppointments();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  /// Carga todas las citas
  Future<void> _loadAllAppointments() async {
    setState(() => _isLoading = true);
    
    try {
      // ✅ Invalidar caché del repositorio
      widget.repo.invalidateCache();
      
      final all = await widget.repo.getAll();
      
      setState(() {
        _allAppointments = all;
        _isLoading = false;
      });
      
      await _loadAppointmentsForSelectedDay();
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar citas: $e')),
        );
      }
    }
  }

  /// Carga citas del día seleccionado
  Future<void> _loadAppointmentsForSelectedDay() async {
    final day = _selectedDay ?? DateTime.now();
    
    final items = await _getAppointmentsByDayUseCase.call(day);
    
    setState(() {
      _filteredAppointments = items;
    });
  }

  /// Obtiene citas de un día específico (para el calendario)
  List<AppointmentEntity> _getAppointmentsForDay(DateTime day) {
    final items =
        _allAppointments.where((a) => isSameDate(a.startAt, day)).toList();
    items.sort((a, b) => a.startAt.compareTo(b.startAt));
    return items;
  }

  Future<void> _handleAppointmentUpdated(AppointmentEntity updated) async {
    try {
      final selectedDay = _selectedDay ?? DateTime.now();

      setState(() {
        final allIndex = _allAppointments.indexWhere((a) => a.id == updated.id);
        if (allIndex != -1) {
          _allAppointments[allIndex] = updated;
        } else {
          _allAppointments.add(updated);
        }

        final filteredIndex =
            _filteredAppointments.indexWhere((a) => a.id == updated.id);
        if (isSameDate(updated.startAt, selectedDay)) {
          if (filteredIndex != -1) {
            _filteredAppointments[filteredIndex] = updated;
          } else {
            _filteredAppointments.add(updated);
          }
        } else if (filteredIndex != -1) {
          _filteredAppointments.removeAt(filteredIndex);
        }

        _allAppointments.sort((a, b) => a.startAt.compareTo(b.startAt));
        _filteredAppointments.sort((a, b) => a.startAt.compareTo(b.startAt));
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cita actualizada exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al actualizar cita: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleAppointmentDeleted(String id) async {
    try {
      setState(() {
        _allAppointments.removeWhere((a) => a.id == id);
        _filteredAppointments.removeWhere((a) => a.id == id);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cita eliminada exitosamente'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al eliminar cita: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5FF),
      appBar: AppBar(
        title: const Text('Agenda'),
        backgroundColor: const Color(0xFF8B5CF6),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TableCalendar<AppointmentEntity>(
                    firstDay: DateTime.utc(2024, 1, 1),
                    lastDay: DateTime.utc(2026, 12, 31),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) =>
                        isSameDay(_selectedDay, day),
                    locale: 'es',
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8B5CF6),
                      ),
                    ),
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: const Color(0xFFA78BFA)
                            .withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: const BoxDecoration(
                        color: Color(0xFF8B5CF6),
                        shape: BoxShape.circle,
                      ),
                      markerDecoration: const BoxDecoration(
                        color: Color(0xFFEC4899),
                        shape: BoxShape.circle,
                      ),
                    ),
                    eventLoader: _getAppointmentsForDay,
                    onDaySelected: (selectedDay, focusedDay) async {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                      await _loadAppointmentsForSelectedDay();
                    },
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                    },
                  ),
                ),

                Expanded(
                  child: _filteredAppointments.isEmpty
                      ? _buildEmptyState()
                      : RefreshIndicator(
                          onRefresh: _loadAllAppointments,
                          child: ListView.separated(
                            padding: const EdgeInsets.all(16),
                            itemCount: _filteredAppointments.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (_, i) {
                              final appointment =
                                  _filteredAppointments[i];
                              return AppointmentCard(
                                a: appointment,
                                repository: widget.repo,
                                onAppointmentUpdated: _handleAppointmentUpdated,
                                onAppointmentDeleted: _handleAppointmentDeleted,
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // ✅ Navegar y esperar resultado
          final result = await context.push('/owner/appointments/cliente/buscar');
          
          // ✅ Si result es true, recargar citas
          if (result == true && mounted) {
            await _loadAllAppointments();
            
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('✅ Cita creada exitosamente'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );
            }
          }
        },
        backgroundColor: const Color(0xFF8B5CF6),
        icon: const Icon(Icons.add),
        label: const Text('Nueva Cita'),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6)
                  .withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.event_busy,
              size: 64,
              color: Color(0xFF8B5CF6),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No hay citas para este día',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
        ],
      ),
    );
  }
}
