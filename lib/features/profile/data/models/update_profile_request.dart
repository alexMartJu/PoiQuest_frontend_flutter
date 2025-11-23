/// Request para actualizar el perfil.
class UpdateProfileRequest {
  final String? name;
  final String? lastname;
  final String? bio;

  const UpdateProfileRequest({
    this.name,
    this.lastname,
    this.bio,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (name != null) json['name'] = name;
    if (lastname != null) json['lastname'] = lastname;
    if (bio != null) json['bio'] = bio;
    return json;
  }
}
