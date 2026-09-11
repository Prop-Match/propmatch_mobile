import 'package:equatable/equatable.dart';

enum VerificationStatus {
  notSubmitted,
  pending,
  approved,
  rejected,
  resubmissionRequired;

  static VerificationStatus fromString(String? status) {
    switch (status) {
      case 'PENDING':
        return VerificationStatus.pending;
      case 'APPROVED':
        return VerificationStatus.approved;
      case 'REJECTED':
        return VerificationStatus.rejected;
      case 'RESUBMISSION_REQUIRED':
        return VerificationStatus.resubmissionRequired;
      case 'NOT_SUBMITTED':
      default:
        return VerificationStatus.notSubmitted;
    }
  }

  String toApiString() {
    switch (this) {
      case VerificationStatus.pending:
        return 'PENDING';
      case VerificationStatus.approved:
        return 'APPROVED';
      case VerificationStatus.rejected:
        return 'REJECTED';
      case VerificationStatus.resubmissionRequired:
        return 'RESUBMISSION_REQUIRED';
      case VerificationStatus.notSubmitted:
        return 'NOT_SUBMITTED';
    }
  }
}

class VerificationEntity extends Equatable {
  final VerificationStatus status;
  final String? rejectionReason;
  final DateTime? submittedAt;
  final DateTime? reviewedAt;
  final bool canSubmit;

  const VerificationEntity({
    required this.status,
    this.rejectionReason,
    this.submittedAt,
    this.reviewedAt,
    required this.canSubmit,
  });

  factory VerificationEntity.fromJson(Map<String, dynamic> json) {
    return VerificationEntity(
      status: VerificationStatus.fromString(json['status'] as String?),
      rejectionReason: json['rejectionReason'] as String?,
      submittedAt: json['submittedAt'] != null
          ? DateTime.tryParse(json['submittedAt'] as String)
          : null,
      reviewedAt: json['reviewedAt'] != null
          ? DateTime.tryParse(json['reviewedAt'] as String)
          : null,
      canSubmit: json['canSubmit'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [status, rejectionReason, submittedAt, reviewedAt, canSubmit];
}
