import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:agenda_app/features/owner/appointments/data/models/appointment.dart';
import '../../data/repositories/appointments_repository.dart';
import '../widgets/appointment_card.dart';

class DiaryPage extends StatefulWidget {
  final AppointmentsRepository repo;

  const DiaryPage({super.key, required this.repo});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  
  List<Appointment> _allAppointments = [];
  List<Appointment> _filteredAppointments = [];
  String? _selectedStaffId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _selectedDay = _focusedDay;
    _loadAllAppointments();
    
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _filterAppointments();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAllAppointments() async {
    setState(() => _isLoading = true);
    
    try {
      final today = await widget.repo.getToday();
      final past = await widget.repo.getPast();
      final upcoming = await widget.repo.getUpcoming();
      
      setState(() {
        _allAppointments = [...past, ...today, ...upcoming];
        _filterAppointments();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar citas: $e')),
        );
      }
    }
  }

  void _filterAppointments() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    List<Appointment> filtered = _allAppointments;
    
    // Filtrar por tab (Hoy/Próximas/Pasadas)
    switch (_tabController.index) {
      case 0: // Hoy
        filtered = filtered.where((a) {
          final aDate = DateTime(a.startAt.year, a.startAt.month, a.startAt.day);
          return aDate.isAtSameMomentAs(today);
        }).toList();
        break;
      case 1: // Próximas
        filtered = filtered.where((a) {
          final aDate = DateTime(a.startAt.year, a.startAt.month, a.startAt.day);
          return aDate.isAfter(today);
        }).toList();
        break;
      case 2: // Pasadas
        filtered = filtered.where((a) {
          final aDate = DateTime(a.startAt.year, a.startAt.month, a.startAt.day);
          return aDate.isBefore(today);
        }).toList();
        break;
    }
    
    // Filtrar por staff si hay uno seleccionado
    if (_selectedStaffId != null) {
      filtered = filtered.where((a) => a.staffId == _selectedStaffId).toList();
    }
    
    // Ordenar por fecha
    filtered.sort((a, b) => a.startAt.compareTo(b.startAt));
    
    setState(() {
      _filteredAppointments = filtered;
    });
  }

  List<Appointment> _getAppointmentsForDay(DateTime day) {
    return _allAppointments.where((a) {
      final aDate = DateTime(a.startAt.year, a.startAt.month, a.startAt.day);
      final targetDate = DateTime(day.year, day.month, day.day);
      return aDate.isAtSameMomentAs(targetDate);
    }).toList();
  }

  List<String> _getUniqueStaff() {
    final staffIds = _allAppointments.map((a) => a.staffId).toSet().toList();
    return staffIds;
  }

  @override
  Widget build(BuildContext context) {
    final uniqueStaff = _getUniqueStaff();
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5FF),
      appBar: AppBar(
        title: const Text('Agenda'),
        backgroundColor: const Color(0xFF8B5CF6),
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.today), text: 'Hoy'),
            Tab(icon: Icon(Icons.event_available), text: 'Próximas'),
            Tab(icon: Icon(Icons.history), text: 'Pasadas'),
          ],
        ),
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
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TableCalendar(
                    firstDay: DateTime.utc(2024, 1, 1),
                    lastDay: DateTime.utc(2026, 12, 31),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    calendarFormat: _calendarFormat,
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
                        color: const Color(0xFFA78BFA).withOpacity(0.5),
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
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                    onFormatChanged: (format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    },
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                    },
                  ),
                ),

                /// FILTRO POR STAFF
                if (uniqueStaff.length > 1) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildStaffChip(null, 'Todos'),
                          const SizedBox(width: 8),
                          ..._allAppointments
                              .map((a) => a.staff)
                              .toSet()
                              .map((staff) => Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: _buildStaffChip(staff.id, staff.name),
                                  )),
                        ],
                      ),
                    ),
                  ),
                ],

                /// LISTA DE CITAS
                Expanded(
                  child: _filteredAppointments.isEmpty
                      ? _buildEmptyState()
                      : RefreshIndicator(
                          onRefresh: _loadAllAppointments,
                          child: ListView.separated(
                            padding: const EdgeInsets.all(16),
                            itemCount: _filteredAppointments.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 12),
                            itemBuilder: (_, i) {
                              return AppointmentCard(a: _filteredAppointments[i]);
                            },
                          ),
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navegar a crear nueva cita
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Crear nueva cita (próximamente)')),
          );
        },
        backgroundColor: const Color(0xFF8B5CF6),
        icon: const Icon(Icons.add),
        label: const Text('Nueva Cita'),
      ),
    );
  }

  Widget _buildStaffChip(String? staffId, String name) {
    final isSelected = _selectedStaffId == staffId;
    
    return FilterChip(
      label: Text(name),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedStaffId = selected ? staffId : null;
          _filterAppointments();
        });
      },
      selectedColor: const Color(0xFF8B5CF6),
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildEmptyState() {
    String message;
    IconData icon;
    
    switch (_tabController.index) {
      case 0:
        message = 'No hay citas para hoy';
        icon = Icons.event_busy;
        break;
      case 1:
        message = 'No hay citas próximas';
        icon = Icons.event_available;
        break;
      case 2:
        message = 'No hay citas pasadas';
        icon = Icons.history;
        break;
      default:
        message = 'No hay citas';
        icon = Icons.event_note;
    }
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 64,
              color: const Color(0xFF8B5CF6),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
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