import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:advsw/models/user_model.dart';
import 'package:advsw/services/user_service.dart';
import 'package:advsw/providers/auth_provider.dart';

/// Provider for UserService
final userServiceProvider = Provider<UserService>((ref) {
  return UserService();
});

/// AsyncNotifier to manage the current user's profile state
class UserProfileNotifier extends AsyncNotifier<UserProfileResponse> {
  @override
  Future<UserProfileResponse> build() {
    return ref.watch(userServiceProvider).getCurrentUserProfile();
  }

  /// Update the current user's profile
  Future<void> updateProfile(UpdateProfileRequest request) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(userServiceProvider).updateProfile(request));
  }

  /// Update user's portfolio (Experience Level and Past Projects)
  Future<void> updatePortfolio(UpdatePortfolioRequest request) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(userServiceProvider).updatePortfolio(request));
  }

  /// Change the current user's password
  Future<void> changePassword(ChangePasswordRequest request) async {
    await ref.read(userServiceProvider).changePassword(request);
  }

  /// Upload a new profile picture
  Future<void> uploadProfilePicture(String filePath) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(userServiceProvider).uploadProfilePicture(filePath));
  }

  /// Add a skill to the user's profile
  Future<void> addSkill(AddUserSkillRequest request) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(userServiceProvider).addSkill(request);
      return ref.read(userServiceProvider).getCurrentUserProfile();
    });
  }

  /// Remove a skill from the user's profile
  Future<void> removeSkill(int skillId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(userServiceProvider).removeSkill(skillId);
      return ref.read(userServiceProvider).getCurrentUserProfile();
    });
  }

  /// Refresh the user profile
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(userServiceProvider).getCurrentUserProfile());
  }
}

/// Provider for the current user's profile
final userProfileProvider = AsyncNotifierProvider<UserProfileNotifier, UserProfileResponse>(UserProfileNotifier.new);

/// Provider to fetch any user's profile by ID
final otherUserProfileProvider = FutureProvider.family<UserProfileResponse, int>((ref, userId) {
  return ref.watch(userServiceProvider).getProfile(userId);
});
