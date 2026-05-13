class CreateSkillRequest {
  final String name;

  CreateSkillRequest({
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}

class SkillResponse {
  final int id;
  final String name;

  SkillResponse({
    required this.id,
    required this.name,
  });

  factory SkillResponse.fromJson(Map<String, dynamic> json) {
    return SkillResponse(
      id: json['id'],
      name: json['name'],
    );
  }
}
