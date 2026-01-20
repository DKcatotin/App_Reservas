import 'package:equatable/equatable.dart';
import 'owner_model.dart';

import 'package:equatable/equatable.dart';
import 'owner_model.dart';

class AuthResponse extends Equatable {
  final String accessToken;
  final OwnerModel user;

  const AuthResponse({
    required this.accessToken,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final auth = data['auth'] as Map<String, dynamic>;

    return AuthResponse(
      accessToken: data['accessToken'] as String,
      user: OwnerModel.fromJson(auth),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': {
        'accessToken': accessToken,
        'auth': user.toJson(),
      },
    };
  }

  @override
  List<Object?> get props => [accessToken, user];
}
