class SendMessageRequest {
  final String content;
  final String? fileUrl;
  final String? fileName;

  SendMessageRequest({
    required this.content,
    this.fileUrl,
    this.fileName,
  });

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'fileUrl': fileUrl,
      'fileName': fileName,
    };
  }
}

class MessageResponse {
  final int id;
  final int projectId;
  final int senderId;
  final String senderName;
  final String content;
  final String? fileUrl;
  final String? fileName;
  final DateTime sentAt;

  MessageResponse({
    required this.id,
    required this.projectId,
    required this.senderId,
    required this.senderName,
    required this.content,
    this.fileUrl,
    this.fileName,
    required this.sentAt,
  });

  factory MessageResponse.fromJson(Map<String, dynamic> json) {
    return MessageResponse(
      id: json['id'],
      projectId: json['projectId'],
      senderId: json['senderId'],
      senderName: json['senderName'],
      content: json['content'],
      fileUrl: json['fileUrl'],
      fileName: json['fileName'],
      sentAt: DateTime.parse(json['sentAt']),
    );
  }
}
