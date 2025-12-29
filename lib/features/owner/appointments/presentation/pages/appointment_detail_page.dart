import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/appointment.dart';

class AppointmentDetailPage extends StatelessWidget {
  final Appointment appointment;

  const AppointmentDetailPage({
    super.key,
    required this.appointment,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('EEEE dd MMM yyyy', 'es');
    final timeFormatter = DateFormat('HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de la cita'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // luego → editar
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// CLIENTE
            _InfoCard(
              icon: Icons.person,
              title: 'Cliente',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appointment.customer.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.phone, size: 18),
                      const SizedBox(width: 6),
                      Text(appointment.customer.phone),
                    ],
                  ),
                ],
              ),
            ),

            /// FECHA Y HORA
            _InfoCard(
              icon: Icons.schedule,
              title: 'Fecha y hora',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dateFormatter.format(appointment.startAt),
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${timeFormatter.format(appointment.startAt)} - '
                    '${timeFormatter.format(appointment.endAt)}',
                  ),
                ],
              ),
            ),

            /// ESTADO
            _InfoCard(
              icon: Icons.info_outline,
              title: 'Estado',
              child: Align(
                alignment: Alignment.centerLeft,
                child: Chip(
                  label: Text(
                    appointment.status.label,
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: _statusColor(appointment.status.label),
                ),
              ),
            ),

            /// SERVICIOS
            _InfoCard(
              icon: Icons.list_alt,
              title: 'Servicios',
              child: Column(
                children: appointment.services.map((s) {
                  final d = s.duration;
                  final hours = d.inHours;
                  final minutes = d.inMinutes.remainder(60);
                  final label =
                      hours > 0 ? '${hours}h ${minutes}m' : '${minutes}m';

                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.check_circle_outline),
                    title: Text(s.name),
                    trailing: Text(label),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmada':
        return Colors.green;
      case 'pendiente':
        return Colors.orange;
      case 'cancelada':
        return Colors.red;
      default:
        return Colors.blueGrey;
    }
  }
}

/// CARD REUTILIZABLE
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}
