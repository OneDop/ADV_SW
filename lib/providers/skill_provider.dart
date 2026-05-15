import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:advsw/models/skill_model.dart';
import 'package:advsw/models/user_model.dart';
import 'package:advsw/services/skill_service.dart';

/// Provider for SkillService
final skillServiceProvider = Provider<SkillService>((ref) {
  return SkillService();
});

/// AsyncNotifier to manage the list of all available skills
class AllSkillsNotifier extends AsyncNotifier<List<SkillResponse>> {
  @override
  FutureOr<List<SkillResponse>> build() async {
    return ref.watch(skillServiceProvider).getAllSkills();
  }

  /// Create a new skill and update the local state
  Future<void> createSkill(CreateSkillRequest request) async {
    state = await AsyncValue.guard(() async {
      final newSkill = await ref.read(skillServiceProvider).createSkill(request);
      final currentSkills = state.value ?? [];
      return [...currentSkills, newSkill];
    });
  }

  /// Refresh the list of all skills
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(skillServiceProvider).getAllSkills());
  }
}

/// Provider for all available skills
final allSkillsProvider = AsyncNotifierProvider<AllSkillsNotifier, List<SkillResponse>>(AllSkillsNotifier.new);

/// AsyncNotifier to manage skills for a specific user
class UserSkillsNotifier extends FamilyAsyncNotifier<List<UserSkillResponse>, int> {
  @override
  FutureOr<List<UserSkillResponse>> build(int arg) async {
    return ref.watch(skillServiceProvider).getUserSkills(arg);
  }

  /// Add a skill to the user's profile and update local state
  Future<void> addSkillToUser(AddUserSkillRequest request) async {
    state = await AsyncValue.guard(() async {
      final newUserSkill = await ref.read(skillServiceProvider).addSkillToUser(request);
      final currentSkills = state.value ?? [];
      return [...currentSkills, newUserSkill];
    });
  }

  /// Remove a skill from the user's profile and update local state
  Future<void> removeSkillFromUser(int skillId) async {
    state = await AsyncValue.guard(() async {
      await ref.read(skillServiceProvider).removeSkillFromUser(skillId);
      final currentSkills = state.value ?? [];
      return currentSkills.where((s) => s.skillId != skillId).toList();
    });
  }

  /// Refresh the user's skills
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(skillServiceProvider).getUserSkills(arg));
  }
}

/// Provider for skills of a specific user (indexed by userId)
final userSkillsProvider = AsyncNotifierProvider.family<UserSkillsNotifier, List<UserSkillResponse>, int>(
  UserSkillsNotifier.new,
);
