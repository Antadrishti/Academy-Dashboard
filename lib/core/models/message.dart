class Message {
  final String id;
  final String from;
  final String to;
  final String content;
  final MessageType type;
  final bool read;
  final DateTime createdAt;
  final Map<String, dynamic>? metadata; // For trial invites, offers, etc.

  Message({
    required this.id,
    required this.from,
    required this.to,
    required this.content,
    required this.type,
    this.read = false,
    required this.createdAt,
    this.metadata,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['_id'] ?? json['id'],
      from: json['from'],
      to: json['to'],
      content: json['content'],
      type: MessageType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => MessageType.message,
      ),
      read: json['read'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'from': from,
      'to': to,
      'content': content,
      'type': type.toString().split('.').last,
      'read': read,
      'createdAt': createdAt.toIso8601String(),
      'metadata': metadata,
    };
  }
}

enum MessageType {
  message,
  trialInvite,
  scholarshipOffer,
  academyBrochure,
}

class Conversation {
  final String id;
  final String otherUserId;
  final String otherUserName;
  final String? otherUserImageUrl;
  final Message? lastMessage;
  final int unreadCount;
  final DateTime updatedAt;

  Conversation({
    required this.id,
    required this.otherUserId,
    required this.otherUserName,
    this.otherUserImageUrl,
    this.lastMessage,
    this.unreadCount = 0,
    required this.updatedAt,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['_id'] ?? json['id'],
      otherUserId: json['otherUserId'],
      otherUserName: json['otherUserName'],
      otherUserImageUrl: json['otherUserImageUrl'],
      lastMessage: json['lastMessage'] != null
          ? Message.fromJson(json['lastMessage'])
          : null,
      unreadCount: json['unreadCount'] ?? 0,
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'otherUserId': otherUserId,
      'otherUserName': otherUserName,
      'otherUserImageUrl': otherUserImageUrl,
      'lastMessage': lastMessage?.toJson(),
      'unreadCount': unreadCount,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

