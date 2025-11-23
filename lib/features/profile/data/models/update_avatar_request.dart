/// Request para actualizar el avatar.
class UpdateAvatarRequest {
  final String avatarUrl;

  const UpdateAvatarRequest({
    required this.avatarUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'avatarUrl': avatarUrl,
    };
  }
}
