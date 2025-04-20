import 'package:flutter/foundation.dart' show immutable;

@immutable
class UserProfile {
  final String name;
  final String email;
  final String? profilePicturePath;

  const UserProfile({
    required this.name,
    required this.email,
    this.profilePicturePath,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] as String? ?? 'Unknown User',
      email: json['email'] as String? ?? 'No Email Provided',
      profilePicturePath: json['profilePicture'] as String?, // Allow null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'profilePicture': profilePicturePath,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfile &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          email == other.email &&
          profilePicturePath == other.profilePicturePath;

  @override
  int get hashCode =>
      name.hashCode ^ email.hashCode ^ profilePicturePath.hashCode;

  @override
  String toString() {
    return 'UserProfile{name: $name, email: $email, profilePicture: $profilePicturePath}';
  }
}
