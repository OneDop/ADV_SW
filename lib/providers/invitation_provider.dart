import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:advsw/models/invitation_model.dart';
import 'package:advsw/services/invitation_service.dart';

/// Provider for InvitationService
final invitationServiceProvider = Provider<InvitationService>((ref) {
  return InvitationService();
});

/// AsyncNotifier to manage pending invitations for the current user
class UserInvitationsNotifier extends AsyncNotifier<List<InvitationResponse>> {
  @override
  FutureOr<List<InvitationResponse>> build() async {
    return ref.watch(invitationServiceProvider).getPendingInvitationsForUser();
  }

  /// Respond to an invitation and update local state
  Future<void> respond(int id, bool accept) async {
    state = await AsyncValue.guard(() async {
      await ref.read(invitationServiceProvider).respondToInvitation(
        id, 
        RespondInvitationRequest(accept: accept),
      );
      // After responding, the invitation is usually no longer pending
      final currentInvitations = state.value ?? [];
      return currentInvitations.where((i) => i.id != id).toList();
    });
  }

  /// Send a join request to a project
  Future<void> sendJoinRequest(int projectId) async {
    state = await AsyncValue.guard(() async {
      await ref.read(invitationServiceProvider).sendJoinRequest(projectId);
      return ref.read(invitationServiceProvider).getPendingInvitationsForUser();
    });
  }

  /// Refresh the user's invitations
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(invitationServiceProvider).getPendingInvitationsForUser());
  }
}

/// Provider for the current user's pending invitations
final userInvitationsProvider = AsyncNotifierProvider<UserInvitationsNotifier, List<InvitationResponse>>(UserInvitationsNotifier.new);

/// AsyncNotifier to manage pending join requests for a specific project
class ProjectJoinRequestsNotifier extends FamilyAsyncNotifier<List<InvitationResponse>, int> {
  @override
  FutureOr<List<InvitationResponse>> build(int arg) async {
    return ref.watch(invitationServiceProvider).getPendingJoinRequestsForProject(arg);
  }

  /// Respond to a join request and update local state
  Future<void> respond(int id, bool accept) async {
    state = await AsyncValue.guard(() async {
      await ref.read(invitationServiceProvider).respondToInvitation(
        id, 
        RespondInvitationRequest(accept: accept),
      );
      final currentRequests = state.value ?? [];
      return currentRequests.where((i) => i.id != id).toList();
    });
  }

  /// Send an invite to a user for this project
  Future<void> sendInvite(int receiverId) async {
    state = await AsyncValue.guard(() async {
      await ref.read(invitationServiceProvider).sendInvite(arg, receiverId);
      return ref.read(invitationServiceProvider).getPendingJoinRequestsForProject(arg);
    });
  }

  /// Refresh the join requests for this project
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(invitationServiceProvider).getPendingJoinRequestsForProject(arg));
  }
}

/// Provider for pending join requests of a specific project
final projectJoinRequestsProvider = AsyncNotifierProvider.family<ProjectJoinRequestsNotifier, List<InvitationResponse>, int>(
  ProjectJoinRequestsNotifier.new,
);
