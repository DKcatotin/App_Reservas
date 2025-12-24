import 'package:equatable/equatable.dart';
import 'auth_user.dart';

class AuthResponse extends Equatable {
  final String accessToken;
  final AuthUser user;

  const AuthResponse({required this.accessToken, required this.user});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] ?? {}) as Map<String, dynamic>;
    final auth = (data['auth'] ?? {}) as Map<String, dynamic>;

    return AuthResponse(
      accessToken: (data['accessToken'] ?? '') as String,
      user: AuthUser.fromJson(auth),
    );
  }

  @override
  List<Object?> get props => [accessToken, user];
}
