import 'package:advsw/mock/mock_data.dart';
import 'package:advsw/models/rating_model.dart';

class RatingService {
  Future<RatingResponse> submitRating(CreateRatingRequest request) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final ratee = request.rateeId == MockData.currentUserId
        ? MockData.currentUser
        : MockData.otherUsers[request.rateeId];
    final rating = RatingResponse(
      id: DateTime.now().millisecondsSinceEpoch % 100000,
      raterId: MockData.currentUserId,
      raterName: '${MockData.currentUser.firstName} ${MockData.currentUser.lastName}',
      rateeId: request.rateeId,
      rateeName: ratee != null ? '${ratee.firstName} ${ratee.lastName}' : 'Unknown',
      projectId: request.projectId,
      score: request.score,
    );
    return rating;
  }

  Future<List<RatingResponse>> getRatingsForUser(int userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (userId == MockData.currentUserId) return List.from(MockData.ratingsForCurrentUser);
    return [];
  }
}
