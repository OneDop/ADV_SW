import 'dart:async';
import 'package:riverpod/riverpod.dart';
import 'package:advsw/models/rating_model.dart';
import 'package:advsw/services/rating_service.dart';

/// Provider for RatingService
final ratingServiceProvider = Provider<RatingService>((ref) {
  return RatingService();
});

/// AsyncNotifier to manage ratings for a specific user
class UserRatingsNotifier extends AsyncNotifier<List<RatingResponse>> {
  final int userId;

  UserRatingsNotifier(this.userId);

  @override
  FutureOr<List<RatingResponse>> build() async {
    return ref.watch(ratingServiceProvider).getRatingsForUser(userId);
  }

  /// Submit a rating and update the local state
  Future<void> submitRating(CreateRatingRequest request) async {
    state = await AsyncValue.guard(() async {
      final newRating = await ref.read(ratingServiceProvider).submitRating(request);
      final currentRatings = state.value ?? [];
      // If the rating is for the user this notifier is tracking, add it to the list
      if (request.rateeId == userId) {
        return [...currentRatings, newRating];
      }
      return currentRatings;
    });
  }

  /// Refresh the ratings for this user from the server
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(ratingServiceProvider).getRatingsForUser(userId));
  }
}

/// Provider for ratings of a specific user (indexed by userId)
final userRatingsProvider = AsyncNotifierProvider.family<UserRatingsNotifier, List<RatingResponse>, int>(
  (userId) => UserRatingsNotifier(userId),
);
