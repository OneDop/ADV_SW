enum ExperienceLevel {
  BEGINNER,
  INTERMEDIATE,
  ADVANCED,
  PROFESSIONAL,
}

enum Role {
  USER,
  ADMIN,
}

enum AvailabilityStatus {
  AVAILABLE,
  AWAY,
}

class AddUserSkillRequest {
  final int skillId;
  final ExperienceLevel experienceLevel;

  AddUserSkillRequest({
    required this.skillId,
    required this.experienceLevel,
  });

  Map<String, dynamic> toJson() {
    return {
      'skillId': skillId,
      'experienceLevel': experienceLevel.name,
    };
  }
}

class UserSummaryResponse {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String? profilePictureUrl;

  UserSummaryResponse({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.profilePictureUrl,
  });

  factory UserSummaryResponse.fromJson(Map<String, dynamic> json) {
    return UserSummaryResponse(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      profilePictureUrl: json['profilePictureUrl'],
    );
  }
}

class UpdateProfileRequest {
  final String firstName;
  final String lastName;
  final String bio;
  final String? profilePictureUrl;
  final AvailabilityStatus availabilityStatus;

  UpdateProfileRequest({
    required this.firstName,
    required this.lastName,
    required this.bio,
    this.profilePictureUrl,
    required this.availabilityStatus,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'bio': bio,
      'profilePictureUrl': profilePictureUrl,
      'availabilityStatus': availabilityStatus.name,
    };
  }
}

class UpdatePortfolioRequest {
  final ExperienceLevel experienceLevel;
  final List<Map<String, dynamic>> pastProjects;

  UpdatePortfolioRequest({
    required this.experienceLevel,
    required this.pastProjects,
  });

  Map<String, dynamic> toJson() {
    return {
      'experienceLevel': experienceLevel.name,
      'pastProjects': pastProjects,
    };
  }
}

class PastProjectResponse {
  final int? id;
  final String name;
  final String description;
  final String? projectLink;

  PastProjectResponse({
    this.id,
    required this.name,
    required this.description,
    this.projectLink,
  });

  factory PastProjectResponse.fromJson(Map<String, dynamic> json) {
    return PastProjectResponse(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      projectLink: json['projectLink'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'projectLink': projectLink,
    };
  }
}

class UserProfileResponse {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String bio;
  final String? profilePictureUrl;
  final ExperienceLevel? experienceLevel;
  final Role role;
  final AvailabilityStatus availabilityStatus;
  final List<UserSkillResponse> skills;
  final List<PastProjectResponse> pastProjects;
  final double averageRating;

  UserProfileResponse({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.bio,
    this.profilePictureUrl,
    this.experienceLevel,
    required this.role,
    required this.availabilityStatus,
    required this.skills,
    required this.pastProjects,
    required this.averageRating,
  });

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    return UserProfileResponse(
      id: json['id'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      bio: json['bio'] ?? '',
      profilePictureUrl: json['profilePictureUrl'],
      experienceLevel: json['experienceLevel'] != null 
          ? ExperienceLevel.values.byName(json['experienceLevel']) 
          : null,
      role: Role.values.byName(json['role']),
      availabilityStatus: AvailabilityStatus.values.byName(json['availabilityStatus'] ?? 'AVAILABLE'),
      skills: (json['skills'] as List? ?? [])
          .map((s) => UserSkillResponse.fromJson(s))
          .toList(),
      pastProjects: (json['pastProjects'] as List? ?? [])
          .map((p) => PastProjectResponse.fromJson(p))
          .toList(),
      averageRating: (json['averageRating'] as num? ?? 0.0).toDouble(),
    );
  }
}

class UserSkillResponse {
  final int id;
  final int userId;
  final int skillId;
  final String skillName;
  final ExperienceLevel experienceLevel;

  UserSkillResponse({
    required this.id,
    required this.userId,
    required this.skillId,
    required this.skillName,
    required this.experienceLevel,
  });

  factory UserSkillResponse.fromJson(Map<String, dynamic> json) {
    return UserSkillResponse(
      id: json['id'],
      userId: json['userId'],
      skillId: json['skillId'],
      skillName: json['skillName'],
      experienceLevel: ExperienceLevel.values.byName(json['experienceLevel']),
    );
  }
}

class ChangePasswordRequest {
  final String oldPassword;
  final String newPassword;
  final String confirmNewPassword;

  ChangePasswordRequest({
    required this.oldPassword,
    required this.newPassword,
    required this.confirmNewPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'oldPassword': oldPassword,
      'newPassword': newPassword,
      'confirmNewPassword': confirmNewPassword,
    };
  }
}
