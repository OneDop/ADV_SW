enum TaskStatus {
  TODO,
  IN_PROGRESS,
  DONE,
}

class CreateTaskRequest {
  final String title;
  final String description;
  final DateTime deadline;
  final int projectId;
  final int? assigneeId;

  CreateTaskRequest({
    required this.title,
    required this.description,
    required this.deadline,
    required this.projectId,
    this.assigneeId,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'deadline': deadline.toIso8601String(),
      'projectId': projectId,
      'assigneeId': assigneeId,
    };
  }
}

class TaskResponse {
  final int id;
  final String title;
  final String description;
  final TaskStatus status;
  final DateTime deadline;
  final int projectId;
  final int? assigneeId;
  final String? assigneeName;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  TaskResponse({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.deadline,
    required this.projectId,
    this.assigneeId,
    this.assigneeName,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TaskResponse.fromJson(Map<String, dynamic> json) {
    return TaskResponse(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: TaskStatus.values.byName(json['status']),
      deadline: DateTime.parse(json['deadline']),
      projectId: json['projectId'],
      assigneeId: json['assigneeId'],
      assigneeName: json['assigneeName'],
      isDeleted: json['isDeleted'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class AssignTaskRequest {
  final int assigneeId;

  AssignTaskRequest({required this.assigneeId});

  Map<String, dynamic> toJson() {
    return {
      'assigneeId': assigneeId,
    };
  }
}

class UpdateTaskStatusRequest {
  final TaskStatus status;

  UpdateTaskStatusRequest({required this.status});

  Map<String, dynamic> toJson() {
    return {
      'status': status.name,
    };
  }
}

class UpdateTaskRequest {
  final String title;
  final String description;
  final TaskStatus status;
  final DateTime deadline;
  final int? assigneeId;

  UpdateTaskRequest({
    required this.title,
    required this.description,
    required this.status,
    required this.deadline,
    this.assigneeId,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'status': status.name,
      'deadline': deadline.toIso8601String(),
      'assigneeId': assigneeId,
    };
  }
}
