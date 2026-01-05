import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:agenda_app/features/owner/appointments/data/models/appointment.dart';
import '../../data/repositories/appointments_repository.dart';
import '../widgets/appointment_card.dart';
import 'appointment_form_page.dart';
import 'package:agenda_app/features/owner/appointments/domain/date_utils.dart';

class DiaryPage extends StatefulWidget {
  final AppointmentsRepository repo;

  const DiaryPage({
    super.key,
    required this.repo,
  });

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  late final AppointmentsRepository repo;

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List<Appointment> _allAppointments = [];
  List<Appointment> _filteredAppointments = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    repo = widget.repo;
    _selectedDay = _focusedDay;
    _loadAllAppointments();
  }

  Future<void> _loadAllAppointments() async {
    setState(() => _isLoading = true);

    try {
      final all = await repo.getAll();
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

  Future<void> _loadAppointmentsForSelectedDay() async {
    final day = _selectedDay ?? DateTime.now();
    final items = await repo.getByDay(day);

    setState(() {
      _filteredAppointments = items;
    });
  }

  List<Appointment> _getAppointmentsForDay(DateTime day) {
    final items =
        _allAppointments.where((a) => isSameDate(a.startAt, day)).toList();
    items.sort((a, b) => a.startAt.compareTo(b.startAt));
    return items;
  }

  void _handleAppointmentUpdated(Appointment updated) {
    setState(() {
      // Update en la lista global
      final allIndex =
          _allAppointments.indexWhere((a) => a.id == updated.id);
      if (allIndex != -1) {
        _allAppointments[allIndex] = updated;
      }

      // Update en la lista filtrada
      final filteredIndex =
          _filteredAppointments.indexWhere((a) => a.id == updated.id);
      if (filteredIndex != -1) {
        _filteredAppointments[filteredIndex] = updated;
      }
    });
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
                /// CALENDARIO
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
                  child: TableCalendar(
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

                /// LISTA
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
                                onAppointmentUpdated:
                                    _handleAppointmentUpdated,
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final created = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (_) => AppointmentFormPage(repo: repo),
            ),
          );

          if (created == true) {
            _loadAllAppointments();
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
