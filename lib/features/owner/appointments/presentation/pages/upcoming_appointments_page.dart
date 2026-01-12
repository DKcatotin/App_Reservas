import 'package:agenda_app/features/owner/appointments/data/repositories/appointments_repository_impl.dart';
import 'package:agenda_app/features/owner/appointments/domain/entities/appointment_entity.dart';
import 'package:agenda_app/features/owner/appointments/domain/use_cases/get_upcoming_appointments.dart';
import 'package:agenda_app/features/owner/appointments/presentation/pages/appointment_detail_page.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class UpcomingAppointmentsPage extends StatefulWidget {
  final AppointmentsRepositoryImpl repo;

  const UpcomingAppointmentsPage({
    super.key,
    required this.repo,
  });

  @override
  State<UpcomingAppointmentsPage> createState() =>
      _UpcomingAppointmentsPageState();
}

class _UpcomingAppointmentsPageState extends State<UpcomingAppointmentsPage> {
  late final GetUpcomingAppointmentsUseCase _getUpcomingUseCase;

  List<AppointmentEntity> _upcomingAppointments = [];
  Map<String, List<AppointmentEntity>> _groupedByWeek = {};

  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _getUpcomingUseCase = GetUpcomingAppointmentsUseCase(widget.repo);
    _loadUpcomingAppointments();
  }

  Future<void> _loadUpcomingAppointments() async {
    try {
      setState(() {
        _loading = true;
        _error = null;
      });

      final data = await _getUpcomingUseCase.call();

      if (mounted) {
        setState(() {
          _upcomingAppointments = data;
          _groupedByWeek = _groupAppointmentsByWeek(data);
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Error al cargar las citas: $e';
          _loading = false;
        });
      }
    }
  }

  Map<String, List<AppointmentEntity>> _groupAppointmentsByWeek(
    List<AppointmentEntity> appointments,
  ) {
    final Map<String, List<AppointmentEntity>> grouped = {};

    for (final appointment in appointments) {
      final date = appointment.startAt;
      final weekStart = date.subtract(Duration(days: date.weekday - 1));
      final weekKey = DateFormat('yyyy-MM-dd').format(weekStart);

      if (!grouped.containsKey(weekKey)) {
        grouped[weekKey] = [];
      }
      grouped[weekKey]!.add(appointment);
    }

    final sortedKeys = grouped.keys.toList()..sort();
    final sortedMap = <String, List<AppointmentEntity>>{};
    for (final key in sortedKeys) {
      sortedMap[key] = grouped[key]!;
    }

    return sortedMap;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Citas Futuras'),
        backgroundColor: const Color(0xFF8B5CF6),
        foregroundColor: Colors.white,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return _buildErrorView();
    }

    if (_upcomingAppointments.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _loadUpcomingAppointments,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _groupedByWeek.length,
        itemBuilder: (context, index) {
          final weekKey = _groupedByWeek.keys.elementAt(index);
          final appointments = _groupedByWeek[weekKey]!;

          return _buildWeekSection(weekKey, appointments);
        },
      ),
    );
  }

  Widget _buildWeekSection(
      String weekKey, List<AppointmentEntity> appointments) {
    final weekStart = DateTime.parse(weekKey);
    final weekEnd = weekStart.add(const Duration(days: 6));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            '${DateFormat('d MMM', 'es').format(weekStart)} - ${DateFormat('d MMM yyyy', 'es').format(weekEnd)}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF8B5CF6),
            ),
          ),
        ),
        ...appointments
            .map((appointment) => _buildAppointmentCard(appointment)),
        const SizedBox(height: 16),
      ],
    );
  }

Widget _buildAppointmentCard(AppointmentEntity appointment) {
  final time = DateFormat('HH:mm').format(appointment.startAt);
  final serviceName = appointment.services.isNotEmpty
      ? appointment.services.first.name
      : 'Sin servicio';
  final statusColor = _getStatusColor(appointment.status.code);

  return Card(
    margin: const EdgeInsets.only(bottom: 12),
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () async {
        // ✅ PASAR EL REPOSITORIO Y RECARGAR AL VOLVER
        final result = await Navigator.push<AppointmentEntity>(
          context,
          MaterialPageRoute(
            builder: (_) => AppointmentDetailPage(
              appointment: appointment,
              repository: widget.repo,  // ← AGREGAR ESTO!
            ),
          ),
        );

        // Si se modificó o eliminó, recargar
        if (result != null && mounted) {
          await _loadUpcomingAppointments();
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
              // FECHA Y HORA
              Container(
                width: 70,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF7C3AED).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      DateFormat('dd').format(appointment.startAt),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7C3AED),
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('MMM', 'es')
                          .format(appointment.startAt)
                          .toUpperCase(),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                    const Divider(height: 12),
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7C3AED),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              // INFO
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.customer.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.spa,
                          size: 14,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            serviceName,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w400,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        // STATUS BADGE
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            appointment.status.label,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                        ),
                        const Spacer(),
                        // STAFF INFO SI EXISTE
                        if (appointment.staff != null)
                          Row(
                            children: [
                              Icon(
                                Icons.person_outline,
                                size: 14,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                appointment.staff!.name,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              // FLECHA
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF7C3AED).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Color(0xFF7C3AED),
                  size: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF7C3AED).withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.event_available,
                  size: 48,
                  color: Color(0xFF7C3AED),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'No hay citas futuras',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Todas las citas están al día.\nPuedes agendar nuevas citas cuando lo necesites.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                size: 64,
                color: Color(0xFFEF4444),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _error ?? 'Error desconocido',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadUpcomingAppointments,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C3AED),
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String statusCode) {
    switch (statusCode) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
