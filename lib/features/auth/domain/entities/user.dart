import 'package:equatable/equatable.dart';

/// Entidad de usuario en el dominio.
/// 
/// Representa un usuario autenticado en la aplicación.
class User extends Equatable {
  final int userId;
  final String name;
  final String lastname;
  final String email;
  final String? avatarUrl;
  final String? bio;
  final List<String> roles;

  const User({
    required this.userId,
    required this.name,
    required this.lastname,
    required this.email,
    this.avatarUrl,
    this.bio,
    required this.roles,
  });

  @override
  List<Object?> get props => [userId, name, lastname, email, avatarUrl, bio, roles];
}
