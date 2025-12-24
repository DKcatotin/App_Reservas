import '../../../../core/storage/token_storage.dart';
import '../models/auth_response.dart';
import '../sources/auth_api.dart';

class AuthRepository {
  final AuthApi api;
  final TokenStorage tokenStorage;

  AuthRepository({required this.api, required this.tokenStorage});

  Future<AuthResponse> signIn(String username, String password) async {
    final auth = await api.signIn(username: username, password: password);
    await tokenStorage.saveAccessToken(auth.accessToken);
    return auth;
  }

  Future<void> signOut() async {
    await tokenStorage.clear();
  }
}
