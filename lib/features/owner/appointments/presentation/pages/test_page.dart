import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/test_item.dart';
import '../../data/repositories/appointments_repository.dart';

class TestPage extends StatefulWidget {
  final AppointmentsRepository repo;
  const TestPage({super.key, required this.repo});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  late Future<List<TestItem>> future;

  @override
  void initState() {
    super.initState();
    future = widget.repo.getTest1();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test privado /test1'),
        leading: IconButton(
  icon: const Icon(Icons.arrow_back),
  onPressed: () => context.go('/owner'),
),
),
      body: FutureBuilder<List<TestItem>>(
        future: future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Error: ${snap.error}'),
            );
          }

          final items = snap.data ?? const <TestItem>[];
          if (items.isEmpty) {
            return const Center(child: Text('Sin datos'));
          }

          return ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final it = items[i];
              return ListTile(
                title: Text(it.name),
                subtitle: Text('code: ${it.code}'),
              );
            },
          );
        },
      ),
    );
  }
}
