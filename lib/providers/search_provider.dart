import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:advsw/models/search_model.dart';
import 'package:advsw/models/user_model.dart';
import 'package:advsw/services/search_service.dart';

/// Provider for SearchService
final searchServiceProvider = Provider<SearchService>((ref) {
  return SearchService();
});

/// AsyncNotifier to manage user search results
class UserSearchNotifier extends AsyncNotifier<List<SearchUserResult>> {
  @override
  FutureOr<List<SearchUserResult>> build() {
    return []; // Start with an empty list
  }

  /// Search users by name and/or skills
  Future<void> search({String? name, List<int>? skillIds}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(searchServiceProvider).searchUsers(name: name, skillIds: skillIds));
  }

  /// Search users specifically by a single skill and optional experience level
  Future<void> searchBySkill(int skillId, {ExperienceLevel? experienceLevel}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(searchServiceProvider).searchUsersBySkill(skillId, experienceLevel: experienceLevel));
  }

  /// Get recommended users based on a list of skill IDs
  Future<void> recommendBySkills(List<int> skillIds) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(searchServiceProvider).recommendUsersBySkills(skillIds));
  }
  
  /// Clear search results
  void clear() {
    state = const AsyncValue.data([]);
  }
}

/// Provider for user search results
final userSearchProvider = AsyncNotifierProvider<UserSearchNotifier, List<SearchUserResult>>(UserSearchNotifier.new);

/// AsyncNotifier to manage project search results
class ProjectSearchNotifier extends AsyncNotifier<List<SearchProjectResult>> {
  @override
  FutureOr<List<SearchProjectResult>> build() {
    return ref.watch(searchServiceProvider).browseOpenProjects();
  }

  /// Browse or search for open projects by name
  Future<void> searchProjects({String? name}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(searchServiceProvider).browseOpenProjects(name: name));
  }

  /// Clear search results and return to browsing all open projects
  Future<void> clear() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(searchServiceProvider).browseOpenProjects());
  }
}

/// Provider for project search results
final projectSearchProvider = AsyncNotifierProvider<ProjectSearchNotifier, List<SearchProjectResult>>(ProjectSearchNotifier.new);
