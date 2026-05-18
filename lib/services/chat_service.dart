import 'dart:async';
import 'package:advsw/mock/mock_data.dart';
import 'package:advsw/models/message_model.dart';

class ChatService {
  final _messageController = StreamController<MessageResponse>.broadcast();
  Stream<MessageResponse> get messages => _messageController.stream;

  void connect(int projectId) {
    // No-op in demo mode — history loaded separately via MessageService
  }

  void sendMessage(int projectId, SendMessageRequest request) {
    final msg = MessageResponse(
      id: MockData.nextMessageId(),
      projectId: projectId,
      senderId: MockData.currentUserId,
      senderName: '${MockData.currentUser.firstName} ${MockData.currentUser.lastName}',
      content: request.content,
      fileUrl: request.fileUrl,
      fileName: request.fileName,
      sentAt: DateTime.now(),
    );
    MockData.messagesByProject.putIfAbsent(projectId, () => []).add(msg);
    _messageController.add(msg);
  }

  void disconnect() {}

  void dispose() {
    _messageController.close();
  }
}
