import 'package:agenda_app/features/owner/appointments/presentation/pages/appointment_form_page.dart';
import 'package:agenda_app/features/owner/appointments/presentation/pages/cliente_busqueda_page.dart';
import 'package:agenda_app/features/owner/appointments/presentation/pages/cliente_form_page.dart';
import 'package:agenda_app/features/owner/catalogues/presentation/pages/catalogue_test_page.dart';
import '../../features/auth/data/presentation/pages/login_page.dart';
import 'package:agenda_app/features/owner/appointments/presentation/pages/diary_page.dart';
import 'package:agenda_app/features/owner/presentation/dashbord/owner_home_page.dart';
import 'package:go_router/go_router.dart';
import '../di/auth_di.dart';

class AppRouter {
  static GoRouter router(AppDependencies deps) {
    return GoRouter(
      initialLocation: '/login',
      routes: [
        GoRoute(
          path: '/login',
          builder: (_, __) => LoginPage(
            authRepository: deps.authRepository,
          ),
        ),
        GoRoute(
          path: '/owner',
          builder: (_, __) => OwnerHomePage(
            repo: deps.appointmentsRepository,
          ),
        ),
        
        // 🔍 Nueva ruta: Buscar cliente
        GoRoute(
          path: '/owner/appointments/cliente/buscar',
          builder: (_, __) => const ClienteBusquedaPage(),
        ),
        
        // ➕ Nueva ruta: Crear cliente
        GoRoute(
          path: '/owner/appointments/cliente/new',
          builder: (context, state) {
            final cedula = state.extra as String?;
            return ClienteFormPage(cedulaPrellenada: cedula);
          },
        ),
        
        // 📝 Ruta existente: Crear cita
        GoRoute(
          path: '/owner/citas',
          builder: (_, __) => AppointmentFormPage(
            repo: deps.appointmentsRepository,
          ),
        ),
        
        // 📔 Agenda (JSON hoy)
        GoRoute(
          path: '/owner/agenda',
          builder: (_, __) => DiaryPage(
            repo: deps.appointmentsRepository,
          ),
        ),
        GoRoute(
          path: '/owner/test1',
          builder: (_, __) => TestPage(
            repo: deps.cataloguesRepository,
          ),
        ),
      ],
    );
  }
}
