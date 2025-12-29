import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:agenda_app/features/owner/appointments/data/models/appointment.dart';
import '../../data/repositories/appointments_repository.dart';
import '../widgets/appointment_card.dart';

class DiaryPage extends StatefulWidget {
  final AppointmentsRepository repo;

  const DiaryPage({super.key, required this.repo});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  int selectedDayIndex = 0;

  /// Selector horizontal de días (hoy + 6)
  Widget _daySelector() {
    final today = DateTime.now();

    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (_, i) {
          final date = today.add(Duration(days: i));
          final isSelected = selectedDayIndex == i;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedDayIndex = i;
              });
            },
            child: Container(
              width: 65,
              margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('EEE').format(date),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date.day.toString(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate =
        DateTime.now().add(Duration(days: selectedDayIndex));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Selector de días
          _daySelector(),

          /// Título dinámico
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Citas del ${DateFormat('dd MMM').format(selectedDate)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),

          /// Lista de citas
          Expanded(
            child: FutureBuilder<List<Appointment>>(
              future: widget.repo.getToday(), // luego filtraremos por fecha
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Error al cargar las citas'),
                  );
                }

                final items = snapshot.data ?? [];

                if (items.isEmpty) {
                  return const Center(
                    child: Text('No hay citas para este día'),
                  );
                }

                return ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1),
                  itemBuilder: (_, i) {
                    return AppointmentCard(a: items[i]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
