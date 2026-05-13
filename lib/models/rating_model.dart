class CreateRatingRequest {
  final int rateeId;
  final int projectId;
  final int score;

  CreateRatingRequest({
    required this.rateeId,
    required this.projectId,
    required this.score,
  });

  Map<String, dynamic> toJson() {
    return {
      'rateeId': rateeId,
      'projectId': projectId,
      'score': score,
    };
  }
}

class RatingResponse {
  final int id;
  final int raterId;
  final String raterName;
  final int rateeId;
  final String rateeName;
  final int projectId;
  final int score;

  RatingResponse({
    required this.id,
    required this.raterId,
    required this.raterName,
    required this.rateeId,
    required this.rateeName,
    required this.projectId,
    required this.score,
  });

  factory RatingResponse.fromJson(Map<String, dynamic> json) {
    return RatingResponse(
      id: json['id'],
      raterId: json['raterId'],
      raterName: json['raterName'],
      rateeId: json['rateeId'],
      rateeName: json['rateeName'],
      projectId: json['projectId'],
      score: json['score'],
    );
  }
}
