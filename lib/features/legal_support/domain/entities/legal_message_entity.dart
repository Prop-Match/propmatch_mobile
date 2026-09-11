import 'package:equatable/equatable.dart';

enum LegalMessageRole { user, assistant }

class LegalMessageEntity extends Equatable {
  final String id;
  final LegalMessageRole role;
  final String content;
  final bool declined;
  final DateTime createdAt;

  const LegalMessageEntity({
    required this.id,
    required this.role,
    required this.content,
    this.declined = false,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, role, content, declined, createdAt];
}
