enum NotificationType {
  PROJECT_INVITATION,
  TASK_ASSIGNED,
  DEADLINE_REMINDER,
  JOIN_REQUEST,
  JOIN_APPROVED,
  JOIN_REJECTED,
  NEW_MESSAGE,
}

class NotificationResponse {
  final int id;
  final int recipientId;
  final NotificationType type;
  final String message;
  final int? projectId;
  final String? projectName;
  final int? senderId;
  final DateTime createdAt;

  NotificationResponse({
    required this.id,
    required this.recipientId,
    required this.type,
    required this.message,
    this.projectId,
    this.projectName,
    this.senderId,
    required this.createdAt,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      id: json['id'],
      recipientId: json['recipientId'],
      type: NotificationType.values.byName(json['type']),
      message: json['message'],
      projectId: json['projectId'],
      projectName: json['projectName'],
      senderId: json['senderId'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
