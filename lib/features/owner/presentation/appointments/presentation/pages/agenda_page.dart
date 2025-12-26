import 'package:flutter/material.dart';
import '../../data/repositories/appointments_repository.dart';
import '../../data/sources/appointments_mock_api.dart';
import '../widgets/appointment_card.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({super.key});

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  late final AppointmentsRepository repo;
  late Future future;

  @override
  void initState() {
    super.initState();
    repo = AppointmentsRepository(mockApi: AppointmentsMockApi());
    future = repo.getToday();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda de hoy'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final list = (snapshot.data ?? []) as List;

          if (list.isEmpty) {
            return const Center(child: Text('No hay citas hoy.'));
          }

          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (_, i) => AppointmentCard(a: list[i]),
          );
        },
      ),
    );
  }
}
