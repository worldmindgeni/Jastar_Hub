import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:jastar_hub_community/core/theme/app_colors.dart';
import 'package:jastar_hub_community/core/l10n/app_localizations.dart';
import 'package:jastar_hub_community/core/network/dio_client.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Map<String, dynamic>> _conversations = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await ApiClient.client.get('/chat/conversations');
      final List<dynamic> data = response.data;
      setState(() {
        _conversations = data.map((e) => e as Map<String, dynamic>).toList();
        _isLoading = false;
      });
    } on DioException catch (e) {
      setState(() {
        _error = e.response?.data?['message']?.toString() ?? 'Failed to load conversations';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load conversations';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          context.tr('nav_chat'),
          style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 24),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search_rounded,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _buildBody(isDark),
    );
  }

  Widget _buildBody(bool isDark) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      // Show empty state with placeholder conversations when backend is unreachable
      return _buildPlaceholderList(isDark);
    }

    if (_conversations.isEmpty) {
      return _buildPlaceholderList(isDark);
    }

    return RefreshIndicator(
      onRefresh: _loadConversations,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _conversations.length,
        separatorBuilder: (context, index) => Divider(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          indent: 80,
          endIndent: 20,
        ),
        itemBuilder: (context, index) {
          final conv = _conversations[index];
          final partner = conv['partner'] as Map<String, dynamic>?;
          final lastMessage = conv['lastMessage'] as Map<String, dynamic>?;
          final unreadCount = conv['unreadCount'] as int? ?? 0;

          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
            leading: Stack(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundImage: partner?['avatarUrl'] != null
                      ? CachedNetworkImageProvider(partner!['avatarUrl'])
                      : null,
                  child: partner?['avatarUrl'] == null
                      ? Text(
                          (partner?['name'] as String? ?? 'U')[0],
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                        )
                      : null,
                ),
              ],
            ),
            title: Text(
              partner?['name'] ?? 'Unknown',
              style: TextStyle(
                fontWeight: unreadCount > 0 ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                lastMessage?['content'] ?? '',
                style: TextStyle(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  fontWeight: unreadCount > 0 ? FontWeight.w600 : FontWeight.w400,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (lastMessage?['createdAt'] != null)
                  Text(
                    timeago.format(
                      DateTime.parse(lastMessage!['createdAt']),
                      locale: 'en_short',
                    ),
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                    ),
                  ),
                const SizedBox(height: 6),
                if (unreadCount > 0)
                  Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '$unreadCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            onTap: () {
              context.push(
                '/chat/${partner?['id']}',
                extra: {
                  'partnerName': partner?['name'] ?? 'Unknown',
                  'partnerAvatarUrl': partner?['avatarUrl'] ?? '',
                },
              );
            },
          );
        },
      ),
    );
  }

  /// Placeholder list shown when backend has no conversations yet
  Widget _buildPlaceholderList(bool isDark) {
    final placeholders = [
      {'name': 'Flutter Workshop Chat', 'msg': 'Да, встречаемся у входа!', 'isGroup': true, 'img': 'https://picsum.photos/seed/event0/100/100'},
      {'name': 'Амир Касымов', 'msg': 'Где пройдет следующий хакатон?', 'isGroup': false, 'img': 'https://i.pravatar.cc/150?img=11'},
      {'name': 'Tech Meetup Group', 'msg': 'Спикеры подтверждены ✅', 'isGroup': true, 'img': 'https://picsum.photos/seed/event2/100/100'},
      {'name': 'Дана Нурланова', 'msg': 'Отличные фото с события!', 'isGroup': false, 'img': 'https://i.pravatar.cc/150?img=5'},
      {'name': 'Тимур Ахметов', 'msg': 'Готов к марафону? 🏃', 'isGroup': false, 'img': 'https://i.pravatar.cc/150?img=12'},
    ];

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: placeholders.length,
      separatorBuilder: (context, index) => Divider(
        color: isDark ? AppColors.borderDark : AppColors.borderLight,
        indent: 80,
        endIndent: 20,
      ),
      itemBuilder: (context, index) {
        final item = placeholders[index];
        final isGroup = item['isGroup'] as bool;

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          leading: Stack(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundImage: CachedNetworkImageProvider(item['img'] as String),
              ),
              if (!isGroup)
                Positioned(
                  right: 0, bottom: 0,
                  child: Container(
                    width: 14, height: 14,
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
                        width: 2,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          title: Text(
            item['name'] as String,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              item['msg'] as String,
              style: TextStyle(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '1${index + 2}:45',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                ),
              ),
              const SizedBox(height: 6),
              if (index == 0)
                Container(
                  width: 20, height: 20,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text('2', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                  ),
                ),
            ],
          ),
          onTap: () {
            context.push(
              '/chat/placeholder-$index',
              extra: {
                'partnerName': item['name'] as String,
                'partnerAvatarUrl': item['img'] as String,
              },
            );
          },
        );
      },
    );
  }
}
