/// Entidad de perfil de usuario.
class Profile {
  final String uuid;
  final String? name;
  final String? lastname;
  final String? avatarUrl;
  final String? bio;
  final int totalPoints;
  final int level;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Profile({
    required this.uuid,
    this.name,
    this.lastname,
    this.avatarUrl,
    this.bio,
    required this.totalPoints,
    required this.level,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Retorna el nombre completo del usuario.
  String get fullName {
    if (name == null && lastname == null) {
      return 'Usuario';
    }
    return '${name ?? ''} ${lastname ?? ''}'.trim();
  }

  /// Retorna las iniciales del usuario para el avatar placeholder.
  String get initials {
    if (name == null || name!.isEmpty) return 'U';
    if (lastname == null || lastname!.isEmpty) return name![0].toUpperCase();
    return '${name![0]}${lastname![0]}'.toUpperCase();
  }
}
