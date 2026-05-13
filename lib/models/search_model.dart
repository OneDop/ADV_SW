class SearchProjectResult {
  final int id;
  final String name;
  final String description;
  final String status;

  SearchProjectResult({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
  });

  factory SearchProjectResult.fromJson(Map<String, dynamic> json) {
    return SearchProjectResult(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      status: json['status'],
    );
  }
}

class SkillEntry {
  final String skillName;
  final String experienceLevel;

  SkillEntry({
    required this.skillName,
    required this.experienceLevel,
  });

  factory SkillEntry.fromJson(Map<String, dynamic> json) {
    return SkillEntry(
      skillName: json['skillName'],
      experienceLevel: json['experienceLevel'],
    );
  }
}

class SearchUserResult {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String bio;
  final String? profilePictureUrl;
  final List<SkillEntry> skills;

  SearchUserResult({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.bio,
    this.profilePictureUrl,
    required this.skills,
  });

  factory SearchUserResult.fromJson(Map<String, dynamic> json) {
    return SearchUserResult(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      bio: json['bio'],
      profilePictureUrl: json['profilePictureUrl'],
      skills: (json['skills'] as List)
          .map((i) => SkillEntry.fromJson(i))
          .toList(),
    );
  }
}
