import '../storage/token_storage.dart';

class RouteGuard {
  final TokenStorage tokenStorage;

  RouteGuard(this.tokenStorage);

  Future<bool> isLoggedIn() async {
    final token = await tokenStorage.getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
