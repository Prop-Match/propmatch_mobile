import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:propmatch_mobile/core/constants/app_constants.dart';
import 'package:propmatch_mobile/core/di/injection_container.dart';
import 'package:propmatch_mobile/core/theme/app_colors.dart';
import 'package:propmatch_mobile/features/legal_support/domain/entities/unified_chat_entity.dart';
import 'package:propmatch_mobile/features/legal_support/domain/repositories/unified_assistant_repository.dart';
import 'package:propmatch_mobile/features/legal_support/presentation/cubit/unified_assistant_cubit.dart';

class UnifiedAssistantScreen extends StatelessWidget {
  const UnifiedAssistantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          UnifiedAssistantCubit(repository: sl<UnifiedAssistantRepository>())
            ..loadTickets(),
      child: const _UnifiedAssistantView(),
    );
  }
}

class _UnifiedAssistantView extends StatefulWidget {
  const _UnifiedAssistantView();
  @override
  State<_UnifiedAssistantView> createState() => _UnifiedAssistantViewState();
}

class _UnifiedAssistantViewState extends State<_UnifiedAssistantView> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final _ticketReplyController = TextEditingController();
  bool _ticketsAccordionOpen = true;

  static const List<String> _legalPrompts = [
    'ما هي الزيادة السنوية القانونية للإيجار بموجب القانون رقم 4؟',
    'ما هي مدة الإخطار القانونية المتفق عليها قبل فسخ العقد؟',
    'ما هي التزامات المؤجر والمستأجر بالنسبة للصيانة والتأمين؟',
    'كيف يتم توثيق شروط فسخ العقد وإخلائه قانونياً؟',
  ];

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _ticketReplyController.dispose();
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

  void _send() {
    final text = _textController.text;
    if (text.trim().isEmpty) return;
    context.read<UnifiedAssistantCubit>().sendMessage(text);
    _textController.clear();
    _scrollToBottom();
  }

  void _sendPrompt(String prompt) {
    context.read<UnifiedAssistantCubit>().sendMessage(prompt);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UnifiedAssistantCubit, UnifiedAssistantState>(
      listener: (context, state) => _scrollToBottom(),
      builder: (context, state) {
        final cubit = context.read<UnifiedAssistantCubit>();
        final isLegal = state.mode == ChatMode.legal;
        final isSupport = state.mode == ChatMode.support;

        // Ticket thread mode
        if (state.selectedTicketId != null) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(LucideIcons.arrow_right),
                onPressed: () => cubit.setSelectedTicket(null),
              ),
              title: const Text(
                'تفاصيل التذكرة',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            body: _TicketThreadView(
              ticketId: state.selectedTicketId!,
              onBack: () => cubit.setSelectedTicket(null),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            title: Row(
              children: [
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: AppColors.primaryTint,
                    borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                  ),
                  child: Icon(
                    isLegal ? LucideIcons.scale : LucideIcons.headset,
                    color: AppColors.primary,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            LucideIcons.sparkles,
                            size: 12,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'PropMatch AI',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            ' / ',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textMuted,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              isLegal
                                  ? 'المستشار القانوني العقاري'
                                  : 'خدمة العملاء والدعم الفني',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      if (isLegal)
                        const Text(
                          'استرشادي طبقاً للقانون رقم 4 لسنة 1996',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.primary,
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(LucideIcons.plus, size: 18),
                  tooltip: 'محادثة جديدة',
                  onPressed: () => cubit.newChat(),
                ),
              ],
            ),
          ),
          drawer: _buildDrawer(context, state),
          body: SafeArea(
            child: Column(
              children: [
                // Disclaimer only for legal
                if (isLegal)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    color: AppColors.primaryTint.withValues(alpha: 0.5),
                    child: const Row(
                      children: [
                        Icon(
                          LucideIcons.info,
                          color: AppColors.primary,
                          size: 14,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'الإجابات استرشادية مبنية على القانون المصري ولا تغني عن استشارة محامٍ متخصص.',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Frustration banner
                if (isSupport && state.frustrated)
                  Container(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(
                        AppConstants.radiusMd,
                      ),
                      border: Border.all(
                        color: AppColors.error.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          LucideIcons.triangle_alert,
                          color: AppColors.error,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'يبدو أنك تواجه مشكلة هامة! يمكنك التحويل مباشرة لموظف دعم فني.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.error,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.error,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                          ),
                          onPressed: state.hasOpenTicket || state.ticketsLoading
                              ? null
                              : () async {
                                  try {
                                    await cubit.escalateToHuman();
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'تم إنشاء التذكرة وتحويلك لموظف الدعم الفني',
                                              ),
                                            ),
                                          );
                                    }
                                  } catch (_) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'تعذر إنشاء تذكرة الدعم. حاول مرة أخرى.',
                                              ),
                                            ),
                                          );
                                    }
                                  }
                                },
                          child: Text(
                            state.hasOpenTicket
                                ? 'لديك تذكرة مفتوحة'
                                : 'تحدث مع موظف',
                            style: const TextStyle(fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Messages
                Expanded(
                  child: state.activeMessages.isEmpty
                      ? _buildEmptyState(isLegal)
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(AppConstants.paddingMd),
                          itemCount:
                              state.activeMessages.length +
                              (state.isTyping ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == state.activeMessages.length &&
                                state.isTyping) {
                              return _buildTypingIndicator(isLegal);
                            }
                            return _buildBubble(state.activeMessages[index]);
                          },
                        ),
                ),

                // Support escalation button above input (like web)
                if (isSupport)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: state.hasOpenTicket || state.ticketsLoading
                            ? null
                            : () async {
                                try {
                                  await cubit.escalateToHuman();
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'تم إنشاء التذكرة وتحويلك لموظف الدعم الفني',
                                        ),
                                      ),
                                    );
                                  }
                                } catch (_) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'تعذر إنشاء تذكرة الدعم. حاول مرة أخرى.',
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
                        icon: const Icon(LucideIcons.user_check, size: 14),
                        label: Text(
                          state.hasOpenTicket
                              ? 'لديك تذكرة دعم مفتوحة'
                              : 'تحويل لموظف الدعم الفني',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                // Input bar with embedded mode switcher
                Container(
                  padding: const EdgeInsets.all(AppConstants.paddingMd),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    border: const Border(
                      top: BorderSide(color: AppColors.border),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(
                              AppConstants.radiusFull,
                            ),
                            border: Border.all(color: AppColors.border),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 4,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _textController,
                                  decoration: InputDecoration(
                                    hintText: isLegal
                                        ? 'اكتب سؤالك القانوني هنا…'
                                        : 'اكتب استفسارك للمساعد الذكي…',
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    isDense: true,
                                  ),
                                  onSubmitted: (_) => _send(),
                                ),
                              ),
                              // Mode switcher pill
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(
                                    AppConstants.radiusFull,
                                  ),
                                  border: Border.all(color: AppColors.border),
                                ),
                                padding: const EdgeInsets.all(2),
                                child: Row(
                                  children: [
                                    _modeBtn(
                                      icon: LucideIcons.headset,
                                      selected: isSupport,
                                      onTap: () =>
                                          cubit.switchMode(ChatMode.support),
                                    ),
                                    _modeBtn(
                                      icon: LucideIcons.scale,
                                      selected: isLegal,
                                      onTap: () =>
                                          cubit.switchMode(ChatMode.legal),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
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
                        onPressed: () => _send(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _modeBtn({
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(AppConstants.radiusFull),
        ),
        child: Icon(
          icon,
          size: 14,
          color: selected ? Colors.white : AppColors.textMuted,
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, UnifiedAssistantState state) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  icon: const Icon(LucideIcons.plus, size: 16),
                  label: const Text('محادثة جديدة'),
                  onPressed: () {
                    context.read<UnifiedAssistantCubit>().newChat();
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(
                LucideIcons.headset,
                color: AppColors.primary,
                size: 18,
              ),
              title: Text(
                'تذاكر الدعم الفني (${state.tickets.length})',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Icon(
                _ticketsAccordionOpen
                    ? LucideIcons.chevron_up
                    : LucideIcons.chevron_down,
                size: 16,
              ),
              onTap: () => setState(
                () => _ticketsAccordionOpen = !_ticketsAccordionOpen,
              ),
            ),
            if (_ticketsAccordionOpen)
              Expanded(
                child: state.tickets.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'لا توجد تذاكر مفتوحة',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                        ),
                      )
                    : ListView.separated(
                        itemCount: state.tickets.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, i) {
                          final t = state.tickets[i];
                          return ListTile(
                            dense: true,
                            leading: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: t.isOpen
                                    ? AppColors.primary
                                    : AppColors.success,
                                shape: BoxShape.circle,
                              ),
                            ),
                            title: Text(
                              t.subject,
                              style: const TextStyle(fontSize: 12),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              _statusLabel(t.status),
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.textMuted,
                              ),
                            ),
                            trailing: const Icon(
                              LucideIcons.chevron_left,
                              size: 14,
                              color: AppColors.textMuted,
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              context
                                  .read<UnifiedAssistantCubit>()
                                  .setSelectedTicket(t.id);
                            },
                          );
                        },
                      ),
              ),
            if (_ticketsAccordionOpen) const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: OutlinedButton.icon(
                icon: const Icon(LucideIcons.refresh_cw, size: 14),
                label: const Text(
                  'تحديث التذاكر',
                  style: TextStyle(fontSize: 12),
                ),
                onPressed: state.ticketsLoading
                    ? null
                    : () => context.read<UnifiedAssistantCubit>().loadTickets(),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  String _statusLabel(String s) {
    switch (s.toUpperCase()) {
      case 'NEW':
        return 'جديد';
      case 'ASSIGNED':
        return 'معيّن';
      case 'IN_PROGRESS':
        return 'قيد المعالجة';
      case 'WAITING':
        return 'بانتظار العميل';
      case 'CLOSED':
        return 'مغلق';
      default:
        return s;
    }
  }

  Widget _buildEmptyState(bool isLegal) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingLg),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColors.primaryTint,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isLegal ? LucideIcons.scale : LucideIcons.bot,
                size: 48,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isLegal
                  ? 'مرحباً بك في المستشار القانوني العقاري'
                  : 'مرحباً بك في خدمة عملاء PropMatch',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              isLegal
                  ? 'اسأل عن قوانين الإيجارات، مدد العقود، والزيادات القانونية بموجب القانون رقم 4'
                  : 'اسأل المساعد الذكي عن استخدام المنصة، الاشتراكات، أو متابعة الطلبات',
              style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            if (isLegal)
              ..._legalPrompts.map(
                (prompt) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    onTap: () => _sendPrompt(prompt),
                    borderRadius: BorderRadius.circular(
                      AppConstants.radiusFull,
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusFull,
                        ),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            LucideIcons.sparkles,
                            size: 14,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              prompt,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Icon(
                            LucideIcons.arrow_left,
                            size: 14,
                            color: AppColors.textMuted,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            if (!isLegal)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'بدّل إلى المستشار القانوني من الشريط السفلي للأسئلة القانونية',
                  style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBubble(UnifiedChatMessage m) {
    final isUser = m.role == ChatRole.user;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.82,
        ),
        decoration: BoxDecoration(
          color: isUser
              ? AppColors.primary
              : (m.declined
                    ? AppColors.pending.withValues(alpha: 0.1)
                    : AppColors.background),
          borderRadius: BorderRadius.circular(AppConstants.radiusMd).copyWith(
            bottomRight: isUser ? Radius.zero : null,
            bottomLeft: !isUser ? Radius.zero : null,
          ),
          border: isUser ? null : Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isUser)
              Text(
                m.content,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.4,
                ),
              )
            else
              MarkdownBody(
                data: m.content,
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
            if (!isUser && m.suggestedGuide.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Divider(height: 1),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: m.suggestedGuide.map((g) {
                  String label;
                  if (g == 'KYC_GUIDE') {
                    label = '💳 بدء التوثيق الإلكتروني';
                  } else if (g == 'PROPERTY_GUIDE') {
                    label = '🏠 إضافة عقار جديد';
                  } else if (g == 'REQUEST_GUIDE') {
                    label = '📋 نشر طلب سكن جديد';
                  } else {
                    label = g;
                  }

                  return ActionChip(
                    label: Text(label, style: const TextStyle(fontSize: 11)),
                    onPressed: () {},
                  );
                }).toList(),
              ),
            ],
            if (m.escalated && m.ticketId != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  'تم تحويلك لتذكرة: ${m.ticketId}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingIndicator(bool isLegal) {
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
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              isLegal ? 'جارٍ صياغة الاستشارة القانونية...' : 'المساعد يكتب...',
              style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}

class _TicketThreadView extends StatefulWidget {
  final String ticketId;
  final VoidCallback onBack;
  const _TicketThreadView({required this.ticketId, required this.onBack});
  @override
  State<_TicketThreadView> createState() => _TicketThreadViewState();
}

class _TicketThreadViewState extends State<_TicketThreadView> {
  late Future<TicketDetailEntity> _future;
  bool _sending = false;
  final _replyCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _future = sl<UnifiedAssistantRepository>().getTicketDetail(widget.ticketId);
  }

  Future<void> _reload() async {
    setState(
      () => _future = sl<UnifiedAssistantRepository>().getTicketDetail(
        widget.ticketId,
      ),
    );
  }

  Future<void> _send(TicketDetailEntity ticket) async {
    final text = _replyCtrl.text.trim();
    if (text.isEmpty || _sending) return;
    setState(() => _sending = true);
    try {
      await sl<UnifiedAssistantRepository>().replyToTicket(
        ticket.id,
        content: text,
      );
      _replyCtrl.clear();
      await _reload();
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('فشل الإرسال: $e')));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  void dispose() {
    _replyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TicketDetailEntity>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting)
          return const Center(child: CircularProgressIndicator());
        if (snap.hasError || !snap.hasData) {
          final err = snap.error;
          String msg = 'تعذر تحميل التذكرة';
          if (err != null) {
            final s = err.toString();
            if (s.contains('401') || s.contains('AuthException')) {
              msg = 'انتهت صلاحية الجلسة، يرجى تسجيل الدخول مرة أخرى';
            } else if (s.contains('404')) {
              msg = 'التذكرة غير موجودة';
            } else if (s.contains('429')) {
              msg = 'تم تجاوز الحد المسموح، حاول مرة أخرى بعد دقيقة';
            } else {
              // Use handleDioError friendly message if DioException
              msg = 'تعذر تحميل التذكرة: ${s.split(':').last.trim()}';
            }
          }
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(LucideIcons.circle_alert, size: 36, color: AppColors.error),
                  const SizedBox(height: 12),
                  Text(msg, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13)),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: _reload,
                    icon: const Icon(LucideIcons.refresh_cw, size: 14),
                    label: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            ),
          );
        }
        final ticket = snap.data!;
        final isClosed = ticket.status.toUpperCase() == 'CLOSED';
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              color: AppColors.background,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      ticket.subject,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryTint,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      ticket.status,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: ticket.messages.length,
                itemBuilder: (context, i) {
                  final m = ticket.messages[i];
                  final isUser = m.isUser;
                  return Align(
                    alignment: isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.8,
                      ),
                      decoration: BoxDecoration(
                        color: isUser
                            ? AppColors.primary
                            : AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                        border: isUser
                            ? null
                            : Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${m.authorName} • ${m.createdAt.substring(0, 16)}',
                            style: TextStyle(
                              fontSize: 10,
                              color: isUser
                                  ? Colors.white70
                                  : AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            m.content,
                            style: TextStyle(
                              color: isUser
                                  ? Colors.white
                                  : AppColors.textPrimary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            if (!isClosed)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: AppColors.border)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _replyCtrl,
                        decoration: InputDecoration(
                          hintText: 'اكتب رداً لموظف الدعم…',
                          filled: true,
                          fillColor: AppColors.background,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: const BorderSide(
                              color: AppColors.border,
                            ),
                          ),
                        ),
                        onSubmitted: (_) => _send(ticket),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      onPressed: _sending ? null : () => _send(ticket),
                      icon: _sending
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(LucideIcons.send_horizontal, size: 16),
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              )
            else
              const Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  'تم إغلاق هذه التذكرة.',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }
}
