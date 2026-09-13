import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:propmatch_mobile/core/errors/exceptions.dart';
import 'package:propmatch_mobile/features/legal_support/domain/entities/unified_chat_entity.dart';
import 'package:propmatch_mobile/features/legal_support/domain/repositories/unified_assistant_repository.dart';

class UnifiedAssistantState extends Equatable {
  final ChatMode mode;
  final List<UnifiedChatMessage> supportMessages;
  final List<UnifiedChatMessage> legalMessages;
  final bool supportTyping;
  final bool legalTyping;
  final bool frustrated;
  final List<TicketSummaryEntity> tickets;
  final bool ticketsLoading;
  final String? selectedTicketId;
  final String? error;

  const UnifiedAssistantState({
    this.mode = ChatMode.support,
    this.supportMessages = const [],
    this.legalMessages = const [],
    this.supportTyping = false,
    this.legalTyping = false,
    this.frustrated = false,
    this.tickets = const [],
    this.ticketsLoading = false,
    this.selectedTicketId,
    this.error,
  });

  List<UnifiedChatMessage> get activeMessages => mode == ChatMode.legal ? legalMessages : supportMessages;
  bool get isTyping => mode == ChatMode.legal ? legalTyping : supportTyping;
  bool get hasOpenTicket => tickets.any((t) => t.isOpen);

  UnifiedAssistantState copyWith({
    ChatMode? mode,
    List<UnifiedChatMessage>? supportMessages,
    List<UnifiedChatMessage>? legalMessages,
    bool? supportTyping,
    bool? legalTyping,
    bool? frustrated,
    List<TicketSummaryEntity>? tickets,
    bool? ticketsLoading,
    String? selectedTicketId,
    String? error,
    bool clearSelected = false,
    bool clearError = false,
  }) {
    return UnifiedAssistantState(
      mode: mode ?? this.mode,
      supportMessages: supportMessages ?? this.supportMessages,
      legalMessages: legalMessages ?? this.legalMessages,
      supportTyping: supportTyping ?? this.supportTyping,
      legalTyping: legalTyping ?? this.legalTyping,
      frustrated: frustrated ?? this.frustrated,
      tickets: tickets ?? this.tickets,
      ticketsLoading: ticketsLoading ?? this.ticketsLoading,
      selectedTicketId: clearSelected ? null : (selectedTicketId ?? this.selectedTicketId),
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [mode, supportMessages, legalMessages, supportTyping, legalTyping, frustrated, tickets, ticketsLoading, selectedTicketId, error];
}

class UnifiedAssistantCubit extends Cubit<UnifiedAssistantState> {
  final UnifiedAssistantRepository repository;
  UnifiedAssistantCubit({required this.repository}) : super(const UnifiedAssistantState());

  void switchMode(ChatMode mode) {
    emit(state.copyWith(mode: mode, clearSelected: true, clearError: true));
  }

  void setSelectedTicket(String? id) {
    emit(state.copyWith(selectedTicketId: id, clearSelected: id == null));
  }

  void newChat() {
    if (state.mode == ChatMode.legal) {
      emit(state.copyWith(legalMessages: [], legalTyping: false, clearSelected: true, clearError: true));
    } else {
      emit(state.copyWith(supportMessages: [], supportTyping: false, frustrated: false, clearSelected: true, clearError: true));
    }
  }

  Future<void> loadTickets() async {
    emit(state.copyWith(ticketsLoading: true));
    try {
      final tickets = await repository.getMyTickets();
      emit(state.copyWith(tickets: tickets, ticketsLoading: false));
    } catch (_) {
      emit(state.copyWith(ticketsLoading: false));
    }
  }

  bool _isFrustrated(String message) {
    const keywords = ['نصابين', 'سيء جدا', 'خدمة زبالة', 'خصمتم', 'اشتكي', 'احتيال', 'مشكلة كبيرة', 'غير مقبول', 'أين الدعم'];
    var score = 0.0;
    for (final w in keywords) {
      if (message.contains(w)) score += 0.35;
    }
    return score >= 0.7;
  }

  String _uid(String prefix) => '${prefix}_${DateTime.now().millisecondsSinceEpoch}_${(DateTime.now().microsecondsSinceEpoch % 10000)}';

  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || state.isTyping) return;

    final isSupport = state.mode == ChatMode.support;
    if (isSupport && _isFrustrated(trimmed)) {
      emit(state.copyWith(frustrated: true));
    }

    final userMsg = UnifiedChatMessage(
      id: _uid('user'),
      role: ChatRole.user,
      content: trimmed,
      createdAt: DateTime.now(),
    );

    if (isSupport) {
      emit(state.copyWith(supportMessages: [...state.supportMessages, userMsg], supportTyping: true, clearError: true));
    } else {
      emit(state.copyWith(legalMessages: [...state.legalMessages, userMsg], legalTyping: true, clearError: true));
    }

    final replyId = _uid('assistant');
    var started = false;
    var acc = '';

    String uuidValue() {
      final now = DateTime.now().microsecondsSinceEpoch.toRadixString(16).padLeft(16, '0');
      return '${now.substring(0, 8)}-${now.substring(8, 12)}-4${now.substring(1, 3)}-a${now.substring(1, 3)}-${now.substring(0, 12)}';
    }

    final uuid = uuidValue();

    try {
      final stream = isSupport
          ? repository.streamSupportChat(trimmed, state.supportMessages, uuid)
          : repository.streamLegalChat(trimmed);

      StreamSubscription<StreamChunk>? sub;
      final completer = Completer<void>();
      bool? doneDeclined;
      bool? doneEscalated;
      String? doneTicketId;
      List<String>? doneGuide;

      sub = stream.listen(
        (chunk) {
          if (chunk.type == 'token') {
            final token = chunk.value ?? '';
            if (!started) {
              started = true;
              final placeholder = UnifiedChatMessage(
                id: replyId,
                role: ChatRole.assistant,
                content: '',
                createdAt: DateTime.now(),
              );
              if (isSupport) {
                emit(state.copyWith(supportMessages: [...state.supportMessages, placeholder], supportTyping: false));
              } else {
                emit(state.copyWith(legalMessages: [...state.legalMessages, placeholder], legalTyping: false));
              }
            }
            acc += token;
            if (isSupport) {
              final updated = state.supportMessages.map((m) => m.id == replyId ? m.copyWith(content: acc) : m).toList();
              emit(state.copyWith(supportMessages: updated));
            } else {
              final updated = state.legalMessages.map((m) => m.id == replyId ? m.copyWith(content: acc) : m).toList();
              emit(state.copyWith(legalMessages: updated));
            }
          } else {
            doneDeclined = chunk.declined;
            doneEscalated = chunk.escalated;
            doneTicketId = chunk.ticketId;
            doneGuide = chunk.suggestedGuide;
          }
        },
        onError: (e) {
          if (!completer.isCompleted) completer.completeError(e);
        },
        onDone: () {
          if (!completer.isCompleted) completer.complete();
        },
        cancelOnError: true,
      );

      await completer.future;
      await sub.cancel();

      if (!started) {
        // If no token ever arrived but done did, create message from done or fallback
        final fallback = doneEscalated == true ? 'تم إنشاء تذكرة دعم وتحويل طلبك إلى موظف مختص.' : acc;
        final msg = UnifiedChatMessage(
          id: replyId,
          role: ChatRole.assistant,
          content: fallback.isEmpty ? 'تعذر الحصول على إجابة الآن. حاول مرة أخرى.' : fallback,
          declined: doneDeclined ?? false,
          escalated: doneEscalated ?? false,
          ticketId: doneTicketId,
          suggestedGuide: doneGuide ?? [],
          createdAt: DateTime.now(),
        );
        if (isSupport) {
          emit(state.copyWith(supportMessages: [...state.supportMessages, msg], supportTyping: false, frustrated: doneEscalated == true ? false : state.frustrated));
        } else {
          emit(state.copyWith(legalMessages: [...state.legalMessages, msg], legalTyping: false));
        }
      } else {
        // update last message with declined/escalated
        if (isSupport) {
          final updated = state.supportMessages.map((m) => m.id == replyId ? m.copyWith(declined: doneDeclined, escalated: doneEscalated, ticketId: doneTicketId, suggestedGuide: doneGuide) : m).toList();
          emit(state.copyWith(supportMessages: updated, supportTyping: false, frustrated: doneEscalated == true ? false : state.frustrated));
          if (doneEscalated == true && doneTicketId != null) {
            emit(state.copyWith(selectedTicketId: doneTicketId));
            await loadTickets();
          }
        } else {
          final updated = state.legalMessages.map((m) => m.id == replyId ? m.copyWith(declined: doneDeclined) : m).toList();
          emit(state.copyWith(legalMessages: updated, legalTyping: false));
        }
      }
    } catch (e) {
      String msg = e is ServerException && e.statusCode == 429
          ? 'تم تجاوز الحد المسموح (20 رسالة في الدقيقة). يرجى الانتظار دقيقة ثم المحاولة مرة أخرى.'
          : e is ServerException
              ? e.message
              : e is AuthException
                  ? 'انتهت صلاحية الجلسة، يرجى تسجيل الدخول مرة أخرى'
                  : e.toString();
      // Extract friendly text if it's ServerException with generic Instance
      if (msg.contains('Instance of')) {
        msg = isSupport
            ? 'تعذر الاتصال بخدمة الدعم الآن، حاول مرة أخرى بعد قليل'
            : 'تعذر الحصول على إجابة قانونية الآن، حاول مرة أخرى بعد قليل';
      }
      final fallbackMsg = UnifiedChatMessage(
        id: replyId,
        role: ChatRole.assistant,
        content: e is ServerException && e.statusCode == 429
            ? msg
            : isSupport
                ? 'أنا المساعد الآلي لخدمة العملاء. إذا كنت ترغب في التحدث مع موظف دعم فني، انقر على زر التحويل أدناه.'
                : 'تعذر الحصول على إجابة قانونية الآن. حاول مرة أخرى بعد قليل.',
        createdAt: DateTime.now(),
      );
      if (isSupport) {
        // if placeholder already added, replace, otherwise append
        final exists = state.supportMessages.any((m) => m.id == replyId);
        if (exists) {
          final updated = state.supportMessages.map((m) => m.id == replyId ? fallbackMsg : m).toList();
          emit(state.copyWith(supportMessages: updated, supportTyping: false));
        } else {
          emit(state.copyWith(supportMessages: [...state.supportMessages, fallbackMsg], supportTyping: false));
        }
      } else {
        final exists = state.legalMessages.any((m) => m.id == replyId);
        if (exists) {
          final updated = state.legalMessages.map((m) => m.id == replyId ? fallbackMsg : m).toList();
          emit(state.copyWith(legalMessages: updated, legalTyping: false));
        } else {
          emit(state.copyWith(legalMessages: [...state.legalMessages, fallbackMsg], legalTyping: false));
        }
      }
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> escalateToHuman() async {
    if (state.hasOpenTicket || state.ticketsLoading) return;
    final lastUser = state.supportMessages.reversed.where((m) => m.role == ChatRole.user).firstOrNull?.content ?? 'استفسار خدمة العملاء';
    emit(state.copyWith(ticketsLoading: true));
    try {
      final ticket = await repository.createTicket(subject: lastUser.substring(0, lastUser.length.clamp(0, 50)), initialMessage: lastUser);
      emit(state.copyWith(frustrated: false, selectedTicketId: ticket.id, ticketsLoading: false));
      await loadTickets();
    } catch (e) {
      emit(state.copyWith(ticketsLoading: false, error: e.toString()));
      rethrow;
    }
  }
}
