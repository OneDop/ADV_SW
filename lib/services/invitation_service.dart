import 'package:advsw/models/invitation_model.dart';
import 'package:advsw/services/api_client.dart';

class InvitationService {
  final ApiClient _apiClient = ApiClient();

  /// POST /api/invitations/invite
  Future<InvitationResponse> sendInvite(int projectId, int receiverId) async {
    try {
      final request = CreateInvitationRequest(
        projectId: projectId,
        receiverId: receiverId,
      );
      final response = await _apiClient.post(
        '/invitations/invite',
        data: request.toJson(),
      );
      return InvitationResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// POST /api/invitations/join-request?projectId={projectId}
  Future<InvitationResponse> sendJoinRequest(int projectId) async {
    try {
      final response = await _apiClient.post(
        '/invitations/join-request',
        queryParameters: {'projectId': projectId},
      );
      return InvitationResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// PATCH /api/invitations/{id}/respond
  Future<InvitationResponse> respondToInvitation(int id, RespondInvitationRequest request) async {
    try {
      final response = await _apiClient.patch(
        '/invitations/$id/respond',
        data: request.toJson(),
      );
      return InvitationResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// GET /api/invitations/my
  Future<List<InvitationResponse>> getPendingInvitationsForUser() async {
    try {
      final response = await _apiClient.get('/invitations/my');
      final List<dynamic> data = response.data;
      return data.map((json) => InvitationResponse.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// GET /api/invitations/join-requests/{projectId}
  Future<List<InvitationResponse>> getPendingJoinRequestsForProject(int projectId) async {
    try {
      final response = await _apiClient.get('/invitations/join-requests/$projectId');
      final List<dynamic> data = response.data;
      return data.map((json) => InvitationResponse.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// GET /api/invitations/my-join-requests
  Future<List<InvitationResponse>> getJoinRequestsForOwner() async {
    try {
      final response = await _apiClient.get('/invitations/my-join-requests');
      final List<dynamic> data = response.data;
      return data.map((json) => InvitationResponse.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
