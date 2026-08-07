import 'package:flutter/foundation.dart';

@immutable
class ProfileModel {
  final String id;
  final String username;
  final String email;
  final String? avatarUrl;

  const ProfileModel({
    required this.id,
    required this.username,
    required this.email,
    this.avatarUrl,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatar_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'avatar_url': avatarUrl,
    };
  }

  ProfileModel copyWith({
    String? id,
    String? username,
    String? email,
    String? avatarUrl,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}