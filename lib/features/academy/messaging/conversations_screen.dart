import 'package:flutter/material.dart';
import '../../../ui/theme/app_theme.dart';
import 'chat_screen.dart';

/// Conversations Screen - List of all message threads
class ConversationsScreen extends StatelessWidget {
  const ConversationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data
    final conversations = [
      ConversationData(
        id: '1',
        name: 'Arjun Patel',
        sport: 'Cricket',
        lastMessage: 'Yes, absolutely! When can I come?',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        unreadCount: 2,
        isOnline: true,
      ),
      ConversationData(
        id: '2',
        name: 'Priya Sharma',
        sport: 'Athletics',
        lastMessage: 'Thank you for the opportunity!',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        unreadCount: 0,
        isOnline: false,
      ),
      ConversationData(
        id: '3',
        name: 'Rahul Kumar',
        sport: 'Football',
        lastMessage: 'I will send my documents soon.',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        unreadCount: 0,
        isOnline: true,
      ),
      ConversationData(
        id: '4',
        name: 'Sneha Reddy',
        sport: 'Badminton',
        lastMessage: 'Looking forward to the trial!',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        unreadCount: 1,
        isOnline: false,
      ),
    ];

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Messages',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppTheme.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: conversations.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                return _buildConversationCard(context, conversations[index]);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppTheme.primaryOrange.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.message_outlined,
              size: 48,
              color: AppTheme.primaryOrange,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Messages Yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start scouting to connect with athletes!',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationCard(BuildContext context, ConversationData conversation) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              recipientId: conversation.id,
              recipientName: conversation.name,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar with online indicator
            Stack(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: _getSportColor(conversation.sport).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getSportIcon(conversation.sport),
                    color: _getSportColor(conversation.sport),
                    size: 28,
                  ),
                ),
                if (conversation.isOnline)
                  Positioned(
                    right: 2,
                    bottom: 2,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: AppTheme.successColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          conversation.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: conversation.unreadCount > 0 
                                ? FontWeight.bold 
                                : FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ),
                      Text(
                        _formatTimestamp(conversation.timestamp),
                        style: TextStyle(
                          fontSize: 12,
                          color: conversation.unreadCount > 0 
                              ? AppTheme.primaryOrange 
                              : AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          conversation.lastMessage,
                          style: TextStyle(
                            fontSize: 14,
                            color: conversation.unreadCount > 0 
                                ? AppTheme.textPrimary 
                                : AppTheme.textSecondary,
                            fontWeight: conversation.unreadCount > 0 
                                ? FontWeight.w500 
                                : FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (conversation.unreadCount > 0)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryOrange,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${conversation.unreadCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${timestamp.day}/${timestamp.month}';
    }
  }

  Color _getSportColor(String sport) {
    switch (sport.toLowerCase()) {
      case 'cricket':
        return const Color(0xFF4CAF50);
      case 'football':
        return const Color(0xFF2196F3);
      case 'athletics':
        return const Color(0xFFFF9800);
      case 'badminton':
        return const Color(0xFF9C27B0);
      default:
        return AppTheme.primaryOrange;
    }
  }

  IconData _getSportIcon(String sport) {
    switch (sport.toLowerCase()) {
      case 'cricket':
        return Icons.sports_cricket;
      case 'football':
        return Icons.sports_soccer;
      case 'athletics':
        return Icons.directions_run;
      case 'badminton':
        return Icons.sports_tennis;
      default:
        return Icons.sports;
    }
  }
}

class ConversationData {
  final String id;
  final String name;
  final String sport;
  final String lastMessage;
  final DateTime timestamp;
  final int unreadCount;
  final bool isOnline;

  ConversationData({
    required this.id,
    required this.name,
    required this.sport,
    required this.lastMessage,
    required this.timestamp,
    required this.unreadCount,
    required this.isOnline,
  });
}
