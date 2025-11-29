class User {
  final String id;
  final String phone;
  final String? email;
  final String name;
  final String role; // 'athlete', 'academy', 'sai_admin'
  final String? profileImageUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;

  // Academy-specific fields (nullable)
  final String? academyName;
  final String? academyType; // 'private', 'government', 'sai_verified'
  final List<String>? sports;
  final Location? location;
  final String? verificationStatus; // 'pending', 'verified', 'gold_verified'
  final List<VerificationDocument>? verificationDocuments;
  final List<Achievement>? achievements;
  final FeeStructure? feeStructure;
  final Infrastructure? infrastructure;

  // Athlete-specific fields (nullable)
  final int? age;
  final String? gender;
  final String? primarySport;
  final List<String>? secondarySports;

  User({
    required this.id,
    required this.phone,
    this.email,
    required this.name,
    required this.role,
    this.profileImageUrl,
    required this.createdAt,
    this.updatedAt,
    this.academyName,
    this.academyType,
    this.sports,
    this.location,
    this.verificationStatus,
    this.verificationDocuments,
    this.achievements,
    this.feeStructure,
    this.infrastructure,
    this.age,
    this.gender,
    this.primarySport,
    this.secondarySports,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? json['id'],
      phone: json['phone'],
      email: json['email'],
      name: json['name'],
      role: json['role'] ?? 'athlete',
      profileImageUrl: json['profileImageUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      academyName: json['academyName'],
      academyType: json['academyType'],
      sports: json['sports'] != null ? List<String>.from(json['sports']) : null,
      location: json['location'] != null ? Location.fromJson(json['location']) : null,
      verificationStatus: json['verificationStatus'],
      verificationDocuments: json['verificationDocuments'] != null
          ? (json['verificationDocuments'] as List)
              .map((doc) => VerificationDocument.fromJson(doc))
              .toList()
          : null,
      achievements: json['achievements'] != null
          ? (json['achievements'] as List)
              .map((ach) => Achievement.fromJson(ach))
              .toList()
          : null,
      feeStructure: json['feeStructure'] != null
          ? FeeStructure.fromJson(json['feeStructure'])
          : null,
      infrastructure: json['infrastructure'] != null
          ? Infrastructure.fromJson(json['infrastructure'])
          : null,
      age: json['age'],
      gender: json['gender'],
      primarySport: json['primarySport'],
      secondarySports: json['secondarySports'] != null
          ? List<String>.from(json['secondarySports'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'email': email,
      'name': name,
      'role': role,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'academyName': academyName,
      'academyType': academyType,
      'sports': sports,
      'location': location?.toJson(),
      'verificationStatus': verificationStatus,
      'verificationDocuments': verificationDocuments?.map((doc) => doc.toJson()).toList(),
      'achievements': achievements?.map((ach) => ach.toJson()).toList(),
      'feeStructure': feeStructure?.toJson(),
      'infrastructure': infrastructure?.toJson(),
      'age': age,
      'gender': gender,
      'primarySport': primarySport,
      'secondarySports': secondarySports,
    };
  }
}

class Location {
  final String address;
  final String city;
  final String state;
  final String pincode;
  final Coordinates? coordinates;

  Location({
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
    this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      address: json['address'],
      city: json['city'],
      state: json['state'],
      pincode: json['pincode'],
      coordinates: json['coordinates'] != null
          ? Coordinates.fromJson(json['coordinates'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'city': city,
      'state': state,
      'pincode': pincode,
      'coordinates': coordinates?.toJson(),
    };
  }
}

class Coordinates {
  final double lat;
  final double lng;

  Coordinates({required this.lat, required this.lng});

  factory Coordinates.fromJson(Map<String, dynamic> json) {
    return Coordinates(
      lat: json['lat'].toDouble(),
      lng: json['lng'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
    };
  }
}

class VerificationDocument {
  final String type; // 'license', 'certificate', 'sai_approval'
  final String url;
  final DateTime? verifiedAt;

  VerificationDocument({
    required this.type,
    required this.url,
    this.verifiedAt,
  });

  factory VerificationDocument.fromJson(Map<String, dynamic> json) {
    return VerificationDocument(
      type: json['type'],
      url: json['url'],
      verifiedAt: json['verifiedAt'] != null ? DateTime.parse(json['verifiedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'url': url,
      'verifiedAt': verifiedAt?.toIso8601String(),
    };
  }
}

class Achievement {
  final String title;
  final String description;
  final int? year;
  final String? imageUrl;

  Achievement({
    required this.title,
    required this.description,
    this.year,
    this.imageUrl,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      title: json['title'],
      description: json['description'],
      year: json['year'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'year': year,
      'imageUrl': imageUrl,
    };
  }
}

class FeeStructure {
  final double? monthly;
  final double? yearly;
  final bool scholarshipAvailable;

  FeeStructure({
    this.monthly,
    this.yearly,
    this.scholarshipAvailable = false,
  });

  factory FeeStructure.fromJson(Map<String, dynamic> json) {
    return FeeStructure(
      monthly: json['monthly']?.toDouble(),
      yearly: json['yearly']?.toDouble(),
      scholarshipAvailable: json['scholarshipAvailable'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'monthly': monthly,
      'yearly': yearly,
      'scholarshipAvailable': scholarshipAvailable,
    };
  }
}

class Infrastructure {
  final List<String> facilities;
  final int? capacity;
  final List<Coach> coaches;

  Infrastructure({
    required this.facilities,
    this.capacity,
    required this.coaches,
  });

  factory Infrastructure.fromJson(Map<String, dynamic> json) {
    return Infrastructure(
      facilities: List<String>.from(json['facilities'] ?? []),
      capacity: json['capacity'],
      coaches: (json['coaches'] ?? [])
          .map((coach) => Coach.fromJson(coach))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'facilities': facilities,
      'capacity': capacity,
      'coaches': coaches.map((coach) => coach.toJson()).toList(),
    };
  }
}

class Coach {
  final String name;
  final String specialization;
  final int experience; // years

  Coach({
    required this.name,
    required this.specialization,
    required this.experience,
  });

  factory Coach.fromJson(Map<String, dynamic> json) {
    return Coach(
      name: json['name'],
      specialization: json['specialization'],
      experience: json['experience'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'specialization': specialization,
      'experience': experience,
    };
  }
}


