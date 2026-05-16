import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:advsw/services/chat_service.dart';
import 'package:advsw/models/message_model.dart';
import 'package:advsw/services/message_service.dart';

/// Provider for ChatService
final chatServiceProvider = Provider<ChatService>((ref) {
  final service = ChatService();
  ref.onDispose(() => service.disconnect());
  return service;
});

/// Provider for MessageService
final messageServiceProvider = Provider<MessageService>((ref) {
  return MessageService();
});

/// StreamProvider for real-time messages from WebSocket
final chatMessagesStreamProvider = StreamProvider.family<MessageResponse, int>((ref, projectId) {
  final chatService = ref.watch(chatServiceProvider);
  // Ensure we are connected to the project's websocket
  chatService.connect(projectId);
  return chatService.messages;
});

/// AsyncNotifier to manage chat messages (History + Real-time)
class ChatNotifier extends FamilyAsyncNotifier<List<MessageResponse>, int> {
  @override
  FutureOr<List<MessageResponse>> build(int arg) async {
    // Listen for new messages coming from the StreamProvider
    ref.listen(chatMessagesStreamProvider(arg), (previous, next) {
      next.whenData((message) {
        if (state.hasValue) {
          final currentMessages = state.value!;
          // Prevent duplicates if history and real-time overlap
          if (!currentMessages.any((m) => m.id == message.id)) {
            state = AsyncValue.data([...currentMessages, message]);
          }
        }
      });
    });

    // Fetch initial history
    return ref.watch(messageServiceProvider).getProjectHistory(arg);
  }

  /// Action to send a message
  void sendMessage(String content, {String? fileUrl, String? fileName}) {
    final request = SendMessageRequest(
      content: content,
      fileUrl: fileUrl,
      fileName: fileName,
    );
    ref.read(chatServiceProvider).sendMessage(arg, request);
  }

  /// Delete a message by ID
  Future<void> deleteMessage(int messageId) async {
    state = await AsyncValue.guard(() async {
      await ref.read(messageServiceProvider).deleteMessage(messageId);
      final current = state.value ?? [];
      return current.where((m) => m.id != messageId).toList();
    });
  }
}

/// Main provider for the Chat UI
final chatProvider = AsyncNotifierProvider.family<ChatNotifier, List<MessageResponse>, int>(
  ChatNotifier.new,
);
