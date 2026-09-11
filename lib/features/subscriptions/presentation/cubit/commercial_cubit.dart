import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:propmatch_mobile/features/subscriptions/domain/entities/commercial_entity.dart';
import 'package:propmatch_mobile/features/subscriptions/domain/repositories/commercial_repository.dart';

abstract class CommercialState extends Equatable {
  const CommercialState();
  @override
  List<Object?> get props => [];
}

class CommercialInitial extends CommercialState {}

class CommercialLoading extends CommercialState {}

class CommercialLoaded extends CommercialState {
  final CommercialCatalogEntity catalog;
  final Map<String, dynamic> quota;
  final CheckoutResultEntity? checkoutResult;
  final bool isCheckingOut;
  final String? checkoutError;

  const CommercialLoaded({
    required this.catalog,
    required this.quota,
    this.checkoutResult,
    this.isCheckingOut = false,
    this.checkoutError,
  });

  CommercialLoaded copyWith({
    CommercialCatalogEntity? catalog,
    Map<String, dynamic>? quota,
    CheckoutResultEntity? checkoutResult,
    bool? isCheckingOut,
    String? checkoutError,
  }) {
    return CommercialLoaded(
      catalog: catalog ?? this.catalog,
      quota: quota ?? this.quota,
      checkoutResult: checkoutResult,
      isCheckingOut: isCheckingOut ?? this.isCheckingOut,
      checkoutError: checkoutError,
    );
  }

  @override
  List<Object?> get props => [catalog, quota, checkoutResult, isCheckingOut, checkoutError];
}

class CommercialError extends CommercialState {
  final String message;
  const CommercialError(this.message);

  @override
  List<Object?> get props => [message];
}

class CommercialCubit extends Cubit<CommercialState> {
  final CommercialRepository repository;

  CommercialCubit({required this.repository}) : super(CommercialInitial());

  Future<void> fetchCatalogAndQuota() async {
    emit(CommercialLoading());
    try {
      final catalog = await repository.getCatalog();
      Map<String, dynamic> quota = {};
      try {
        quota = await repository.getMyQuota();
      } catch (_) {
        // Quota is landlord-specific, ignore if tenant or empty
      }
      emit(CommercialLoaded(catalog: catalog, quota: quota));
    } catch (e) {
      emit(CommercialError(e.toString()));
    }
  }

  Future<void> checkout({
    required String paymentType,
    String? propertyId,
  }) async {
    if (state is! CommercialLoaded) return;
    final current = state as CommercialLoaded;

    emit(current.copyWith(isCheckingOut: true, checkoutError: null));
    try {
      final result = await repository.createCheckout(
        paymentType: paymentType,
        propertyId: propertyId,
      );
      emit(current.copyWith(
        isCheckingOut: false,
        checkoutResult: result,
      ));
    } catch (e) {
      emit(current.copyWith(
        isCheckingOut: false,
        checkoutError: e.toString(),
      ));
    }
  }
}
