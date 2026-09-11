import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:propmatch_mobile/features/ekyc/domain/entities/verification_entity.dart';
import 'package:propmatch_mobile/features/ekyc/domain/repositories/ekyc_repository.dart';

abstract class EkycState extends Equatable {
  const EkycState();
  @override
  List<Object?> get props => [];
}

class EkycInitial extends EkycState {}

class EkycLoading extends EkycState {}

class EkycLoaded extends EkycState {
  final VerificationEntity verification;
  const EkycLoaded(this.verification);

  @override
  List<Object?> get props => [verification];
}

class EkycSubmitting extends EkycState {
  final VerificationEntity? previousVerification;
  const EkycSubmitting({this.previousVerification});

  @override
  List<Object?> get props => [previousVerification];
}

class EkycSubmitSuccess extends EkycState {
  final VerificationEntity verification;
  const EkycSubmitSuccess(this.verification);

  @override
  List<Object?> get props => [verification];
}

class EkycError extends EkycState {
  final String message;
  const EkycError(this.message);

  @override
  List<Object?> get props => [message];
}

class EkycCubit extends Cubit<EkycState> {
  final EkycRepository repository;

  EkycCubit({required this.repository}) : super(EkycInitial());

  Future<void> fetchVerificationStatus() async {
    emit(EkycLoading());
    try {
      final verification = await repository.getMyVerification();
      emit(EkycLoaded(verification));
    } catch (e) {
      emit(EkycError(e.toString()));
    }
  }

  Future<void> submitVerification({
    required String nationalId,
    required File nationalIdFront,
    required File nationalIdBack,
    required File selfie,
  }) async {
    final currentStatus = state is EkycLoaded ? (state as EkycLoaded).verification : null;
    emit(EkycSubmitting(previousVerification: currentStatus));
    try {
      final verification = await repository.submitVerification(
        nationalId: nationalId,
        nationalIdFront: nationalIdFront,
        nationalIdBack: nationalIdBack,
        selfie: selfie,
      );
      emit(EkycSubmitSuccess(verification));
    } catch (e) {
      emit(EkycError(e.toString()));
    }
  }
}
