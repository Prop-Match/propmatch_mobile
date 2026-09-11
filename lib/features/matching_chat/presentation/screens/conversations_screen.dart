import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:propmatch_mobile/core/theme/app_colors.dart';
import 'package:propmatch_mobile/core/constants/app_constants.dart';
import 'package:propmatch_mobile/core/router/app_routes.dart';
import 'package:propmatch_mobile/core/widgets/match_score_badge.dart';
import '../cubit/chat_cubit.dart';
import 'package:propmatch_mobile/features/matching_chat/domain/entities/match_connection_entity.dart';

class ConversationsScreen extends StatefulWidget {
  const ConversationsScreen({super.key});

  @override
  State<ConversationsScreen> createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>().loadConnections();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المحادثات والمطابقات'),
      ),
      body: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          if (state is ChatLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChatError) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingXl,
                  vertical: AppConstants.paddingLg,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppConstants.paddingMd),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(LucideIcons.circle_alert, size: 48, color: AppColors.error),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'تعذر تحميل المحادثات',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMd),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => context.read<ChatCubit>().loadConnections(),
                          icon: const Icon(LucideIcons.rotate_cw, size: 18),
                          label: const Text('إعادة المحاولة'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is ConnectionsLoaded) {
            final connections = state.connections;
            if (connections.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingLg),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(LucideIcons.message_square, size: 48, color: AppColors.textMuted),
                      const SizedBox(height: 12),
                      const Text(
                        'لا توجد محادثات نشطة حالياً',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'تبدأ المحادثات تلقائياً عند قبول عروض الإيجار أو المطابقات المباشرة',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async => context.read<ChatCubit>().loadConnections(),
              child: ListView.separated(
                padding: const EdgeInsets.all(AppConstants.paddingMd),
                itemCount: connections.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final conn = connections[index];
                  return _buildConnectionTile(conn);
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildConnectionTile(MatchConnectionEntity conn) {
    final title = conn.propertyTitle ?? 'مطابقة عقارية';
    final participant = conn.ownerName ?? conn.tenantName ?? 'مستخدم بروب ماتش';

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        side: const BorderSide(color: AppColors.border),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onTap: () {
          context.push(AppRoutes.chatRoom(conn.id), extra: conn);
        },
        leading: CircleAvatar(
          backgroundColor: AppColors.accent.withValues(alpha: 0.1),
          radius: 24,
          child: const Icon(LucideIcons.user, color: AppColors.accent, size: 22),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                participant,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
            MatchScoreBadge(score: conn.matchScore, showLabel: false),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Text(
              title,
              style: const TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 2),
            Text(
              conn.lastMessage?.body ?? (conn.isConnected ? 'تم الاتصال • يمكنك التحدث الآن' : 'بانتظار قبول الطرفين'),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: conn.isConnected ? AppColors.textSecondary : AppColors.textMuted,
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: const Icon(LucideIcons.chevron_left, size: 18, color: AppColors.textMuted),
      ),
    );
  }
}
