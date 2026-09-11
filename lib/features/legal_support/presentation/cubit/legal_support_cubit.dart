import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:propmatch_mobile/features/legal_support/domain/entities/legal_message_entity.dart';
import 'package:propmatch_mobile/features/legal_support/domain/repositories/legal_support_repository.dart';

abstract class LegalSupportState extends Equatable {
  const LegalSupportState();
  @override
  List<Object?> get props => [];
}

class LegalSupportInitial extends LegalSupportState {
  final List<LegalMessageEntity> messages;
  const LegalSupportInitial({this.messages = const []});

  @override
  List<Object?> get props => [messages];
}

class LegalSupportSending extends LegalSupportState {
  final List<LegalMessageEntity> messages;
  const LegalSupportSending({required this.messages});

  @override
  List<Object?> get props => [messages];
}

class LegalSupportLoaded extends LegalSupportState {
  final List<LegalMessageEntity> messages;
  const LegalSupportLoaded({required this.messages});

  @override
  List<Object?> get props => [messages];
}

class LegalSupportError extends LegalSupportState {
  final List<LegalMessageEntity> messages;
  final String error;
  const LegalSupportError({required this.messages, required this.error});

  @override
  List<Object?> get props => [messages, error];
}

class LegalSupportCubit extends Cubit<LegalSupportState> {
  final LegalSupportRepository repository;

  LegalSupportCubit({required this.repository}) : super(const LegalSupportInitial());

  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final currentMessages = _getCurrentMessages();
    final userMsg = LegalMessageEntity(
      id: 'u_${DateTime.now().millisecondsSinceEpoch}',
      role: LegalMessageRole.user,
      content: trimmed,
      createdAt: DateTime.now(),
    );

    final updated = List<LegalMessageEntity>.from(currentMessages)..add(userMsg);
    emit(LegalSupportSending(messages: updated));

    try {
      final assistantMsg = await repository.sendMessage(trimmed);
      final finalMessages = List<LegalMessageEntity>.from(updated)..add(assistantMsg);
      emit(LegalSupportLoaded(messages: finalMessages));
    } catch (e) {
      final fallbackMsg = LegalMessageEntity(
        id: 'err_${DateTime.now().millisecondsSinceEpoch}',
        role: LegalMessageRole.assistant,
        content: 'تعذر الاتصال بخدمة المساعد القانوني، يرجى المحاولة مرة أخرى.',
        declined: true,
        createdAt: DateTime.now(),
      );
      final errorMessages = List<LegalMessageEntity>.from(updated)..add(fallbackMsg);
      emit(LegalSupportError(messages: errorMessages, error: e.toString()));
    }
  }

  List<LegalMessageEntity> _getCurrentMessages() {
    if (state is LegalSupportInitial) {
      return (state as LegalSupportInitial).messages;
    } else if (state is LegalSupportSending) {
      return (state as LegalSupportSending).messages;
    } else if (state is LegalSupportLoaded) {
      return (state as LegalSupportLoaded).messages;
    } else if (state is LegalSupportError) {
      return (state as LegalSupportError).messages;
    }
    return [];
  }
}
