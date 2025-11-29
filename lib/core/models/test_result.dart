class TestResult {
  final String id;
  final String userId;
  final String testType;
  final double score;
  final String? videoUrl;
  final DateTime completedAt;
  final bool isVerified;
  final String? verifiedBy; // Academy ID if verified
  final Map<String, dynamic>? metadata;

  TestResult({
    required this.id,
    required this.userId,
    required this.testType,
    required this.score,
    this.videoUrl,
    required this.completedAt,
    this.isVerified = false,
    this.verifiedBy,
    this.metadata,
  });

  factory TestResult.fromJson(Map<String, dynamic> json) {
    return TestResult(
      id: json['_id'] ?? json['id'],
      userId: json['userId'],
      testType: json['testType'],
      score: json['score'].toDouble(),
      videoUrl: json['videoUrl'],
      completedAt: DateTime.parse(json['completedAt']),
      isVerified: json['isVerified'] ?? false,
      verifiedBy: json['verifiedBy'],
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'testType': testType,
      'score': score,
      'videoUrl': videoUrl,
      'completedAt': completedAt.toIso8601String(),
      'isVerified': isVerified,
      'verifiedBy': verifiedBy,
      'metadata': metadata,
    };
  }
}

class TestType {
  final String id;
  final String name;
  final String description;
  final String category; // 'speed', 'strength', 'endurance', 'flexibility'
  final String unit; // 'seconds', 'meters', 'count', etc.

  TestType({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.unit,
  });

  factory TestType.fromJson(Map<String, dynamic> json) {
    return TestType(
      id: json['_id'] ?? json['id'],
      name: json['name'],
      description: json['description'],
      category: json['category'],
      unit: json['unit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'unit': unit,
    };
  }
}

