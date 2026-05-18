import 'package:advsw/models/rating_model.dart';
import 'package:advsw/services/api_client.dart';

class RatingService {
  final ApiClient _apiClient;

  RatingService(this._apiClient);

  /// POST /api/ratings
  Future<RatingResponse> submitRating(CreateRatingRequest request) async {
    try {
      final response = await _apiClient.post('/ratings', data: request.toJson());
      return RatingResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// GET /api/ratings/user/{userId}
  Future<List<RatingResponse>> getRatingsForUser(int userId) async {
    try {
      final response = await _apiClient.get('/ratings/user/$userId');
      final List<dynamic> data = response.data;
      return data.map((json) => RatingResponse.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
