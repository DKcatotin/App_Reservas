import 'package:agenda_app/features/auth/data/presentation/pages/login_page.dart';
import 'package:agenda_app/features/owner/appointments/presentation/pages/test_page.dart';
import 'package:go_router/go_router.dart';

import '../di/auth_di.dart';


import '../../features/owner/presentation/dashbord/owner_home_page.dart';
import '../../features/owner/appointments/presentation/pages/agenda_page.dart';

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
          builder: (_, __) => const OwnerHomePage(),
        ),

        // ✅ ESTA RUTA FALTABA
        GoRoute(
          path: '/owner/agenda',
          builder: (_, __) => AgendaPage(
            appointmentsRepository: deps.appointmentsRepository,
          ),
        ),
         GoRoute(
          path: '/owner/test',
          builder: (_, __) => TestPage(
            repo: deps.appointmentsRepository,
          ),
        ),
      ],
    );
  }
}
