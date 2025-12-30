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
