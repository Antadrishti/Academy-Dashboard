class Achievement {
  final String id;
  final String title;
  final String description;
  final int? year;
  final String? imageUrl;
  final DateTime? createdAt;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    this.year,
    this.imageUrl,
    this.createdAt,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['_id'] ?? json['id'],
      title: json['title'],
      description: json['description'],
      year: json['year'],
      imageUrl: json['imageUrl'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'year': year,
      'imageUrl': imageUrl,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}


