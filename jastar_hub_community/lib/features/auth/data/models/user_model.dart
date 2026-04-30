/// Represents a user in Jastar Hub Community.
class UserModel {
  final String id;
  final String email;
  final String name;
  final String avatarUrl;
  final String bio;
  final List<String> interests;
  final int eventsAttended;
  final int eventsOrganized;
  final int followers;
  final int following;
  final int points;
  final String rank;
  final String role;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.avatarUrl = '',
    this.bio = '',
    this.interests = const [],
    this.eventsAttended = 0,
    this.eventsOrganized = 0,
    this.followers = 0,
    this.following = 0,
    this.points = 0,
    this.rank = 'Newcomer',
    this.role = 'USER',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime(2026, 1, 1);

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? avatarUrl,
    String? bio,
    List<String>? interests,
    int? eventsAttended,
    int? eventsOrganized,
    int? followers,
    int? following,
    int? points,
    String? rank,
    String? role,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      interests: interests ?? this.interests,
      eventsAttended: eventsAttended ?? this.eventsAttended,
      eventsOrganized: eventsOrganized ?? this.eventsOrganized,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      points: points ?? this.points,
      rank: rank ?? this.rank,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'avatarUrl': avatarUrl,
      'bio': bio,
      'interests': interests,
      'eventsAttended': eventsAttended,
      'eventsOrganized': eventsOrganized,
      'followers': followers,
      'following': following,
      'points': points,
      'rank': rank,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatarUrl'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      interests: (json['interests'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      eventsAttended: json['eventsAttended'] as int? ?? 0,
      eventsOrganized: json['eventsOrganized'] as int? ?? 0,
      followers: json['followers'] as int? ?? 0,
      following: json['following'] as int? ?? 0,
      points: json['points'] as int? ?? 0,
      rank: json['rank'] as String? ?? 'Newcomer',
      role: json['role'] as String? ?? 'USER',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }
}
