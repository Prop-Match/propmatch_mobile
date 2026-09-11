import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:propmatch_mobile/core/theme/app_colors.dart';
import 'package:propmatch_mobile/core/constants/app_constants.dart';
import '../cubit/chat_cubit.dart';
import 'package:propmatch_mobile/features/matching_chat/domain/entities/message_entity.dart';

class ChatRoomScreen extends StatefulWidget {
  final MatchConnectionEntity connection;

  const ChatRoomScreen({
    super.key,
    required this.connection,
  });

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>().loadMessages(widget.connection.id);
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      context.read<ChatCubit>().sendMessage(
            connectionId: widget.connection.id,
            body: text,
          );
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final conn = widget.connection;
    final otherName = conn.ownerName ?? conn.tenantName ?? 'مستخدم بروب ماتش';

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(otherName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(
              conn.propertyTitle ?? 'محادثة العقار',
              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Privacy Banner / Phone Reveal Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: conn.isConnected
                ? AppColors.success.withValues(alpha: 0.1)
                : AppColors.warning.withValues(alpha: 0.1),
            child: Row(
              children: [
                Icon(
                  conn.isConnected ? LucideIcons.lock_open : LucideIcons.lock,
                  size: 18,
                  color: conn.isConnected ? AppColors.success : AppColors.warning,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    conn.isConnected
                        ? 'تم كشف بيانات الاتصال: ${conn.ownerPhone ?? "رقم الهاتف متاح"}'
                        : 'بيانات الاتصال مخفية لحماية الخصوصية حتى قبول الطرفين',
                    style: TextStyle(
                      color: conn.isConnected ? const Color(0xFF065F46) : const Color(0xFF92400E),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Messages Stream List
          Expanded(
            child: BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                if (state is ChatLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is MessagesLoaded) {
                  final messages = state.messages;
                  if (messages.isEmpty) {
                    return Center(
                      child: Text(
                        'ابدأ المحادثة الآن بخصوص ${conn.propertyTitle ?? "العقار"}',
                        style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.all(AppConstants.paddingMd),
                    itemCount: messages.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final isMe = msg.senderId != conn.ownerId; // Or check current user id
                      return _buildMessageBubble(msg, isMe);
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),

          // Input Bar
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'اكتب رسالتك...',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: _sendMessage,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(LucideIcons.send, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(MessageEntity msg, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(AppConstants.radiusMd),
            topRight: const Radius.circular(AppConstants.radiusMd),
            bottomLeft: Radius.circular(isMe ? AppConstants.radiusMd : 2),
            bottomRight: Radius.circular(isMe ? 2 : AppConstants.radiusMd),
          ),
          border: isMe ? null : Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              msg.body,
              style: TextStyle(
                color: isMe ? Colors.white : AppColors.textPrimary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${msg.createdAt.hour}:${msg.createdAt.minute.toString().padLeft(2, "0")}',
              style: TextStyle(
                color: isMe ? Colors.white60 : AppColors.textMuted,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
