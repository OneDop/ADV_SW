import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:advsw/models/project_model.dart';
import 'package:advsw/services/project_service.dart';

/// Provider for ProjectService
final projectServiceProvider = Provider<ProjectService>((ref) {
  return ProjectService();
});

/// AsyncNotifier to manage the user's projects
class MyProjectsNotifier extends AsyncNotifier<List<ProjectResponse>> {
  @override
  Future<List<ProjectResponse>> build() {
    return ref.watch(projectServiceProvider).getMyProjects();
  }

  /// Create a new project and refresh the list
  Future<void> createProject(CreateProjectRequest request) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(projectServiceProvider).createProject(request);
      return ref.read(projectServiceProvider).getMyProjects();
    });
  }

  /// Update an existing project and refresh the list
  Future<void> updateProject(int id, UpdateProjectRequest request) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(projectServiceProvider).updateProject(id, request);
      return ref.read(projectServiceProvider).getMyProjects();
    });
  }

  /// Soft delete a project and refresh the list
  Future<void> deleteProject(int id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(projectServiceProvider).softDeleteProject(id);
      return ref.read(projectServiceProvider).getMyProjects();
    });
  }

  /// Leave a project and refresh the list
  Future<void> leaveProject(int projectId) async {
    state = await AsyncValue.guard(() async {
      await ref.read(projectServiceProvider).leaveProject(projectId);
      return ref.read(projectServiceProvider).getMyProjects();
    });
  }

  /// Refresh the list of user's projects
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(projectServiceProvider).getMyProjects());
  }
}

/// Provider for the current user's projects
final myProjectsProvider = AsyncNotifierProvider<MyProjectsNotifier, List<ProjectResponse>>(MyProjectsNotifier.new);

/// AsyncNotifier to manage browsing available projects
class BrowseProjectsNotifier extends AsyncNotifier<List<ProjectResponse>> {
  @override
  Future<List<ProjectResponse>> build() {
    return ref.watch(projectServiceProvider).browseAvailableProjects();
  }

  /// Refresh the list of available projects
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(projectServiceProvider).browseAvailableProjects());
  }
}

/// Provider for browsing available projects
final browseProjectsProvider = AsyncNotifierProvider<BrowseProjectsNotifier, List<ProjectResponse>>(BrowseProjectsNotifier.new);

/// Provider to fetch project details by ID
final projectDetailsProvider = FutureProvider.family<ProjectResponse, int>((ref, id) {
  return ref.watch(projectServiceProvider).getProjectById(id);
});

/// AsyncNotifier to manage project members
class ProjectMembersNotifier extends FamilyAsyncNotifier<List<ProjectMemberResponse>, int> {
  @override
  Future<List<ProjectMemberResponse>> build(int arg) {
    return ref.watch(projectServiceProvider).getProjectMembers(arg);
  }

  /// Update a member's role and refresh the list
  Future<void> updateMemberRole(int userId, UpdateMemberRoleRequest request) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await ref.read(projectServiceProvider).updateMemberRole(arg, userId, request);
    });
  }

  /// Remove a member from the project
  Future<void> removeMember(int userId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(projectServiceProvider).removeMember(arg, userId);
      return ref.read(projectServiceProvider).getProjectMembers(arg);
    });
  }

  /// Refresh the members list
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(projectServiceProvider).getProjectMembers(arg));
  }
}

/// Provider for project members, indexed by project ID
final projectMembersProvider = AsyncNotifierProviderFamily<ProjectMembersNotifier, List<ProjectMemberResponse>, int>(
  ProjectMembersNotifier.new,
);
