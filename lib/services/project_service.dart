import 'package:advsw/mock/mock_data.dart';
import 'package:advsw/models/project_model.dart';

class ProjectService {
  Future<ProjectResponse> createProject(CreateProjectRequest request) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final id = DateTime.now().millisecondsSinceEpoch % 100000;
    final project = ProjectResponse(
      id: id,
      name: request.name,
      description: request.description,
      status: ProjectStatus.OPEN,
      ownerId: MockData.currentUserId,
      ownerName: '${MockData.currentUser.firstName} ${MockData.currentUser.lastName}',
      isDeleted: false,
    );
    MockData.myProjects.insert(0, project);
    MockData.projectMembers[id] = [
      ProjectMemberResponse(
        userId: MockData.currentUserId,
        email: MockData.currentUser.email,
        firstName: MockData.currentUser.firstName,
        lastName: MockData.currentUser.lastName,
        memberRole: MemberRole.OWNER,
      ),
    ];
    MockData.tasksByProject[id] = [];
    return project;
  }

  Future<ProjectResponse> updateProject(int id, UpdateProjectRequest request) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final idx = MockData.myProjects.indexWhere((p) => p.id == id);
    if (idx == -1) throw Exception('Project not found');
    final updated = ProjectResponse(
      id: id,
      name: request.name,
      description: request.description,
      status: request.status,
      ownerId: MockData.myProjects[idx].ownerId,
      ownerName: MockData.myProjects[idx].ownerName,
      isDeleted: false,
    );
    MockData.myProjects[idx] = updated;
    return updated;
  }

  Future<void> softDeleteProject(int id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    MockData.myProjects.removeWhere((p) => p.id == id);
  }

  Future<ProjectResponse> getProjectById(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final all = [...MockData.myProjects, ...MockData.browseProjects];
    final project = all.firstWhere(
      (p) => p.id == id,
      orElse: () => throw Exception('Project not found'),
    );
    return project;
  }

  Future<List<ProjectResponse>> getMyProjects() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return List.from(MockData.myProjects);
  }

  Future<List<ProjectResponse>> browseAvailableProjects() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return List.from(MockData.browseProjects);
  }

  Future<List<ProjectMemberResponse>> getProjectMembers(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(MockData.projectMembers[id] ?? []);
  }

  Future<List<ProjectMemberResponse>> updateMemberRole(
      int projectId, int userId, UpdateMemberRoleRequest request) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final members = MockData.projectMembers[projectId];
    if (members == null) throw Exception('Project not found');
    final idx = members.indexWhere((m) => m.userId == userId);
    if (idx == -1) throw Exception('Member not found');
    members[idx] = ProjectMemberResponse(
      userId: members[idx].userId,
      email: members[idx].email,
      firstName: members[idx].firstName,
      lastName: members[idx].lastName,
      profilePictureUrl: members[idx].profilePictureUrl,
      memberRole: request.memberRole,
    );
    return List.from(members);
  }

  Future<void> removeMember(int projectId, int userId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    MockData.projectMembers[projectId]?.removeWhere((m) => m.userId == userId);
  }

  Future<void> leaveProject(int projectId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    MockData.projectMembers[projectId]
        ?.removeWhere((m) => m.userId == MockData.currentUserId);
    MockData.myProjects.removeWhere((p) => p.id == projectId);
  }
}
