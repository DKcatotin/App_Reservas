import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/storage/token_storage.dart';

class OwnerHomePage extends StatelessWidget {
  const OwnerHomePage({super.key});

  Future<void> _logout(BuildContext context) async {
    await TokenStorage().clear();
    if (context.mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Owner Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bienvenido 👋',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Aquí puedes gestionar tu agenda y tus citas.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.calendar_month),
                label: const Text('Ver agenda'),
                onPressed: () => context.push('/owner/agenda'),
              ),
            ),
            ElevatedButton.icon(
  icon: const Icon(Icons.bug_report),
  label: const Text('Probar ruta privada'),
  onPressed: () => context.go('/owner/test'),
),

          ],
        ),
      ),
    );
  }
}
