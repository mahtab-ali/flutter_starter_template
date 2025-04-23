import 'package:supabase_flutter/supabase_flutter.dart';

class UserModel {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final Map<String, dynamic>? preferences;
  final DateTime? createdAt;
  final DateTime? lastLogin;

  const UserModel({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.preferences,
    this.createdAt,
    this.lastLogin,
  });

  // Create from Supabase User
  factory UserModel.fromSupabaseUser(User user) {
    return UserModel(
      id: user.id,
      email: user.email ?? '',
      displayName: user.userMetadata?['name'] as String?,
      photoUrl: user.userMetadata?['avatar_url'] as String?,
      createdAt:
          user.createdAt.isNotEmpty ? DateTime.parse(user.createdAt) : null,
      lastLogin:
          user.lastSignInAt != null
              ? DateTime.tryParse(user.lastSignInAt!)
              : null,
    );
  }

  // Create from map (e.g., from local storage or API)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      email: map['email'] as String,
      displayName: map['display_name'] as String?,
      photoUrl: map['photo_url'] as String?,
      preferences: map['preferences'] as Map<String, dynamic>?,
      createdAt:
          map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      lastLogin:
          map['last_login'] != null ? DateTime.parse(map['last_login']) : null,
    );
  }

  // Convert to map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'display_name': displayName,
      'photo_url': photoUrl,
      'preferences': preferences,
      'created_at': createdAt?.toIso8601String(),
      'last_login': lastLogin?.toIso8601String(),
    };
  }

  // Create a copy with modified fields
  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    Map<String, dynamic>? preferences,
    DateTime? createdAt,
    DateTime? lastLogin,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      preferences: preferences ?? this.preferences,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }
}
