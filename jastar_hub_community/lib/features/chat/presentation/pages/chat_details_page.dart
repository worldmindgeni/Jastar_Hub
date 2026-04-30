import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:timeago/timeago.dart' as timeago;
import 'package:jastar_hub_community/core/theme/app_colors.dart';
import 'package:jastar_hub_community/core/network/dio_client.dart';
import 'package:jastar_hub_community/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:jastar_hub_community/features/auth/data/models/user_model.dart';

class ChatDetailsPage extends StatefulWidget {
  final String partnerId;
  final String partnerName;
  final String partnerAvatarUrl;

  const ChatDetailsPage({
    super.key,
    required this.partnerId,
    required this.partnerName,
    required this.partnerAvatarUrl,
  });

  @override
  State<ChatDetailsPage> createState() => _ChatDetailsPageState();
}

class _ChatDetailsPageState extends State<ChatDetailsPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  late io.Socket _socket;
  late UserModel _currentUser;
  
  List<Map<String, dynamic>> _messages = [];
  bool _isLoading = true;
  bool _isPartnerTyping = false;
  bool _isPartnerOnline = false;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      _currentUser = authState.user;
    } else {
      // Fallback
      _currentUser = UserModel(id: 'unknown', email: 'unknown', name: 'Unknown');
    }
    
    _initSocket();
    _loadMessageHistory();
  }

  void _initSocket() {
    final baseUrl = ApiClient.client.options.baseUrl;
    _socket = io.io(
      baseUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    _socket.connect();

    _socket.onConnect((_) {
      // Register user connection
      _socket.emit('register', {'userId': _currentUser.id});
      // Mark read
      _socket.emit('markRead', {'userId': _currentUser.id, 'partnerId': widget.partnerId});
    });

    _socket.on('messageReceived', (data) {
      if (data['senderId'] == widget.partnerId) {
        setState(() {
          _messages.insert(0, data);
        });
        _socket.emit('markRead', {'userId': _currentUser.id, 'partnerId': widget.partnerId});
      }
    });

    _socket.on('messageSent', (data) {
      if (data['receiverId'] == widget.partnerId) {
        setState(() {
          // If we had local dummy message, we could replace it. For now just add to list.
          _messages.insert(0, data);
        });
      }
    });

    _socket.on('userTyping', (data) {
      if (data['userId'] == widget.partnerId) {
        setState(() {
          _isPartnerTyping = data['isTyping'] ?? false;
        });
      }
    });

    _socket.on('userOnline', (data) {
      if (data['userId'] == widget.partnerId) {
        setState(() => _isPartnerOnline = true);
      }
    });

    _socket.on('userOffline', (data) {
      if (data['userId'] == widget.partnerId) {
        setState(() {
          _isPartnerOnline = false;
          _isPartnerTyping = false;
        });
      }
    });
  }

  Future<void> _loadMessageHistory() async {
    try {
      final response = await ApiClient.client.get('/chat/messages/${widget.partnerId}');
      final data = response.data as List<dynamic>;
      if (mounted) {
        setState(() {
          _messages = data.map((e) => e as Map<String, dynamic>).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to load history')));
      }
    }
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _socket.emit('sendMessage', {
      'senderId': _currentUser.id,
      'receiverId': widget.partnerId,
      'content': text,
    });

    _messageController.clear();
    _socket.emit('typing', {
      'senderId': _currentUser.id,
      'receiverId': widget.partnerId,
      'isTyping': false,
    });
  }

  void _onTyping(String text) {
    _socket.emit('typing', {
      'senderId': _currentUser.id,
      'receiverId': widget.partnerId,
      'isTyping': text.isNotEmpty,
    });
  }

  @override
  void dispose() {
    _socket.disconnect();
    _socket.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: widget.partnerAvatarUrl.isNotEmpty 
                  ? CachedNetworkImageProvider(widget.partnerAvatarUrl)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.partnerName, style: const TextStyle(fontSize: 16)),
                  Text(
                    _isPartnerTyping 
                        ? 'Печатает...' 
                        : (_isPartnerOnline ? 'В сети' : 'Был(а) недавно'),
                    style: TextStyle(
                      fontSize: 12, 
                      color: _isPartnerOnline ? AppColors.success : (isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: isDark ? AppColors.cardDarkElevated : AppColors.surfaceLight,
        elevation: 1,
        iconTheme: IconThemeData(color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    reverse: true, // Show bottom to top
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      final isMe = msg['senderId'] == _currentUser.id;
                      return _buildMessageBubble(msg, isMe, isDark);
                    },
                  ),
          ),
          _buildMessageInput(isDark),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> msg, bool isMe, bool isDark) {
    final dateStr = msg['createdAt'];
    final timeStr = dateStr != null ? timeago.format(DateTime.parse(dateStr), locale: 'en_short') : 'Now';
    
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primary : (isDark ? AppColors.cardDarkElevated : AppColors.surfaceLight),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 16),
          ),
          border: isMe ? null : Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              msg['content'] as String? ?? '',
              style: TextStyle(
                color: isMe ? Colors.white : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              timeStr,
              style: TextStyle(
                fontSize: 10,
                color: isMe ? Colors.white70 : (isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16).copyWith(bottom: MediaQuery.of(context).padding.bottom + 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDarkElevated : AppColors.surfaceLight,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, -4),
            blurRadius: 16,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              onChanged: _onTyping,
              decoration: InputDecoration(
                hintText: 'Сообщение...',
                hintStyle: TextStyle(color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
