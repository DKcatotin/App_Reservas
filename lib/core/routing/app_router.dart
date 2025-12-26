import 'package:go_router/go_router.dart';
import '../../features/auth/data/presentation/pages/login_page.dart';
import '../../features/owner/presentation/dashbord/owner_home_page.dart';
import '../../features/owner/presentation/appointments/presentation/pages/agenda_page.dart';
import '../storage/token_storage.dart';
import 'route_guard.dart';

class AppRouter {
  AppRouter._();

  static final _tokenStorage = TokenStorage();
  static final _guard = RouteGuard(_tokenStorage);

  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    redirect: (context, state) async {
      final loggedIn = await _guard.isLoggedIn();
      final goingToLogin = state.matchedLocation == '/login';

      if (!loggedIn && !goingToLogin) return '/login';
      if (loggedIn && goingToLogin) return '/owner';

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginPage(),
      ),
      GoRoute(
        path: '/owner',
        builder: (_, __) => const OwnerHomePage(),
      ),
      GoRoute(
        path: '/owner/agenda',
        builder: (_, __) => const AgendaPage(),
      ),
    ],
  );
}
