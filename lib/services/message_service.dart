import 'package:advsw/mock/mock_data.dart';
import 'package:advsw/models/message_model.dart';

class MessageService {
  Future<MessageResponse> sendMessage(int projectId, SendMessageRequest request) async {
    await Future.delayed(const Duration(milliseconds: 300));
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
    return msg;
  }

  Future<List<MessageResponse>> getProjectHistory(int projectId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(MockData.messagesByProject[projectId] ?? []);
  }

  Future<void> deleteMessage(int messageId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    for (final list in MockData.messagesByProject.values) {
      list.removeWhere((m) => m.id == messageId);
    }
  }
}
