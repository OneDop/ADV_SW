enum InvitationStatus {
  PENDING,
  ACCEPTED,
  REJECTED,
  EXPIRED,
  CANCELLED,
}

enum InvitationType {
  PROJECT_INVITATION,
  COLLABORATION_REQUEST,
}

class CreateInvitationRequest {
  final int projectId;
  final int receiverId;

  CreateInvitationRequest({
    required this.projectId,
    required this.receiverId,
  });

  Map<String, dynamic> toJson() {
    return {
      'projectId': projectId,
      'receiverId': receiverId,
    };
  }
}

class InvitationResponse {
  final int id;
  final int projectId;
  final String projectName;
  final int senderId;
  final String senderName;
  final int receiverId;
  final String receiverName;
  final InvitationStatus status;
  final InvitationType type;

  InvitationResponse({
    required this.id,
    required this.projectId,
    required this.projectName,
    required this.senderId,
    required this.senderName,
    required this.receiverId,
    required this.receiverName,
    required this.status,
    required this.type,
  });

  factory InvitationResponse.fromJson(Map<String, dynamic> json) {
    return InvitationResponse(
      id: json['id'],
      projectId: json['projectId'],
      projectName: json['projectName'],
      senderId: json['senderId'],
      senderName: json['senderName'],
      receiverId: json['receiverId'],
      receiverName: json['receiverName'],
      status: InvitationStatus.values.byName(json['status']),
      type: InvitationType.values.byName(json['type']),
    );
  }
}

class RespondInvitationRequest {
  final bool accept;

  RespondInvitationRequest({
    required this.accept,
  });

  Map<String, dynamic> toJson() {
    return {
      'accept': accept,
    };
  }
}
