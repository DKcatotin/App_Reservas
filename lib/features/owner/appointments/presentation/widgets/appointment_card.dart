import 'package:agenda_app/features/owner/appointments/presentation/pages/appointment_detail_page.dart';
import 'package:flutter/material.dart';
import '../../data/models/appointment.dart';

class AppointmentCard extends StatelessWidget {
  final Appointment a;
  final Future<void> Function(Appointment)? onAppointmentUpdated;
  final Future<void> Function(String id)? onAppointmentDeleted;

  const AppointmentCard({
    super.key,
    required this.a,
    this.onAppointmentUpdated,
    this.onAppointmentDeleted,
  });

  // Usa el label del status para mapear colores
  Color _statusColor(String statusLabel) {
    switch (statusLabel) {
      case 'Pendiente':
        return const Color(0xFFF59E0B);
      case 'Confirmada':
      case 'Terminada':
        return const Color(0xFF10B981);
      case 'Cancelada':
        return const Color(0xFFEF4444);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final time = TimeOfDay.fromDateTime(a.startAt).format(context);
    final serviceName =
        a.services.isNotEmpty ? a.services.first.name : 'Sin servicio';
    final statusColor = _statusColor(a.status.label);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AppointmentDetailPage(appointment: a),
              ),
            );

            if (result is Appointment && onAppointmentUpdated != null) {
              await onAppointmentUpdated!(result);
            }

            if (result is Map &&
                result['deleteId'] != null &&
                onAppointmentDeleted != null) {
              await onAppointmentDeleted!(result['deleteId'] as String);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                /// HORA
                Container(
                  width: 60,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF8B5CF6), Color(0xFFA78BFA)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.access_time,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        time,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 16),

                /// INFO
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        a.customer.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              serviceName,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          a.status.label,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                /// FLECHA
                Icon(Icons.chevron_right, color: Colors.grey[400]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
