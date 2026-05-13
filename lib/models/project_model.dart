enum MemberRole {
  OWNER,
  MEMBER,
  ADMIN,
}

enum ProjectStatus {
  OPEN,
  IN_PROGRESS,
  COMPLETED,
  CANCELLED,
}

class AddProjectMemberRequest {
  final int projectId;
  final int userId;
  final MemberRole memberRole;

  AddProjectMemberRequest({
    required this.projectId,
    required this.userId,
    required this.memberRole,
  });

  Map<String, dynamic> toJson() {
    return {
      'projectId': projectId,
      'userId': userId,
      'memberRole': memberRole.name,
    };
  }
}

class CreateProjectRequest {
  final String name;
  final String description;

  CreateProjectRequest({
    required this.name,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
    };
  }
}

class ProjectMemberResponse {
  final int id;
  final int projectId;
  final int userId;
  final String userName;
  final MemberRole memberRole;

  ProjectMemberResponse({
    required this.id,
    required this.projectId,
    required this.userId,
    required this.userName,
    required this.memberRole,
  });

  factory ProjectMemberResponse.fromJson(Map<String, dynamic> json) {
    return ProjectMemberResponse(
      id: json['id'],
      projectId: json['projectId'],
      userId: json['userId'],
      userName: json['userName'],
      memberRole: MemberRole.values.byName(json['memberRole']),
    );
  }
}

class ProjectResponse {
  final int id;
  final String name;
  final String description;
  final ProjectStatus status;
  final int ownerId;
  final String ownerName;
  final bool isDeleted;

  ProjectResponse({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.ownerId,
    required this.ownerName,
    required this.isDeleted,
  });

  factory ProjectResponse.fromJson(Map<String, dynamic> json) {
    return ProjectResponse(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      status: ProjectStatus.values.byName(json['status']),
      ownerId: json['ownerId'],
      ownerName: json['ownerName'],
      isDeleted: json['isDeleted'],
    );
  }
}

class ProjectSummaryResponse {
  final int id;
  final String name;
  final ProjectStatus status;
  final int ownerId;
  final String ownerName;

  ProjectSummaryResponse({
    required this.id,
    required this.name,
    required this.status,
    required this.ownerId,
    required this.ownerName,
  });

  factory ProjectSummaryResponse.fromJson(Map<String, dynamic> json) {
    return ProjectSummaryResponse(
      id: json['id'],
      name: json['name'],
      status: ProjectStatus.values.byName(json['status']),
      ownerId: json['ownerId'],
      ownerName: json['ownerName'],
    );
  }
}

class UpdateMemberRoleRequest {
  final MemberRole memberRole;

  UpdateMemberRoleRequest({
    required this.memberRole,
  });

  Map<String, dynamic> toJson() {
    return {
      'memberRole': memberRole.name,
    };
  }
}

class UpdateProjectRequest {
  final String name;
  final String description;
  final ProjectStatus status;

  UpdateProjectRequest({
    required this.name,
    required this.description,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'status': status.name,
    };
  }
}
