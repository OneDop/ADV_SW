import 'package:advsw/mock/mock_data.dart';
import 'package:advsw/models/invitation_model.dart';
import 'package:advsw/models/project_model.dart';

class InvitationService {
  Future<InvitationResponse> sendInvite(int projectId, int receiverId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final receiver = MockData.otherUsers[receiverId];
    final project = [...MockData.myProjects, ...MockData.browseProjects]
        .firstWhere((p) => p.id == projectId);
    final invite = InvitationResponse(
      id: DateTime.now().millisecondsSinceEpoch % 100000,
      projectId: projectId,
      projectName: project.name,
      senderId: MockData.currentUserId,
      senderName: '${MockData.currentUser.firstName} ${MockData.currentUser.lastName}',
      receiverId: receiverId,
      receiverName: receiver != null ? '${receiver.firstName} ${receiver.lastName}' : 'Unknown',
      status: InvitationStatus.PENDING,
      type: InvitationType.INVITE,
    );
    return invite;
  }

  Future<InvitationResponse> sendJoinRequest(int projectId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final project = [...MockData.myProjects, ...MockData.browseProjects]
        .firstWhere((p) => p.id == projectId);
    final request = InvitationResponse(
      id: DateTime.now().millisecondsSinceEpoch % 100000,
      projectId: projectId,
      projectName: project.name,
      senderId: MockData.currentUserId,
      senderName: '${MockData.currentUser.firstName} ${MockData.currentUser.lastName}',
      receiverId: project.ownerId,
      receiverName: project.ownerName,
      status: InvitationStatus.PENDING,
      type: InvitationType.JOIN_REQUEST,
    );
    return request;
  }

  Future<InvitationResponse> respondToInvitation(int id, RespondInvitationRequest request) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final status = request.accept ? InvitationStatus.ACCEPTED : InvitationStatus.REJECTED;

    // Try user invitations first
    final invIdx = MockData.userInvitations.indexWhere((i) => i.id == id);
    if (invIdx != -1) {
      final original = MockData.userInvitations[invIdx];
      final updated = InvitationResponse(
        id: original.id, projectId: original.projectId, projectName: original.projectName,
        senderId: original.senderId, senderName: original.senderName,
        receiverId: original.receiverId, receiverName: original.receiverName,
        status: status, type: original.type,
      );
      MockData.userInvitations.removeAt(invIdx);
      return updated;
    }

    // Try join requests
    final jrIdx = MockData.ownerJoinRequests.indexWhere((i) => i.id == id);
    if (jrIdx != -1) {
      final original = MockData.ownerJoinRequests[jrIdx];
      final updated = InvitationResponse(
        id: original.id, projectId: original.projectId, projectName: original.projectName,
        senderId: original.senderId, senderName: original.senderName,
        receiverId: original.receiverId, receiverName: original.receiverName,
        status: status, type: original.type,
      );
      MockData.ownerJoinRequests.removeAt(jrIdx);
      if (request.accept) {
        final sender = MockData.otherUsers[original.senderId];
        if (sender != null) {
          MockData.projectMembers.putIfAbsent(original.projectId, () => []).add(
            ProjectMemberResponse(
              userId: sender.id,
              email: sender.email,
              firstName: sender.firstName,
              lastName: sender.lastName,
              memberRole: MemberRole.MEMBER,
            ),
          );
        }
      }
      return updated;
    }

    throw Exception('Invitation not found');
  }

  Future<List<InvitationResponse>> getPendingInvitationsForUser() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(MockData.userInvitations);
  }

  Future<List<InvitationResponse>> getPendingJoinRequestsForProject(int projectId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockData.ownerJoinRequests.where((r) => r.projectId == projectId).toList();
  }

  Future<List<InvitationResponse>> getJoinRequestsForOwner() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(MockData.ownerJoinRequests);
  }
}
