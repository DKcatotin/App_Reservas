import 'package:agenda_app/features/owner/appointments/data/repositories/appointments_repository_impl.dart';
import 'package:agenda_app/features/owner/appointments/domain/entities/appointment_entity.dart';
import 'package:agenda_app/features/owner/appointments/presentation/pages/appointments/appointment_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentCard extends StatelessWidget {
  final AppointmentEntity a;
  final AppointmentsRepositoryImpl repository;
  final Future<void> Function(AppointmentEntity)? onAppointmentUpdated;
  final Future<void> Function(String)? onAppointmentDeleted;

  const AppointmentCard({
    super.key,
    required this.a,
    required this.repository,
    this.onAppointmentUpdated,
    this.onAppointmentDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AppointmentDetailPage(
                appointment: a,
                repository: repository,
                onAppointmentUpdated: onAppointmentUpdated,
                onAppointmentDeleted: onAppointmentDeleted,
              ),
            ),
          );

          //  CORRECCIÓN: Manejar la cita actualizada
          if (result != null) {
            if (result is AppointmentEntity && onAppointmentUpdated != null) {
              // Si devolvió una cita actualizada, llamar al callback
              await onAppointmentUpdated!(result);
            } else if (result is bool && result == true && onAppointmentDeleted != null) {
              // Si devolvió true (eliminada), ya se manejó en el detail page
              // No necesitas hacer nada aquí porque el callback ya fue llamado
            }
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HORA
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 18,
                    color: _getStatusColor(a.status.code),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _formatTime(a.startAt),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  _buildStatusChip(),
                ],
              ),
              const SizedBox(height: 12),

              /// CLIENTE
              Row(
  children: [
    const CircleAvatar(
      radius: 20,
      child: Icon(Icons.person),
    ),
    const SizedBox(width: 12),
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            a.customer.fullName ?? 'Sin nombre',  
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            a.customer.phone ?? 'Sin teléfono',  
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    ),
  ],
),
              const SizedBox(height: 12),

              /// SERVICIOS
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: a.services.map((s) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '${s.name} (${s.durationMin}m)',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF8B5CF6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),

              /// STAFF (si existe)
              if (a.staff != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.face,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Atendido por: ${a.staff!.displayName}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],

              /// NOTAS (si existen)
              if (a.notes != null && a.notes!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.note,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          a.notes!,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: _getStatusColor(a.status.code).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getStatusColor(a.status.code),
          width: 1,
        ),
      ),
      child: Text(
        a.status.name,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: _getStatusColor(a.status.code),
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
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
