import 'package:go_router/go_router.dart';

import '../storage/token_storage.dart';

class RouteGuard {
  final TokenStorage tokenStorage;

  RouteGuard(this.tokenStorage);

  Future<bool> isLoggedIn() async {
    final token = await tokenStorage.getAccessToken();
    return token != null && token.isNotEmpty;
  }
   static Future<String?> authGuard(TokenStorage storage, GoRouterState state) async {
    final hasToken = await storage.hasToken();
    if (!hasToken) return '/login';
    return null;
  }
}
