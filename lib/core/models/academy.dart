import 'user.dart';

class Academy {
  final String id;
  final String userId;
  final String name;
  final String academyType;
  final List<String> sports;
  final Location? location;
  final String verificationStatus;
  final List<Achievement> achievements;
  final FeeStructure? feeStructure;
  final Infrastructure? infrastructure;
  final DateTime createdAt;

  Academy({
    required this.id,
    required this.userId,
    required this.name,
    required this.academyType,
    required this.sports,
    this.location,
    required this.verificationStatus,
    required this.achievements,
    this.feeStructure,
    this.infrastructure,
    required this.createdAt,
  });

  factory Academy.fromJson(Map<String, dynamic> json) {
    return Academy(
      id: json['_id'] ?? json['id'],
      userId: json['userId'],
      name: json['name'],
      academyType: json['academyType'],
      sports: List<String>.from(json['sports'] ?? []),
      location: json['location'] != null ? Location.fromJson(json['location']) : null,
      verificationStatus: json['verificationStatus'] ?? 'pending',
      achievements: json['achievements'] != null
          ? (json['achievements'] as List)
              .map((ach) => Achievement.fromJson(ach))
              .toList()
          : [],
      feeStructure: json['feeStructure'] != null
          ? FeeStructure.fromJson(json['feeStructure'])
          : null,
      infrastructure: json['infrastructure'] != null
          ? Infrastructure.fromJson(json['infrastructure'])
          : null,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'academyType': academyType,
      'sports': sports,
      'location': location?.toJson(),
      'verificationStatus': verificationStatus,
      'achievements': achievements.map((a) => a.toJson()).toList(),
      'feeStructure': feeStructure?.toJson(),
      'infrastructure': infrastructure?.toJson(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

