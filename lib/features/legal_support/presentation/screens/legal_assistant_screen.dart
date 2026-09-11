import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:propmatch_mobile/core/constants/app_constants.dart';
import 'package:propmatch_mobile/core/di/injection_container.dart';
import 'package:propmatch_mobile/core/theme/app_colors.dart';
import 'package:propmatch_mobile/features/legal_support/domain/entities/legal_message_entity.dart';
import 'package:propmatch_mobile/features/legal_support/domain/repositories/legal_support_repository.dart';
import 'package:propmatch_mobile/features/legal_support/presentation/cubit/legal_support_cubit.dart';

class LegalAssistantScreen extends StatelessWidget {
  const LegalAssistantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LegalSupportCubit(repository: sl<LegalSupportRepository>()),
      child: const _LegalAssistantView(),
    );
  }
}

class _LegalAssistantView extends StatefulWidget {
  const _LegalAssistantView();

  @override
  State<_LegalAssistantView> createState() => _LegalAssistantViewState();
}

class _LegalAssistantViewState extends State<_LegalAssistantView> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();

  static const List<String> _quickChips = [
    'ما هي مدة الإخطار قبل إنهاء العقد؟',
    'هل يحق للمالك زيادة الإيجار سنويًا؟',
    'ما حقوقي كمستأجر عند تأخر الصيانة؟',
  ];

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _send(String text) {
    if (text.trim().isEmpty) return;
    context.read<LegalSupportCubit>().sendMessage(text);
    _textController.clear();
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryTint,
                borderRadius: BorderRadius.circular(AppConstants.radiusSm),
              ),
              child: const Icon(LucideIcons.scale, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'المساعد القانوني',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'أسئلة الإيجار والقانون العقاري في مصر',
                  style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Disclaimer bar matching web
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: AppColors.primaryTint.withValues(alpha: 0.5),
              child: const Row(
                children: [
                  Icon(LucideIcons.info, color: AppColors.primary, size: 16),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'الإجابات استرشادية مبنية على القانون المصري ولا تغني عن استشارة محامٍ متخصص.',
                      style: TextStyle(fontSize: 11, color: AppColors.primaryDark),
                    ),
                  ),
                ],
              ),
            ),

            // Message Area
            Expanded(
              child: BlocConsumer<LegalSupportCubit, LegalSupportState>(
                listener: (context, state) {
                  _scrollToBottom();
                },
                builder: (context, state) {
                  List<LegalMessageEntity> messages = [];
                  bool isSending = false;

                  if (state is LegalSupportInitial) {
                    messages = state.messages;
                  } else if (state is LegalSupportSending) {
                    messages = state.messages;
                    isSending = true;
                  } else if (state is LegalSupportLoaded) {
                    messages = state.messages;
                  } else if (state is LegalSupportError) {
                    messages = state.messages;
                  }

                  if (messages.isEmpty) {
                    return _buildEmptyState();
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(AppConstants.paddingMd),
                    itemCount: messages.length + (isSending ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == messages.length && isSending) {
                        return _buildTypingIndicator();
                      }
                      return _buildMessageBubble(messages[index]);
                    },
                  );
                },
              ),
            ),

            // Input Bar
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingMd),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                border: const Border(top: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: 'اكتب سؤالك القانوني هنا...',
                        filled: true,
                        fillColor: AppColors.background,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                        ),
                      ),
                      onSubmitted: _send,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    icon: const Icon(LucideIcons.send_horizontal, size: 18),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(12),
                    ),
                    onPressed: () => _send(_textController.text),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingLg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryTint,
                shape: BoxShape.circle,
              ),
              child: const Icon(LucideIcons.message_square, size: 48, color: AppColors.primary),
            ),
            const SizedBox(height: AppConstants.paddingLg),
            const Text(
              'اسأل عن أي شيء يخص الإيجار',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              'أمثلة لأسئلة شائعة يمكنك البدء بالضغط عليها مباشرة:',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
            const SizedBox(height: AppConstants.paddingLg),
            ...List.generate(_quickChips.length, (index) {
              final chipText = _quickChips[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: InkWell(
                  onTap: () => _send(chipText),
                  borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        const Icon(LucideIcons.sparkles, size: 16, color: AppColors.primary),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            chipText,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Icon(LucideIcons.arrow_left, size: 14, color: AppColors.textMuted),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(LegalMessageEntity message) {
    final isUser = message.role == LegalMessageRole.user;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
        ),
        decoration: BoxDecoration(
          color: isUser
              ? AppColors.primary
              : (message.declined
                  ? AppColors.pending.withValues(alpha: 0.1)
                  : AppColors.background),
          borderRadius: BorderRadius.circular(AppConstants.radiusMd).copyWith(
            bottomRight: isUser ? Radius.zero : null,
            bottomLeft: !isUser ? Radius.zero : null,
          ),
          border: isUser ? null : Border.all(color: AppColors.border),
        ),
        child: isUser
            ? Text(
                message.content,
                style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.4),
              )
            : MarkdownBody(
                data: message.content,
                styleSheet: MarkdownStyleSheet(
                  p: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    height: 1.5,
                  ),
                  strong: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  listBullet: const TextStyle(color: AppColors.primary),
                ),
              ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
            ),
            const SizedBox(width: 8),
            const Text(
              'جارٍ صياغة الاستشارة القانونية...',
              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
