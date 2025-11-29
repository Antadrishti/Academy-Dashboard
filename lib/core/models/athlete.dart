import 'user.dart';
import 'test_result.dart';

class Athlete {
  final String id;
  final String userId;
  final String name;
  final int? age;
  final String? gender;
  final String? primarySport;
  final List<String>? secondarySports;
  final String? profileImageUrl;
  final Location? location;
  final Map<String, double> performanceScores; // { testId: score }
  final List<TestResult> testResults;
  final List<Video> videos;
  final List<Achievement> achievements;
  final List<InjuryRecord> injuryRecords;
  final bool verifiedBadge;
  final DateTime createdAt;

  Athlete({
    required this.id,
    required this.userId,
    required this.name,
    this.age,
    this.gender,
    this.primarySport,
    this.secondarySports,
    this.profileImageUrl,
    this.location,
    required this.performanceScores,
    required this.testResults,
    required this.videos,
    required this.achievements,
    required this.injuryRecords,
    this.verifiedBadge = false,
    required this.createdAt,
  });

  factory Athlete.fromJson(Map<String, dynamic> json) {
    return Athlete(
      id: json['_id'] ?? json['id'],
      userId: json['userId'],
      name: json['name'],
      age: json['age'],
      gender: json['gender'],
      primarySport: json['primarySport'],
      secondarySports: json['secondarySports'] != null
          ? List<String>.from(json['secondarySports'])
          : null,
      profileImageUrl: json['profileImageUrl'],
      location: json['location'] != null ? Location.fromJson(json['location']) : null,
      performanceScores: json['performanceScores'] != null
          ? Map<String, double>.from(json['performanceScores'])
          : {},
      testResults: json['testResults'] != null
          ? (json['testResults'] as List)
              .map((result) => TestResult.fromJson(result))
              .toList()
          : [],
      videos: json['videos'] != null
          ? (json['videos'] as List).map((v) => Video.fromJson(v)).toList()
          : [],
      achievements: json['achievements'] != null
          ? (json['achievements'] as List)
              .map((ach) => Achievement.fromJson(ach))
              .toList()
          : [],
      injuryRecords: json['injuryRecords'] != null
          ? (json['injuryRecords'] as List)
              .map((inj) => InjuryRecord.fromJson(inj))
              .toList()
          : [],
      verifiedBadge: json['verifiedBadge'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'age': age,
      'gender': gender,
      'primarySport': primarySport,
      'secondarySports': secondarySports,
      'profileImageUrl': profileImageUrl,
      'location': location?.toJson(),
      'performanceScores': performanceScores,
      'testResults': testResults.map((r) => r.toJson()).toList(),
      'videos': videos.map((v) => v.toJson()).toList(),
      'achievements': achievements.map((a) => a.toJson()).toList(),
      'injuryRecords': injuryRecords.map((i) => i.toJson()).toList(),
      'verifiedBadge': verifiedBadge,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class Video {
  final String id;
  final String url;
  final String? thumbnailUrl;
  final String testType;
  final DateTime uploadedAt;
  final bool isVerified;

  Video({
    required this.id,
    required this.url,
    this.thumbnailUrl,
    required this.testType,
    required this.uploadedAt,
    this.isVerified = false,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['_id'] ?? json['id'],
      url: json['url'],
      thumbnailUrl: json['thumbnailUrl'],
      testType: json['testType'],
      uploadedAt: DateTime.parse(json['uploadedAt']),
      isVerified: json['isVerified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'thumbnailUrl': thumbnailUrl,
      'testType': testType,
      'uploadedAt': uploadedAt.toIso8601String(),
      'isVerified': isVerified,
    };
  }
}

class InjuryRecord {
  final String type;
  final DateTime date;
  final String recoveryStatus; // 'recovered', 'recovering', 'chronic'

  InjuryRecord({
    required this.type,
    required this.date,
    required this.recoveryStatus,
  });

  factory InjuryRecord.fromJson(Map<String, dynamic> json) {
    return InjuryRecord(
      type: json['type'],
      date: DateTime.parse(json['date']),
      recoveryStatus: json['recoveryStatus'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'date': date.toIso8601String(),
      'recoveryStatus': recoveryStatus,
    };
  }
}

