class AdminStats {
  final int totalUsers;
  final int activeUsers;
  final int blockedUsers;
  final int adminUsers;
  final int totalProjects;
  final int activeProjects;
  final int endedProjects;
  final int totalSkills;

  AdminStats({
    required this.totalUsers,
    required this.activeUsers,
    required this.blockedUsers,
    required this.adminUsers,
    required this.totalProjects,
    required this.activeProjects,
    required this.endedProjects,
    required this.totalSkills,
  });

  factory AdminStats.fromJson(Map<String, dynamic> json) {
    return AdminStats(
      totalUsers: (json['totalUsers'] as num).toInt(),
      activeUsers: (json['activeUsers'] as num).toInt(),
      blockedUsers: (json['blockedUsers'] as num).toInt(),
      adminUsers: (json['adminUsers'] as num).toInt(),
      totalProjects: (json['totalProjects'] as num).toInt(),
      activeProjects: (json['activeProjects'] as num).toInt(),
      endedProjects: (json['endedProjects'] as num).toInt(),
      totalSkills: (json['totalSkills'] as num).toInt(),
    );
  }
}

class AdminUser {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String? bio;
  final String? profilePictureUrl;
  final bool isActive;
  final String role;
  final int projectCount;

  AdminUser({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.bio,
    this.profilePictureUrl,
    required this.isActive,
    required this.role,
    required this.projectCount,
  });

  String get name => '$firstName $lastName';
  bool get isBlocked => !isActive;

  factory AdminUser.fromJson(Map<String, dynamic> json) {
    return AdminUser(
      id: json['id'],
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      bio: json['bio'],
      profilePictureUrl: json['profilePictureUrl'],
      isActive: json['isActive'] ?? true,
      role: json['role'] ?? 'USER',
      projectCount: json['projectCount'] ?? 0,
    );
  }
}

class AdminProject {
  final int id;
  final String name;
  final String description;
  final String status;
  final int ownerId;
  final String ownerName;
  final bool isDeleted;
  final int memberCount;

  AdminProject({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.ownerId,
    required this.ownerName,
    required this.isDeleted,
    required this.memberCount,
  });

  bool get isHidden => isDeleted;

  factory AdminProject.fromJson(Map<String, dynamic> json) {
    return AdminProject(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? '',
      ownerId: json['ownerId'] ?? 0,
      ownerName: json['ownerName'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
      memberCount: json['memberCount'] ?? 0,
    );
  }
}
